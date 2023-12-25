#ifndef GPUFIT_TTCM_CUH_INCLUDED
#define GPUFIT_TTCM_CUH_INCLUDED

#include <math.h>

// TTCM
__device__ void calculate_TTCM(
    REAL const * parameters,
    int const n_fits,
    int const n_points,
    REAL * value,
    REAL * derivative,
    int const point_index,
    int const fit_index,
    int const chunk_index,
    char * user_info,
    std::size_t const user_info_size)
{
    // indices

    REAL * user_info_float = (REAL*) user_info;
    REAL x = 0;
    if (!user_info_float)
    {
        x = point_index;
    }
    else if (user_info_size / sizeof(REAL) == n_points)
    {
        x = user_info_float[point_index];
    }
    else if (user_info_size / sizeof(REAL) > n_points)
    {
        int const chunk_begin = chunk_index * n_fits * n_points;
        int const fit_begin = fit_index * n_points;
        x = user_info_float[chunk_begin + fit_begin + point_index];
    }
    // parameters
    REAL const* p = parameters;
    REAL const k1 = p[0];
    REAL const k2 = p[1];
    REAL const k3 = p[2];
    REAL const k4 = p[3];
    // value
    //REAL const argx = (x - p[1]) * (x - p[1]) / (2 * p[2] * p[2]);
    //REAL const ex = exp(-argx);
    // Input function values (input function type: Exp4)
    REAL const A1 = 60.5952874645171;
    REAL const B1 = 2.18366239228297;
    REAL const A2 = 425.780392014689;
    REAL const B2 = 125.516793251864;
    REAL const A3 = -501.549848204776;
    REAL const B3 = 499.315539547726;
    REAL const A4 = 15.1741650257247;
    REAL const B4 = 0.0168356834225634;
    // Defining some constants
    REAL const alpha = ((k2+k3+k4) + sqrt(pow(k2+k3+k4,2) - (4*k2*k4))) / 2.0;
    REAL const beta = ((k2 + k3 + k4) - sqrt(pow(k2 + k3 + k4, 2) - (4 * k2 * k4))) / 2.0;
    // Value of C_tot (C1+C2)
    value[point_index] = (((k1 * (alpha - k4) - k1 * k3) / (alpha - beta)) * (((A1 / (alpha - B1)) * (exp(-1 * B1 * x) - exp(-1 * alpha * x))) + ((A2 / (alpha - B2)) * (exp(-1 * B2 * x) - exp(-1 * alpha * x))) + ((A3 / (alpha - B3)) * (exp(-1 * B3 * x) - exp(-1 * alpha * x))) + ((A4 / (alpha - B4)) * (exp(-1 * B4 * x) - exp(-1 * alpha * x))))) + (((k1 * k3 - (k1 * (beta - k4))) / (alpha - beta)) * (((A1 / (beta - B1)) * (exp(-1 * B1 * x) - exp(-1 * beta * x))) + ((A2 / (beta - B2)) * (exp(-1 * B2 * x) - exp(-1 * beta * x))) + ((A3 / (beta - B3)) * (exp(-1 * B3 * x) - exp(-1 * beta * x))) + ((A4 / (beta - B4)) * (exp(-1 * B4 * x) - exp(-1 * beta * x)))));
    // derivatives
    REAL * current_derivatives = derivative + point_index;
    current_derivatives[0 * n_points] = -((k3 / 2 - k2 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2))) / sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) - ((k2 / 2 - k3 / 2 - k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2))) / sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4);
    current_derivatives[1 * n_points] = ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * (2 * k2 + 2 * k3 - 2 * k4) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / (2 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 1.5)) - ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((A1 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / pow(k2 / 2 - B1 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A2 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / pow(k2 / 2 - B2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A3 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / pow(k2 / 2 - B3 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A4 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / pow(k2 / 2 - B4 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A1 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2)) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2)) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2)) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2)) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) - (k1 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) - (k1 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) - ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((A1 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / pow(k2 / 2 - B1 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A2 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / pow(k2 / 2 - B2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A3 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / pow(k2 / 2 - B3 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A4 * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / pow(k2 / 2 - B4 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A1 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2)) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2)) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2)) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k2 + 2 * k3 - 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2)) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) - ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * (2 * k2 + 2 * k3 - 2 * k4) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / (2 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 1.5));
    current_derivatives[2 * n_points] = ((k1 - k1 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) + 1 / 2)) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2))) / sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) - ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((A1 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B1 * x))) / pow(k2 / 2 - B1 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2, 2) + (A2 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B2 * x))) / pow(k2 / 2 - B2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2, 2) + (A3 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B3 * x))) / pow(k2 / 2 - B3 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2, 2) + (A4 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B4 * x))) / pow(k2 / 2 - B4 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2, 2) + (A1 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) + 1 / 2)) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A2 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) + 1 / 2)) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A3 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) + 1 / 2)) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A4 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) + 1 / 2)) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2))) / sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) - ((k1 + k1 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) - 1 / 2)) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2))) / sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) - ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((A1 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B1 * x))) / pow(k2 / 2 - B1 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2, 2) + (A2 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B2 * x))) / pow(k2 / 2 - B2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2, 2) + (A3 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B3 * x))) / pow(k2 / 2 - B3 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2, 2) + (A4 * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B4 * x))) / pow(k2 / 2 - B4 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2, 2) + (A1 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) - 1 / 2)) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A2 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) - 1 / 2)) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A3 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) - 1 / 2)) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A4 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * ((2 * k2 + 2 * k3 + 2 * k4) / (4 * sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4)) - 1 / 2)) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2))) / sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) + ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * (2 * k2 + 2 * k3 + 2 * k4) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2))) / (2 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 1.5)) - ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) * (2 * k2 + 2 * k3 + 2 * k4) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + sqrt(pow(k2 + k3 + k4, 2) - 4 * k2 * k4) / 2))) / (2 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 1.5));
    current_derivatives[3 * n_points] = ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * (2 * k3 - 2 * k2 + 2 * k4) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / (2 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 1.5)) - ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((A1 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / pow(k2 / 2 - B1 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A2 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / pow(k2 / 2 - B2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A3 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / pow(k2 / 2 - B3 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A4 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / pow(k2 / 2 - B4 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A1 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2)) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2)) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2)) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2)) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) - (k1 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) - (k1 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) + 1 / 2) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) - ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((A1 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / pow(k2 / 2 - B1 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A2 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / pow(k2 / 2 - B2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A3 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / pow(k2 / 2 - B3 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A4 * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2) * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / pow(k2 / 2 - B4 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2, 2) + (A1 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2)) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2)) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2)) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * x * exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * ((2 * k3 - 2 * k2 + 2 * k4) / (4 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5)) - 1 / 2)) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 - pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) - ((k1 * k3 - k1 * (k2 / 2 + k3 / 2 - k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) * (2 * k3 - 2 * k2 + 2 * k4) * ((A1 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B1 * x))) / (k2 / 2 - B1 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A2 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B2 * x))) / (k2 / 2 - B2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A3 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B3 * x))) / (k2 / 2 - B3 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2) + (A4 * (exp(-x * (k2 / 2 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2)) - exp(-B4 * x))) / (k2 / 2 - B4 + k3 / 2 + k4 / 2 + pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 0.5) / 2))) / (2 * pow(pow(k2 + k3 + k4, 2) - 4 * k2 * k4, 1.5));
}
#endif


