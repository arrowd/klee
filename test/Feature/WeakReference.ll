; RUN: llvm-as %s -f -o %t1.bc
; RUN: rm -rf %t.klee-out
; RUN: %klee --output-dir=%t.klee-out --optimize=false %t1.bc

module asm ".weak _thread_init"
module asm ".equ _thread_init, _thread_init_stub"
module asm ".weak _thread_autoinit_dummy_decl"
module asm ".equ _thread_autoinit_dummy_decl, _thread_autoinit_dummy_decl_stub"

@_thread_autoinit_dummy_decl = external global i32
@_thread_autoinit_dummy_decl_stub = dso_local local_unnamed_addr global i32 0, align 4

declare void @_thread_init()
; Function Attrs: norecurse nounwind readnone sspstrong uwtable
define dso_local void @_thread_init_stub() {
  ret void
}

define i32 @main() {
  %x = load i32, i32* @_thread_autoinit_dummy_decl
  call void @_thread_init()
  ret i32 0
}
