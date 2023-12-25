//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// TTCM_analytic_Multi_GPU_initialize.h
//
// Code generation for function 'TTCM_analytic_Multi_GPU_initialize'
//

#pragma once

// Include files
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Custom Header Code

#ifdef __CUDA_ARCH__
#undef printf
#endif

// Function Declarations
void TTCM_analytic_Multi_GPU_initialize();

// End of code generation (TTCM_analytic_Multi_GPU_initialize.h)
