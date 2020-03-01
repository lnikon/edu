#include <iostream>
#include <stdio.h>
#include <memory.h>
#include <string.h>
#include <math.h>


#define VCOUNT 5
#define ECOUNT 12

/*
 0 - -- - 1
  -     -
    -  -
      2
    -  -
  -     -
 3 - -- - 4
*/

bool frontierNotEmpty(bool* pFrontier, const int size);
void print(bool* p, const int size, const int unit);

__global__ void bfs_kernel(int* pV, 
                           int* pE, 
                           bool* pF, 
                           bool* pX, 
                           int* pC, 
                           const int vcount, 
                           const int ecount,
                           bool* done)
{
    const int tid = threadIdx.x + blockIdx.x * blockDim.x;
    // printf("tid = %d\n", tid);
    if (tid > VCOUNT) { *done = false; }
    // printf("done = %d\n", *done);

    if (pF[tid] == true && pX[tid] == false)
    {
        printf("tid = %d\n", tid);
        pF[tid] = false;
        pX[tid] = true;
        __syncthreads();

        const int nidStart = pV[tid];
        
        int nidEnd = -1;
        if (tid >= vcount)
        {
            nidEnd = pV[tid + 1];
        }
        else
        {
            nidEnd = ecount;
        }

        // printf("nidStart = %d\n", nidStart);
        // printf("nidEnd = %d\n", nidEnd);

        for (int nid = nidStart; nid < nidEnd; ++nid)
        {
            if (!pX[nid])
            {
                pC[nid] = pC[tid] + 1;
                pF[nid] = true;
                *done = false;
            }
        }
    }
}

int main()
{
    // Allocate space for vertex, edge, frontier, visit and cost arrays
    int*  pVertices  = new int[VCOUNT];
    int*  pEdges     = new int[ECOUNT];
    bool* pFrontier  = new bool[VCOUNT];
    bool* pVisited   = new bool[VCOUNT];
    int*  pCost      = new int[VCOUNT];

    // Initialize arrays
    for (int i = 0; i < VCOUNT; ++i)
    {
        pVertices[i] = i;
        pFrontier[i] = false;
        pVisited[i] = false;
        pCost[i] = INT_MAX;
    }

    pEdges[0] = 1; pEdges[1] = 2;
    pEdges[2] = 0; pEdges[3] = 2;
    pEdges[4] = 0; pEdges[5] = 1; pEdges[6] = 3; pEdges[7] = 4;
    pEdges[8] = 2; pEdges[9] = 4;
    pEdges[10] = 2; pEdges[11] = 3;

    int*  d_pVertices;
    int*  d_pEdges;
    bool* d_pFrontier;
    bool* d_pVisited;
    int*  d_pCost;

    cudaMalloc((void **)&d_pVertices,   sizeof(int) * VCOUNT);
    cudaMalloc((void **)&d_pEdges,      sizeof(int) * ECOUNT);
    cudaMalloc((void **)&d_pFrontier,   sizeof(bool) * VCOUNT);
    cudaMalloc((void **)&d_pVisited,    sizeof(bool) * VCOUNT);
    cudaMalloc((void **)&d_pCost,       sizeof(int) * VCOUNT);

    int source = 2;
    pFrontier[source] = true;
    pCost[source] = 0;

    cudaMemcpy(d_pVertices, pVertices,  sizeof(int) * VCOUNT, cudaMemcpyHostToDevice);
    cudaMemcpy(d_pEdges,    pEdges,     sizeof(int) * ECOUNT, cudaMemcpyHostToDevice);
    cudaMemcpy(d_pFrontier, pFrontier,  sizeof(bool) * VCOUNT, cudaMemcpyHostToDevice);
    cudaMemcpy(d_pVisited,  pVisited,   sizeof(bool) * VCOUNT, cudaMemcpyHostToDevice);
    cudaMemcpy(d_pCost,     pCost,      sizeof(int) * VCOUNT, cudaMemcpyHostToDevice);

    // Actual algorithm code goes here
    int count = 0;
    bool done = true;
    bool* d_done;
    cudaMalloc((void**)&d_done, sizeof(bool));
    do
    {
        ++count;
        done = true;
        cudaMemcpy(d_done, &done, sizeof(bool), cudaMemcpyHostToDevice);
        bfs_kernel<<<1, VCOUNT>>>(d_pVertices, 
                d_pEdges, 
                d_pFrontier, 
                d_pVisited, 
                d_pCost, 
                VCOUNT, 
                ECOUNT,
                d_done);            
        cudaMemcpy(&done, d_done, sizeof(bool), cudaMemcpyDeviceToHost);
    } while(!done);

    std::cout << "count: " << count << std::endl;

    delete pVertices;
    delete pEdges;
    delete pFrontier;
    delete pVisited;
    delete pCost;

    cudaFree(d_pVertices);
    cudaFree(d_pEdges);
    cudaFree(d_pFrontier);
    cudaFree(d_pVisited);
    cudaFree(d_pCost);

    return 0;
}

bool frontierNotEmpty(bool* pFrontier, const int size)
{
    for (int i = 0; i < size; ++i) if (pFrontier[i]) return true;
    return false;
}

void print(bool* p, const int size, const int unit)
{
    for (int i = 0; i < size; ++i) 
    {
        std::cout << p[i] << ' ';
    }
    std::cout << std::endl;
}
