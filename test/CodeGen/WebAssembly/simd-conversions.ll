; RUN: llc < %s -asm-verbose=false -wasm-keep-registers -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-enable-unimplemented-simd -mattr=+simd128,+sign-ext | FileCheck %s --check-prefixes CHECK,SIMD128
; RUN: llc < %s -asm-verbose=false -wasm-keep-registers -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=+simd128,+sign-ext | FileCheck %s --check-prefixes CHECK,SIMD128-VM
; RUN: llc < %s -asm-verbose=false -wasm-keep-registers -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=-simd128,+sign-ext | FileCheck %s --check-prefixes CHECK,NO-SIMD128

; Test that vector float-to-int and int-to-float instructions lower correctly

target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

; CHECK-LABEL: convert_s_v4f32:
; NO-SIMD128-NOT: i32x4
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f32x4.convert_s?i32x4 $push[[R:[0-9]+]]=, $0
; SIMD128-NEXT: return $pop[[R]]
define <4 x float> @convert_s_v4f32(<4 x i32> %x) {
  %a = sitofp <4 x i32> %x to <4 x float>
  ret <4 x float> %a
}

; CHECK-LABEL: convert_u_v4f32:
; NO-SIMD128-NOT: i32x4
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f32x4.convert_u?i32x4 $push[[R:[0-9]+]]=, $0
; SIMD128-NEXT: return $pop[[R]]
define <4 x float> @convert_u_v4f32(<4 x i32> %x) {
  %a = uitofp <4 x i32> %x to <4 x float>
  ret <4 x float> %a
}

; CHECK-LABEL: convert_s_v2f64:
; NO-SIMD128-NOT: i64x2
; SIMD128-VM-NOT: f64x2.convert_s?i64x2
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f64x2.convert_s?i64x2 $push[[R:[0-9]+]]=, $0
; SIMD128-NEXT: return $pop[[R]]
define <2 x double> @convert_s_v2f64(<2 x i64> %x) {
  %a = sitofp <2 x i64> %x to <2 x double>
  ret <2 x double> %a
}

; CHECK-LABEL: convert_u_v2f64:
; NO-SIMD128-NOT: i64x2
; SIMD128-VM-NOT: f64x2.convert_u?i64x2
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: f64x2.convert_u?i64x2 $push[[R:[0-9]+]]=, $0
; SIMD128-NEXT: return $pop[[R]]
define <2 x double> @convert_u_v2f64(<2 x i64> %x) {
  %a = uitofp <2 x i64> %x to <2 x double>
  ret <2 x double> %a
}

; CHECK-LABEL: trunc_saturating_s_v4i32:
; NO-SIMD128-NOT: f32x4
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i32x4.trunc_saturating_s?f32x4 $push[[R:[0-9]+]]=, $0
; SIMD128-NEXT: return $pop[[R]]
define <4 x i32> @trunc_saturating_s_v4i32(<4 x float> %x) {
  %a = fptosi <4 x float> %x to <4 x i32>
  ret <4 x i32> %a
}

; CHECK-LABEL: trunc_saturating_u_v4i32:
; NO-SIMD128-NOT: f32x4
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i32x4.trunc_saturating_u?f32x4 $push[[R:[0-9]+]]=, $0
; SIMD128-NEXT: return $pop[[R]]
define <4 x i32> @trunc_saturating_u_v4i32(<4 x float> %x) {
  %a = fptoui <4 x float> %x to <4 x i32>
  ret <4 x i32> %a
}

; CHECK-LABEL: trunc_saturating_s_v2i64:
; NO-SIMD128-NOT: f64x2
; SIMD128-VM-NOT: i64x2.trunc_saturating_s?f64x2
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i64x2.trunc_saturating_s?f64x2 $push[[R:[0-9]+]]=, $0
; SIMD128-NEXT: return $pop[[R]]
define <2 x i64> @trunc_saturating_s_v2i64(<2 x double> %x) {
  %a = fptosi <2 x double> %x to <2 x i64>
  ret <2 x i64> %a
}

; CHECK-LABEL: trunc_saturating_u_v2i64:
; NO-SIMD128-NOT: f64x2
; SIMD128-VM-NOT: i64x2.trunc_saturating_u?f64x2
; SIMD128-NEXT: .param v128{{$}}
; SIMD128-NEXT: .result v128{{$}}
; SIMD128-NEXT: i64x2.trunc_saturating_u?f64x2 $push[[R:[0-9]+]]=, $0
; SIMD128-NEXT: return $pop[[R]]
define <2 x i64> @trunc_saturating_u_v2i64(<2 x double> %x) {
  %a = fptoui <2 x double> %x to <2 x i64>
  ret <2 x i64> %a
}
