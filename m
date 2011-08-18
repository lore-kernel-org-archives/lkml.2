Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1HRTGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:06:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47475 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1HRTGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:06:41 -0400
Date: Thu, 18 Aug 2011 20:06:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 46/91] um: take arch/um/sys-x86 to arch/x86/um
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7vL-0007ll-Mn@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile                                   |   22 +++++++++++--------
 arch/um/os-Linux/Makefile                          |    2 +-
 arch/um/scripts/Makefile.rules                     |    5 ----
 arch/{um/Makefile-x86 => x86/Makefile.um}          |    2 +-
 arch/{um/Kconfig.x86 => x86/um/Kconfig}            |    0
 arch/{um/sys-x86 => x86/um}/Makefile               |   16 +++++++-------
 arch/{um/sys-x86 => x86/um}/asm/arch_hweight.h     |    0
 arch/{um/sys-x86 => x86/um}/asm/archparam.h        |    0
 arch/{um/sys-x86 => x86/um}/asm/checksum.h         |    0
 arch/{um/sys-x86 => x86/um}/asm/checksum_32.h      |    0
 arch/{um/sys-x86 => x86/um}/asm/checksum_64.h      |    0
 arch/{um/sys-x86 => x86/um}/asm/elf.h              |    0
 arch/{um/sys-x86 => x86/um}/asm/module.h           |    0
 arch/{um/sys-x86 => x86/um}/asm/processor.h        |    0
 arch/{um/sys-x86 => x86/um}/asm/processor_32.h     |    0
 arch/{um/sys-x86 => x86/um}/asm/processor_64.h     |    0
 arch/{um/sys-x86 => x86/um}/asm/ptrace.h           |    0
 arch/{um/sys-x86 => x86/um}/asm/ptrace_32.h        |    0
 arch/{um/sys-x86 => x86/um}/asm/ptrace_64.h        |    0
 arch/{um/sys-x86 => x86/um}/asm/system.h           |    0
 arch/{um/sys-x86 => x86/um}/asm/vm-flags.h         |    0
 arch/{um/sys-x86 => x86/um}/bug.c                  |    0
 arch/{um/sys-x86 => x86/um}/bugs_32.c              |    0
 arch/{um/sys-x86 => x86/um}/bugs_64.c              |    0
 arch/{um/sys-x86 => x86/um}/checksum_32.S          |    0
 arch/{um/sys-x86 => x86/um}/delay_32.c             |    0
 arch/{um/sys-x86 => x86/um}/delay_64.c             |    0
 arch/{um/sys-x86 => x86/um}/elfcore.c              |    0
 arch/{um/sys-x86 => x86/um}/fault.c                |    0
 arch/{um/sys-x86 => x86/um}/ksyms.c                |    0
 arch/{um/sys-x86 => x86/um}/ldt.c                  |    0
 arch/{um/sys-x86 => x86/um}/mem_32.c               |    0
 arch/{um/sys-x86 => x86/um}/mem_64.c               |    0
 .../os-Linux/sys-x86 => x86/um/os-Linux}/Makefile  |    0
 .../sys-x86 => x86/um/os-Linux}/mcontext.c         |    0
 .../os-Linux/sys-x86 => x86/um/os-Linux}/prctl.c   |    0
 .../sys-x86 => x86/um/os-Linux}/registers.c        |    0
 .../sys-x86 => x86/um/os-Linux}/task_size.c        |    0
 .../{um/os-Linux/sys-x86 => x86/um/os-Linux}/tls.c |    0
 arch/{um/sys-x86 => x86/um}/ptrace_32.c            |    0
 arch/{um/sys-x86 => x86/um}/ptrace_64.c            |    0
 arch/{um/sys-x86 => x86/um}/ptrace_user.c          |    0
 arch/{um/sys-x86 => x86/um}/setjmp_32.S            |    0
 arch/{um/sys-x86 => x86/um}/setjmp_64.S            |    0
 .../sys-x86 => x86/um}/shared/sysdep/archsetjmp.h  |    0
 .../um}/shared/sysdep/archsetjmp_32.h              |    0
 .../um}/shared/sysdep/archsetjmp_64.h              |    0
 .../sys-x86 => x86/um}/shared/sysdep/faultinfo.h   |    0
 .../um}/shared/sysdep/faultinfo_32.h               |    0
 .../um}/shared/sysdep/faultinfo_64.h               |    0
 .../sys-x86 => x86/um}/shared/sysdep/host_ldt.h    |    0
 .../sys-x86 => x86/um}/shared/sysdep/host_ldt_32.h |    0
 .../sys-x86 => x86/um}/shared/sysdep/host_ldt_64.h |    0
 .../um}/shared/sysdep/kernel-offsets.h             |    0
 .../sys-x86 => x86/um}/shared/sysdep/mcontext.h    |    0
 arch/{um/sys-x86 => x86/um}/shared/sysdep/ptrace.h |    0
 .../sys-x86 => x86/um}/shared/sysdep/ptrace_32.h   |    0
 .../sys-x86 => x86/um}/shared/sysdep/ptrace_64.h   |    0
 .../sys-x86 => x86/um}/shared/sysdep/ptrace_user.h |    0
 .../um}/shared/sysdep/ptrace_user_32.h             |    0
 .../um}/shared/sysdep/ptrace_user_64.h             |    0
 .../sys-x86 => x86/um}/shared/sysdep/skas_ptrace.h |    0
 arch/{um/sys-x86 => x86/um}/shared/sysdep/stub.h   |    0
 .../{um/sys-x86 => x86/um}/shared/sysdep/stub_32.h |    0
 .../{um/sys-x86 => x86/um}/shared/sysdep/stub_64.h |    0
 .../sys-x86 => x86/um}/shared/sysdep/syscalls.h    |    0
 .../sys-x86 => x86/um}/shared/sysdep/syscalls_32.h |    0
 .../sys-x86 => x86/um}/shared/sysdep/syscalls_64.h |    0
 arch/{um/sys-x86 => x86/um}/shared/sysdep/tls.h    |    0
 arch/{um/sys-x86 => x86/um}/shared/sysdep/tls_32.h |    0
 arch/{um/sys-x86 => x86/um}/shared/sysdep/tls_64.h |    0
 arch/{um/sys-x86 => x86/um}/signal_32.c            |    0
 arch/{um/sys-x86 => x86/um}/signal_64.c            |    0
 arch/{um/sys-x86 => x86/um}/stub_32.S              |    0
 arch/{um/sys-x86 => x86/um}/stub_64.S              |    0
 arch/{um/sys-x86 => x86/um}/stub_segv.c            |    0
 arch/{um/sys-x86 => x86/um}/sys_call_table_32.S    |    0
 arch/{um/sys-x86 => x86/um}/sys_call_table_64.c    |    0
 arch/{um/sys-x86 => x86/um}/syscalls_32.c          |    0
 arch/{um/sys-x86 => x86/um}/syscalls_64.c          |    0
 arch/{um/sys-x86 => x86/um}/sysrq_32.c             |    0
 arch/{um/sys-x86 => x86/um}/sysrq_64.c             |    0
 arch/{um/sys-x86 => x86/um}/tls_32.c               |    0
 arch/{um/sys-x86 => x86/um}/tls_64.c               |    0
 arch/{um/sys-x86 => x86/um}/user-offsets.c         |    0
 arch/{um/sys-x86 => x86/um}/vdso/Makefile          |    0
 arch/{um/sys-x86 => x86/um}/vdso/checkundef.sh     |    0
 arch/{um/sys-x86 => x86/um}/vdso/um_vdso.c         |    0
 arch/{um/sys-x86 => x86/um}/vdso/vdso-layout.lds.S |    0
 arch/{um/sys-x86 => x86/um}/vdso/vdso-note.S       |    0
 arch/{um/sys-x86 => x86/um}/vdso/vdso.S            |    2 +-
 arch/{um/sys-x86 => x86/um}/vdso/vdso.lds.S        |    0
 arch/{um/sys-x86 => x86/um}/vdso/vma.c             |    0
 93 files changed, 24 insertions(+), 25 deletions(-)
 rename arch/{um/Makefile-x86 => x86/Makefile.um} (97%)
 rename arch/{um/Kconfig.x86 => x86/um/Kconfig} (100%)
 rename arch/{um/sys-x86 => x86/um}/Makefile (61%)
 rename arch/{um/sys-x86 => x86/um}/asm/arch_hweight.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/archparam.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/checksum.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/checksum_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/checksum_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/elf.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/module.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/processor.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/processor_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/processor_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/ptrace.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/ptrace_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/ptrace_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/system.h (100%)
 rename arch/{um/sys-x86 => x86/um}/asm/vm-flags.h (100%)
 rename arch/{um/sys-x86 => x86/um}/bug.c (100%)
 rename arch/{um/sys-x86 => x86/um}/bugs_32.c (100%)
 rename arch/{um/sys-x86 => x86/um}/bugs_64.c (100%)
 rename arch/{um/sys-x86 => x86/um}/checksum_32.S (100%)
 rename arch/{um/sys-x86 => x86/um}/delay_32.c (100%)
 rename arch/{um/sys-x86 => x86/um}/delay_64.c (100%)
 rename arch/{um/sys-x86 => x86/um}/elfcore.c (100%)
 rename arch/{um/sys-x86 => x86/um}/fault.c (100%)
 rename arch/{um/sys-x86 => x86/um}/ksyms.c (100%)
 rename arch/{um/sys-x86 => x86/um}/ldt.c (100%)
 rename arch/{um/sys-x86 => x86/um}/mem_32.c (100%)
 rename arch/{um/sys-x86 => x86/um}/mem_64.c (100%)
 rename arch/{um/os-Linux/sys-x86 => x86/um/os-Linux}/Makefile (100%)
 rename arch/{um/os-Linux/sys-x86 => x86/um/os-Linux}/mcontext.c (100%)
 rename arch/{um/os-Linux/sys-x86 => x86/um/os-Linux}/prctl.c (100%)
 rename arch/{um/os-Linux/sys-x86 => x86/um/os-Linux}/registers.c (100%)
 rename arch/{um/os-Linux/sys-x86 => x86/um/os-Linux}/task_size.c (100%)
 rename arch/{um/os-Linux/sys-x86 => x86/um/os-Linux}/tls.c (100%)
 rename arch/{um/sys-x86 => x86/um}/ptrace_32.c (100%)
 rename arch/{um/sys-x86 => x86/um}/ptrace_64.c (100%)
 rename arch/{um/sys-x86 => x86/um}/ptrace_user.c (100%)
 rename arch/{um/sys-x86 => x86/um}/setjmp_32.S (100%)
 rename arch/{um/sys-x86 => x86/um}/setjmp_64.S (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/archsetjmp.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/archsetjmp_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/archsetjmp_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/faultinfo.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/faultinfo_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/faultinfo_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/host_ldt.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/host_ldt_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/host_ldt_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/kernel-offsets.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/mcontext.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/ptrace.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/ptrace_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/ptrace_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/ptrace_user.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/ptrace_user_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/ptrace_user_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/skas_ptrace.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/stub.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/stub_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/stub_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/syscalls.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/syscalls_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/syscalls_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/tls.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/tls_32.h (100%)
 rename arch/{um/sys-x86 => x86/um}/shared/sysdep/tls_64.h (100%)
 rename arch/{um/sys-x86 => x86/um}/signal_32.c (100%)
 rename arch/{um/sys-x86 => x86/um}/signal_64.c (100%)
 rename arch/{um/sys-x86 => x86/um}/stub_32.S (100%)
 rename arch/{um/sys-x86 => x86/um}/stub_64.S (100%)
 rename arch/{um/sys-x86 => x86/um}/stub_segv.c (100%)
 rename arch/{um/sys-x86 => x86/um}/sys_call_table_32.S (100%)
 rename arch/{um/sys-x86 => x86/um}/sys_call_table_64.c (100%)
 rename arch/{um/sys-x86 => x86/um}/syscalls_32.c (100%)
 rename arch/{um/sys-x86 => x86/um}/syscalls_64.c (100%)
 rename arch/{um/sys-x86 => x86/um}/sysrq_32.c (100%)
 rename arch/{um/sys-x86 => x86/um}/sysrq_64.c (100%)
 rename arch/{um/sys-x86 => x86/um}/tls_32.c (100%)
 rename arch/{um/sys-x86 => x86/um}/tls_64.c (100%)
 rename arch/{um/sys-x86 => x86/um}/user-offsets.c (100%)
 rename arch/{um/sys-x86 => x86/um}/vdso/Makefile (100%)
 rename arch/{um/sys-x86 => x86/um}/vdso/checkundef.sh (100%)
 rename arch/{um/sys-x86 => x86/um}/vdso/um_vdso.c (100%)
 rename arch/{um/sys-x86 => x86/um}/vdso/vdso-layout.lds.S (100%)
 rename arch/{um/sys-x86 => x86/um}/vdso/vdso-note.S (100%)
 rename arch/{um/sys-x86 => x86/um}/vdso/vdso.S (70%)
 rename arch/{um/sys-x86 => x86/um}/vdso/vdso.lds.S (100%)
 rename arch/{um/sys-x86 => x86/um}/vdso/vma.c (100%)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 7492ee5..7730af6 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -30,13 +30,17 @@ ifeq ($(SUBARCH),x86_64)
         HEADER_ARCH := x86
 endif
 
+HOST_DIR := arch/$(HEADER_ARCH)
+
 include $(srctree)/$(ARCH_DIR)/Makefile-skas
-include $(srctree)/$(ARCH_DIR)/Makefile-$(HEADER_ARCH)
+include $(srctree)/$(HOST_DIR)/Makefile.um
+
+core-y += $(HOST_DIR)/um/
 
 SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
 ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
-ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(HEADER_ARCH)/shared
-KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(HEADER_ARCH)
+ARCH_INCLUDE	+= -I$(srctree)/$(HOST_DIR)/um/shared
+KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/um
 
 # -Dvmap=kernel_vmap prevents anything from referencing the libpcap.o symbol so
 # named - it's a common symbol in libpcap, so we get a binary which crashes.
@@ -60,7 +64,7 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 #This will adjust *FLAGS accordingly to the platform.
 include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 
-KBUILD_CPPFLAGS += -I$(srctree)/arch/$(HEADER_ARCH)/include
+KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/include
 
 # -Derrno=kernel_errno - This turns all kernel references to errno into
 # kernel_errno to separate them from the libc errno.  This allows -fno-common
@@ -90,7 +94,7 @@ define archhelp
   echo '		   find in the kernel root.'
 endef
 
-KBUILD_KCONFIG := arch/um/Kconfig.$(HEADER_ARCH)
+KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
 
 archprepare: include/generated/user_constants.h
 
@@ -131,8 +135,8 @@ archclean:
 
 # Generated files
 
-$(ARCH_DIR)/sys-$(HEADER_ARCH)/user-offsets.s: FORCE
-	$(Q)$(MAKE) $(build)=$(ARCH_DIR)/sys-$(HEADER_ARCH) $@
+$(HOST_DIR)/um/user-offsets.s: FORCE
+	$(Q)$(MAKE) $(build)=$(HOST_DIR)/um $@
 
 define filechk_gen-asm-offsets
         (set -e; \
@@ -147,7 +151,7 @@ define filechk_gen-asm-offsets
          echo ""; )
 endef
 
-include/generated/user_constants.h: $(ARCH_DIR)/sys-$(HEADER_ARCH)/user-offsets.s
+include/generated/user_constants.h: $(HOST_DIR)/um/user-offsets.s
 	$(call filechk,gen-asm-offsets)
 
-export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
+export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS DEV_NULL_PATH
diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index 7879e76..015d000 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -5,7 +5,7 @@
 
 obj-y = aio.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o tty.o \
-	umid.o tls.o user_syms.o util.o drivers/ sys-$(HEADER_ARCH)/ skas/
+	umid.o tls.o user_syms.o util.o drivers/ skas/
 
 obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
 
diff --git a/arch/um/scripts/Makefile.rules b/arch/um/scripts/Makefile.rules
index 3a7efb0..2eb2843 100644
--- a/arch/um/scripts/Makefile.rules
+++ b/arch/um/scripts/Makefile.rules
@@ -25,8 +25,3 @@ $(UNPROFILE_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
 define unprofile
 	$(patsubst -pg,,$(patsubst -fprofile-arcs -ftest-coverage,,$(1)))
 endef
-
-ifdef subarch-obj-y
-obj-y += subarch.o
-subarch-y = $(addprefix ../../$(HEADER_ARCH)/,$(subarch-obj-y))
-endif
diff --git a/arch/um/Makefile-x86 b/arch/x86/Makefile.um
similarity index 97%
rename from arch/um/Makefile-x86
rename to arch/x86/Makefile.um
index 68fbd1b..36ddec6 100644
--- a/arch/um/Makefile-x86
+++ b/arch/x86/Makefile.um
@@ -1,4 +1,4 @@
-core-y += arch/um/sys-x86/ arch/x86/crypto/
+core-y += arch/x86/crypto/
 
 ifeq ($(CONFIG_X86_32),y)
 START := 0x8048000
diff --git a/arch/um/Kconfig.x86 b/arch/x86/um/Kconfig
similarity index 100%
rename from arch/um/Kconfig.x86
rename to arch/x86/um/Kconfig
diff --git a/arch/um/sys-x86/Makefile b/arch/x86/um/Makefile
similarity index 61%
rename from arch/um/sys-x86/Makefile
rename to arch/x86/um/Makefile
index 81ab348..df41989 100644
--- a/arch/um/sys-x86/Makefile
+++ b/arch/x86/um/Makefile
@@ -11,28 +11,28 @@ endif
 obj-y = bug.o bugs_$(BITS).o delay_$(BITS).o fault.o ksyms.o ldt.o \
 	ptrace_$(BITS).o ptrace_user.o setjmp_$(BITS).o signal_$(BITS).o \
 	stub_$(BITS).o stub_segv.o syscalls_$(BITS).o \
-	sys_call_table_$(BITS).o sysrq_$(BITS).o tls_$(BITS).o mem_$(BITS).o
+	sys_call_table_$(BITS).o sysrq_$(BITS).o tls_$(BITS).o \
+	mem_$(BITS).o subarch.o os-$(OS)/
 
 ifeq ($(CONFIG_X86_32),y)
 
 obj-y += checksum_32.o
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
-subarch-obj-y = lib/string_32.o lib/atomic64_32.o lib/atomic64_cx8_32.o
-subarch-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += lib/rwsem.o
-subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
-subarch-obj-$(CONFIG_MODULES) += kernel/module.o
+subarch-y = ../lib/string_32.o ../lib/atomic64_32.o ../lib/atomic64_cx8_32.o
+subarch-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += ../lib/rwsem.o
+subarch-$(CONFIG_HIGHMEM) += ../mm/highmem_32.o
 
 else
 
 obj-y += vdso/
 
-subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
-		lib/rwsem.o
+subarch-y = ../lib/csum-partial_64.o ../lib/memcpy_64.o ../lib/thunk_64.o \
+		../lib/rwsem.o
 
 endif
 
-subarch-obj-$(CONFIG_MODULES) += kernel/module.o
+subarch-$(CONFIG_MODULES) += ../kernel/module.o
 
 USER_OBJS := bugs_$(BITS).o ptrace_user.o fault.o
 
diff --git a/arch/um/sys-x86/asm/arch_hweight.h b/arch/x86/um/asm/arch_hweight.h
similarity index 100%
rename from arch/um/sys-x86/asm/arch_hweight.h
rename to arch/x86/um/asm/arch_hweight.h
diff --git a/arch/um/sys-x86/asm/archparam.h b/arch/x86/um/asm/archparam.h
similarity index 100%
rename from arch/um/sys-x86/asm/archparam.h
rename to arch/x86/um/asm/archparam.h
diff --git a/arch/um/sys-x86/asm/checksum.h b/arch/x86/um/asm/checksum.h
similarity index 100%
rename from arch/um/sys-x86/asm/checksum.h
rename to arch/x86/um/asm/checksum.h
diff --git a/arch/um/sys-x86/asm/checksum_32.h b/arch/x86/um/asm/checksum_32.h
similarity index 100%
rename from arch/um/sys-x86/asm/checksum_32.h
rename to arch/x86/um/asm/checksum_32.h
diff --git a/arch/um/sys-x86/asm/checksum_64.h b/arch/x86/um/asm/checksum_64.h
similarity index 100%
rename from arch/um/sys-x86/asm/checksum_64.h
rename to arch/x86/um/asm/checksum_64.h
diff --git a/arch/um/sys-x86/asm/elf.h b/arch/x86/um/asm/elf.h
similarity index 100%
rename from arch/um/sys-x86/asm/elf.h
rename to arch/x86/um/asm/elf.h
diff --git a/arch/um/sys-x86/asm/module.h b/arch/x86/um/asm/module.h
similarity index 100%
rename from arch/um/sys-x86/asm/module.h
rename to arch/x86/um/asm/module.h
diff --git a/arch/um/sys-x86/asm/processor.h b/arch/x86/um/asm/processor.h
similarity index 100%
rename from arch/um/sys-x86/asm/processor.h
rename to arch/x86/um/asm/processor.h
diff --git a/arch/um/sys-x86/asm/processor_32.h b/arch/x86/um/asm/processor_32.h
similarity index 100%
rename from arch/um/sys-x86/asm/processor_32.h
rename to arch/x86/um/asm/processor_32.h
diff --git a/arch/um/sys-x86/asm/processor_64.h b/arch/x86/um/asm/processor_64.h
similarity index 100%
rename from arch/um/sys-x86/asm/processor_64.h
rename to arch/x86/um/asm/processor_64.h
diff --git a/arch/um/sys-x86/asm/ptrace.h b/arch/x86/um/asm/ptrace.h
similarity index 100%
rename from arch/um/sys-x86/asm/ptrace.h
rename to arch/x86/um/asm/ptrace.h
diff --git a/arch/um/sys-x86/asm/ptrace_32.h b/arch/x86/um/asm/ptrace_32.h
similarity index 100%
rename from arch/um/sys-x86/asm/ptrace_32.h
rename to arch/x86/um/asm/ptrace_32.h
diff --git a/arch/um/sys-x86/asm/ptrace_64.h b/arch/x86/um/asm/ptrace_64.h
similarity index 100%
rename from arch/um/sys-x86/asm/ptrace_64.h
rename to arch/x86/um/asm/ptrace_64.h
diff --git a/arch/um/sys-x86/asm/system.h b/arch/x86/um/asm/system.h
similarity index 100%
rename from arch/um/sys-x86/asm/system.h
rename to arch/x86/um/asm/system.h
diff --git a/arch/um/sys-x86/asm/vm-flags.h b/arch/x86/um/asm/vm-flags.h
similarity index 100%
rename from arch/um/sys-x86/asm/vm-flags.h
rename to arch/x86/um/asm/vm-flags.h
diff --git a/arch/um/sys-x86/bug.c b/arch/x86/um/bug.c
similarity index 100%
rename from arch/um/sys-x86/bug.c
rename to arch/x86/um/bug.c
diff --git a/arch/um/sys-x86/bugs_32.c b/arch/x86/um/bugs_32.c
similarity index 100%
rename from arch/um/sys-x86/bugs_32.c
rename to arch/x86/um/bugs_32.c
diff --git a/arch/um/sys-x86/bugs_64.c b/arch/x86/um/bugs_64.c
similarity index 100%
rename from arch/um/sys-x86/bugs_64.c
rename to arch/x86/um/bugs_64.c
diff --git a/arch/um/sys-x86/checksum_32.S b/arch/x86/um/checksum_32.S
similarity index 100%
rename from arch/um/sys-x86/checksum_32.S
rename to arch/x86/um/checksum_32.S
diff --git a/arch/um/sys-x86/delay_32.c b/arch/x86/um/delay_32.c
similarity index 100%
rename from arch/um/sys-x86/delay_32.c
rename to arch/x86/um/delay_32.c
diff --git a/arch/um/sys-x86/delay_64.c b/arch/x86/um/delay_64.c
similarity index 100%
rename from arch/um/sys-x86/delay_64.c
rename to arch/x86/um/delay_64.c
diff --git a/arch/um/sys-x86/elfcore.c b/arch/x86/um/elfcore.c
similarity index 100%
rename from arch/um/sys-x86/elfcore.c
rename to arch/x86/um/elfcore.c
diff --git a/arch/um/sys-x86/fault.c b/arch/x86/um/fault.c
similarity index 100%
rename from arch/um/sys-x86/fault.c
rename to arch/x86/um/fault.c
diff --git a/arch/um/sys-x86/ksyms.c b/arch/x86/um/ksyms.c
similarity index 100%
rename from arch/um/sys-x86/ksyms.c
rename to arch/x86/um/ksyms.c
diff --git a/arch/um/sys-x86/ldt.c b/arch/x86/um/ldt.c
similarity index 100%
rename from arch/um/sys-x86/ldt.c
rename to arch/x86/um/ldt.c
diff --git a/arch/um/sys-x86/mem_32.c b/arch/x86/um/mem_32.c
similarity index 100%
rename from arch/um/sys-x86/mem_32.c
rename to arch/x86/um/mem_32.c
diff --git a/arch/um/sys-x86/mem_64.c b/arch/x86/um/mem_64.c
similarity index 100%
rename from arch/um/sys-x86/mem_64.c
rename to arch/x86/um/mem_64.c
diff --git a/arch/um/os-Linux/sys-x86/Makefile b/arch/x86/um/os-Linux/Makefile
similarity index 100%
rename from arch/um/os-Linux/sys-x86/Makefile
rename to arch/x86/um/os-Linux/Makefile
diff --git a/arch/um/os-Linux/sys-x86/mcontext.c b/arch/x86/um/os-Linux/mcontext.c
similarity index 100%
rename from arch/um/os-Linux/sys-x86/mcontext.c
rename to arch/x86/um/os-Linux/mcontext.c
diff --git a/arch/um/os-Linux/sys-x86/prctl.c b/arch/x86/um/os-Linux/prctl.c
similarity index 100%
rename from arch/um/os-Linux/sys-x86/prctl.c
rename to arch/x86/um/os-Linux/prctl.c
diff --git a/arch/um/os-Linux/sys-x86/registers.c b/arch/x86/um/os-Linux/registers.c
similarity index 100%
rename from arch/um/os-Linux/sys-x86/registers.c
rename to arch/x86/um/os-Linux/registers.c
diff --git a/arch/um/os-Linux/sys-x86/task_size.c b/arch/x86/um/os-Linux/task_size.c
similarity index 100%
rename from arch/um/os-Linux/sys-x86/task_size.c
rename to arch/x86/um/os-Linux/task_size.c
diff --git a/arch/um/os-Linux/sys-x86/tls.c b/arch/x86/um/os-Linux/tls.c
similarity index 100%
rename from arch/um/os-Linux/sys-x86/tls.c
rename to arch/x86/um/os-Linux/tls.c
diff --git a/arch/um/sys-x86/ptrace_32.c b/arch/x86/um/ptrace_32.c
similarity index 100%
rename from arch/um/sys-x86/ptrace_32.c
rename to arch/x86/um/ptrace_32.c
diff --git a/arch/um/sys-x86/ptrace_64.c b/arch/x86/um/ptrace_64.c
similarity index 100%
rename from arch/um/sys-x86/ptrace_64.c
rename to arch/x86/um/ptrace_64.c
diff --git a/arch/um/sys-x86/ptrace_user.c b/arch/x86/um/ptrace_user.c
similarity index 100%
rename from arch/um/sys-x86/ptrace_user.c
rename to arch/x86/um/ptrace_user.c
diff --git a/arch/um/sys-x86/setjmp_32.S b/arch/x86/um/setjmp_32.S
similarity index 100%
rename from arch/um/sys-x86/setjmp_32.S
rename to arch/x86/um/setjmp_32.S
diff --git a/arch/um/sys-x86/setjmp_64.S b/arch/x86/um/setjmp_64.S
similarity index 100%
rename from arch/um/sys-x86/setjmp_64.S
rename to arch/x86/um/setjmp_64.S
diff --git a/arch/um/sys-x86/shared/sysdep/archsetjmp.h b/arch/x86/um/shared/sysdep/archsetjmp.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/archsetjmp.h
rename to arch/x86/um/shared/sysdep/archsetjmp.h
diff --git a/arch/um/sys-x86/shared/sysdep/archsetjmp_32.h b/arch/x86/um/shared/sysdep/archsetjmp_32.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/archsetjmp_32.h
rename to arch/x86/um/shared/sysdep/archsetjmp_32.h
diff --git a/arch/um/sys-x86/shared/sysdep/archsetjmp_64.h b/arch/x86/um/shared/sysdep/archsetjmp_64.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/archsetjmp_64.h
rename to arch/x86/um/shared/sysdep/archsetjmp_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/faultinfo.h b/arch/x86/um/shared/sysdep/faultinfo.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/faultinfo.h
rename to arch/x86/um/shared/sysdep/faultinfo.h
diff --git a/arch/um/sys-x86/shared/sysdep/faultinfo_32.h b/arch/x86/um/shared/sysdep/faultinfo_32.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/faultinfo_32.h
rename to arch/x86/um/shared/sysdep/faultinfo_32.h
diff --git a/arch/um/sys-x86/shared/sysdep/faultinfo_64.h b/arch/x86/um/shared/sysdep/faultinfo_64.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/faultinfo_64.h
rename to arch/x86/um/shared/sysdep/faultinfo_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/host_ldt.h b/arch/x86/um/shared/sysdep/host_ldt.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/host_ldt.h
rename to arch/x86/um/shared/sysdep/host_ldt.h
diff --git a/arch/um/sys-x86/shared/sysdep/host_ldt_32.h b/arch/x86/um/shared/sysdep/host_ldt_32.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/host_ldt_32.h
rename to arch/x86/um/shared/sysdep/host_ldt_32.h
diff --git a/arch/um/sys-x86/shared/sysdep/host_ldt_64.h b/arch/x86/um/shared/sysdep/host_ldt_64.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/host_ldt_64.h
rename to arch/x86/um/shared/sysdep/host_ldt_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/kernel-offsets.h b/arch/x86/um/shared/sysdep/kernel-offsets.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/kernel-offsets.h
rename to arch/x86/um/shared/sysdep/kernel-offsets.h
diff --git a/arch/um/sys-x86/shared/sysdep/mcontext.h b/arch/x86/um/shared/sysdep/mcontext.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/mcontext.h
rename to arch/x86/um/shared/sysdep/mcontext.h
diff --git a/arch/um/sys-x86/shared/sysdep/ptrace.h b/arch/x86/um/shared/sysdep/ptrace.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/ptrace.h
rename to arch/x86/um/shared/sysdep/ptrace.h
diff --git a/arch/um/sys-x86/shared/sysdep/ptrace_32.h b/arch/x86/um/shared/sysdep/ptrace_32.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/ptrace_32.h
rename to arch/x86/um/shared/sysdep/ptrace_32.h
diff --git a/arch/um/sys-x86/shared/sysdep/ptrace_64.h b/arch/x86/um/shared/sysdep/ptrace_64.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/ptrace_64.h
rename to arch/x86/um/shared/sysdep/ptrace_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/ptrace_user.h b/arch/x86/um/shared/sysdep/ptrace_user.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/ptrace_user.h
rename to arch/x86/um/shared/sysdep/ptrace_user.h
diff --git a/arch/um/sys-x86/shared/sysdep/ptrace_user_32.h b/arch/x86/um/shared/sysdep/ptrace_user_32.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/ptrace_user_32.h
rename to arch/x86/um/shared/sysdep/ptrace_user_32.h
diff --git a/arch/um/sys-x86/shared/sysdep/ptrace_user_64.h b/arch/x86/um/shared/sysdep/ptrace_user_64.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/ptrace_user_64.h
rename to arch/x86/um/shared/sysdep/ptrace_user_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/skas_ptrace.h b/arch/x86/um/shared/sysdep/skas_ptrace.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/skas_ptrace.h
rename to arch/x86/um/shared/sysdep/skas_ptrace.h
diff --git a/arch/um/sys-x86/shared/sysdep/stub.h b/arch/x86/um/shared/sysdep/stub.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/stub.h
rename to arch/x86/um/shared/sysdep/stub.h
diff --git a/arch/um/sys-x86/shared/sysdep/stub_32.h b/arch/x86/um/shared/sysdep/stub_32.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/stub_32.h
rename to arch/x86/um/shared/sysdep/stub_32.h
diff --git a/arch/um/sys-x86/shared/sysdep/stub_64.h b/arch/x86/um/shared/sysdep/stub_64.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/stub_64.h
rename to arch/x86/um/shared/sysdep/stub_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/syscalls.h b/arch/x86/um/shared/sysdep/syscalls.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/syscalls.h
rename to arch/x86/um/shared/sysdep/syscalls.h
diff --git a/arch/um/sys-x86/shared/sysdep/syscalls_32.h b/arch/x86/um/shared/sysdep/syscalls_32.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/syscalls_32.h
rename to arch/x86/um/shared/sysdep/syscalls_32.h
diff --git a/arch/um/sys-x86/shared/sysdep/syscalls_64.h b/arch/x86/um/shared/sysdep/syscalls_64.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/syscalls_64.h
rename to arch/x86/um/shared/sysdep/syscalls_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/tls.h b/arch/x86/um/shared/sysdep/tls.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/tls.h
rename to arch/x86/um/shared/sysdep/tls.h
diff --git a/arch/um/sys-x86/shared/sysdep/tls_32.h b/arch/x86/um/shared/sysdep/tls_32.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/tls_32.h
rename to arch/x86/um/shared/sysdep/tls_32.h
diff --git a/arch/um/sys-x86/shared/sysdep/tls_64.h b/arch/x86/um/shared/sysdep/tls_64.h
similarity index 100%
rename from arch/um/sys-x86/shared/sysdep/tls_64.h
rename to arch/x86/um/shared/sysdep/tls_64.h
diff --git a/arch/um/sys-x86/signal_32.c b/arch/x86/um/signal_32.c
similarity index 100%
rename from arch/um/sys-x86/signal_32.c
rename to arch/x86/um/signal_32.c
diff --git a/arch/um/sys-x86/signal_64.c b/arch/x86/um/signal_64.c
similarity index 100%
rename from arch/um/sys-x86/signal_64.c
rename to arch/x86/um/signal_64.c
diff --git a/arch/um/sys-x86/stub_32.S b/arch/x86/um/stub_32.S
similarity index 100%
rename from arch/um/sys-x86/stub_32.S
rename to arch/x86/um/stub_32.S
diff --git a/arch/um/sys-x86/stub_64.S b/arch/x86/um/stub_64.S
similarity index 100%
rename from arch/um/sys-x86/stub_64.S
rename to arch/x86/um/stub_64.S
diff --git a/arch/um/sys-x86/stub_segv.c b/arch/x86/um/stub_segv.c
similarity index 100%
rename from arch/um/sys-x86/stub_segv.c
rename to arch/x86/um/stub_segv.c
diff --git a/arch/um/sys-x86/sys_call_table_32.S b/arch/x86/um/sys_call_table_32.S
similarity index 100%
rename from arch/um/sys-x86/sys_call_table_32.S
rename to arch/x86/um/sys_call_table_32.S
diff --git a/arch/um/sys-x86/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
similarity index 100%
rename from arch/um/sys-x86/sys_call_table_64.c
rename to arch/x86/um/sys_call_table_64.c
diff --git a/arch/um/sys-x86/syscalls_32.c b/arch/x86/um/syscalls_32.c
similarity index 100%
rename from arch/um/sys-x86/syscalls_32.c
rename to arch/x86/um/syscalls_32.c
diff --git a/arch/um/sys-x86/syscalls_64.c b/arch/x86/um/syscalls_64.c
similarity index 100%
rename from arch/um/sys-x86/syscalls_64.c
rename to arch/x86/um/syscalls_64.c
diff --git a/arch/um/sys-x86/sysrq_32.c b/arch/x86/um/sysrq_32.c
similarity index 100%
rename from arch/um/sys-x86/sysrq_32.c
rename to arch/x86/um/sysrq_32.c
diff --git a/arch/um/sys-x86/sysrq_64.c b/arch/x86/um/sysrq_64.c
similarity index 100%
rename from arch/um/sys-x86/sysrq_64.c
rename to arch/x86/um/sysrq_64.c
diff --git a/arch/um/sys-x86/tls_32.c b/arch/x86/um/tls_32.c
similarity index 100%
rename from arch/um/sys-x86/tls_32.c
rename to arch/x86/um/tls_32.c
diff --git a/arch/um/sys-x86/tls_64.c b/arch/x86/um/tls_64.c
similarity index 100%
rename from arch/um/sys-x86/tls_64.c
rename to arch/x86/um/tls_64.c
diff --git a/arch/um/sys-x86/user-offsets.c b/arch/x86/um/user-offsets.c
similarity index 100%
rename from arch/um/sys-x86/user-offsets.c
rename to arch/x86/um/user-offsets.c
diff --git a/arch/um/sys-x86/vdso/Makefile b/arch/x86/um/vdso/Makefile
similarity index 100%
rename from arch/um/sys-x86/vdso/Makefile
rename to arch/x86/um/vdso/Makefile
diff --git a/arch/um/sys-x86/vdso/checkundef.sh b/arch/x86/um/vdso/checkundef.sh
similarity index 100%
rename from arch/um/sys-x86/vdso/checkundef.sh
rename to arch/x86/um/vdso/checkundef.sh
diff --git a/arch/um/sys-x86/vdso/um_vdso.c b/arch/x86/um/vdso/um_vdso.c
similarity index 100%
rename from arch/um/sys-x86/vdso/um_vdso.c
rename to arch/x86/um/vdso/um_vdso.c
diff --git a/arch/um/sys-x86/vdso/vdso-layout.lds.S b/arch/x86/um/vdso/vdso-layout.lds.S
similarity index 100%
rename from arch/um/sys-x86/vdso/vdso-layout.lds.S
rename to arch/x86/um/vdso/vdso-layout.lds.S
diff --git a/arch/um/sys-x86/vdso/vdso-note.S b/arch/x86/um/vdso/vdso-note.S
similarity index 100%
rename from arch/um/sys-x86/vdso/vdso-note.S
rename to arch/x86/um/vdso/vdso-note.S
diff --git a/arch/um/sys-x86/vdso/vdso.S b/arch/x86/um/vdso/vdso.S
similarity index 70%
rename from arch/um/sys-x86/vdso/vdso.S
rename to arch/x86/um/vdso/vdso.S
index 03b0532..1cb468a 100644
--- a/arch/um/sys-x86/vdso/vdso.S
+++ b/arch/x86/um/vdso/vdso.S
@@ -4,7 +4,7 @@ __INITDATA
 
 	.globl vdso_start, vdso_end
 vdso_start:
-	.incbin "arch/um/sys-x86/vdso/vdso.so"
+	.incbin "arch/x86/um/vdso/vdso.so"
 vdso_end:
 
 __FINIT
diff --git a/arch/um/sys-x86/vdso/vdso.lds.S b/arch/x86/um/vdso/vdso.lds.S
similarity index 100%
rename from arch/um/sys-x86/vdso/vdso.lds.S
rename to arch/x86/um/vdso/vdso.lds.S
diff --git a/arch/um/sys-x86/vdso/vma.c b/arch/x86/um/vdso/vma.c
similarity index 100%
rename from arch/um/sys-x86/vdso/vma.c
rename to arch/x86/um/vdso/vma.c
-- 
1.7.2.5


