Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660Ab1ESUWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:22:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44421 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933926Ab1ESUWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:22:48 -0400
Date: Thu, 19 May 2011 22:22:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf/core changes for v2.6.40
Message-ID: <20110519202207.GA11669@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-core-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (2):
      perf script: Add more documentation about the -f/--fields parameters
      perf symbols: Give more useful names to 'self' parameters

Arun Sharma (1):
      perf script: Add support for PERF_TYPE_RAW

Borislav Petkov (2):
      perf: Start the restructuring
      hw breakpoints: Move to kernel/events/

Cyrill Gorcunov (2):
      perf, x86: P4 PMU - clean up the code a bit
      perf, x86: P4 PMU -- Use perf_sample_data_init helper

David Ahern (3):
      perf script: If type not given fields apply to all event types
      perf script: improve validation of sample attributes for output fields
      perf stat: Tell user about unsupported events in the list

Fenghua Yu (10):
      x86, cpufeature: Fix cpuid leaf 7 feature detection
      x86, cpufeature: Add CPU feature bit for enhanced REP MOVSB/STOSB
      x86, mem, intel: Initialize Enhanced REP MOVSB/STOSB
      x86, alternative, doc: Add comment for applying alternatives order
      x86, alternative: Add altinstruction_entry macro
      x86, mem: clear_page_64.S: Support clear_page() with enhanced REP MOVSB/STOSB
      x86, mem: copy_user_64.S: Support copy_to/from_user by enhanced REP MOVSB/STOSB
      x86, mem: memcpy_64.S: Optimize memcpy by enhanced REP MOVSB/STOSB
      x86, mem: memmove_64.S: Optimize memmove by enhanced REP MOVSB/STOSB
      x86, mem: memset_64.S: Optimize memset by enhanced REP MOVSB/STOSB

Ingo Molnar (32):
      perf events: Add stalled cycles generic event - PERF_COUNT_HW_STALLED_CYCLES
      perf events, x86: Mark constrant tables read mostly
      perf stat: Print stalled cycles percentage
      perf stat: Print cache misses as percentage
      perf tools: Accept case-insensitive symbolic event variants
      perf stat: Fail more clearly when an invalid modifier is specified
      perf stat: Make all displayed event names parseable as well
      perf stat: Factor our shadow stats
      perf stat: Add stalled cycles accounting, prettify the resulting output
      perf stat: Add stalled cycles to the default output
      perf stat: Fix -nan% output in perf stat noise printouts
      perf stat: Print stalled cycles warning colors
      perf stat: Print branch misses warning colors
      perf stat: Print out miss/hit ratio for L1 data-cache events
      perf stat: Add -d/--detailed flag to run with a lot of events
      perf stat: Fix printout vertical alignment
      perf event, x86: Use better stalled cycles metric
      perf stat: Add --sync/-S option
      perf stat: Fix compatibility behavior
      perf events: Add generic front-end and back-end stalled cycle event definitions
      perf, x86: Add new stalled cycles events for Intel and AMD CPUs
      perf tools: Add front-end and back-end stalled cycles support
      perf stat: Analyze front-end and back-end stall counts
      perf stat: Adjust stall cycles warning percentages
      perf stat: Leave more room for percentages
      perf stat: Fail softly on unsupported events
      perf events, x86: Add Westmere stalled-cycles-frontend/backend events
      perf list: Fix max event string size
      perf events: Clean up definitions and initializers, update copyrights
      perf bench, x86: Add alternatives-asm.h wrapper
      perf stat: Add -d -d and -d -d -d options to show more CPU events
      perf stat: Add more cache-miss percentage printouts

Jan Glauber (1):
      jump label: Add s390 support

Jason Baron (2):
      jump label: Introduce static_branch() interface
      jump label: Add _ASM_ALIGN for x86 and x86_64

Jiri Olsa (2):
      tracing: Avoid soft lockup in trace_pipe
      x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace address limit

Justin P. Mattock (1):
      perf events, x86, P4: Fix typo in comment

Lin Ming (3):
      perf probe: Add fastpath to do lookup by function name
      perf events, x86: Add SandyBridge stalled-cycles-frontend/backend events
      perf probe: Fix the missed parameter initialization

Martin Schwidefsky (3):
      ftrace/recordmcount: mcount address adjustment
      ftrace/x86: mcount offset calculation
      ftrace/s390: mcount offset calculation

Michael Witten (4):
      perf tools: Makefile: Clean up `python/perf.so' rule
      perf tools: Makefile: PYTHON{,_CONFIG} to bandage Python 3 incompatibility
      perf tools: Move `try-cc'
      perf tools: git mv tools/perf/{features-tests.mak,config/}

Michal Marek (1):
      ftrace/kbuild: Add recordmcount files to force full build

Richard Weinberger (1):
      x86: Remove warning and warning_symbol from struct stacktrace_ops

Robert Richter (1):
      perf, x86: Use ALTERNATIVE() to check for X86_FEATURE_PERFCTR_CORE

Stephane Eranian (1):
      perf: Fix multi-event parsing bug

Steven Rostedt (35):
      tracing: Convert trace_printk() formats for module to const char *
      tracing: Print trace_bprintk() formats for modules too
      ftrace: Only update the function code on write to filter files
      ftrace: Make FTRACE_WARN_ON() work in if condition
      ftrace: Remove unnecessary disabling of irqs
      ftrace: Remove failures file
      ftrace: Remove FTRACE_FL_FAILED flag
      ftrace: Remove FTRACE_FL_CONVERTED flag
      ftrace: Move record update for normal and modules into a separate function
      ftrace: Consolidate updating of ftrace_trace_function
      ftrace: Consolidate the function match routines for normal and mods
      ftrace/trivial: Clean up recordmcount.c to use Linux style comparisons
      ftrace/trivial: Clean up record mcount to use Linux switch style
      ftrace: Add .kprobe.text section to whitelist for recordmcount.c
      ftrace/recordmcount: Modify only executable sections
      ftrace/recordmcount: Make ignored mcount calls into nops at compile time
      ftrace/recordmcount: Add warning logic to warn on mcount not recorded
      kbuild/recordmcount: Add RECORDMCOUNT_WARN to warn about mcount callers
      ftrace: Avoid recording mcount on .init sections directly
      ftrace/x86: Do not trace .discard.text section
      ftrace/recordmcount: Remove duplicate code to find mcount symbol
      ftrace/recordmcount: Add helper function get_sym_str_and_relp()
      ftrace: Replace FTRACE_FL_NOTRACE flag with a hash of ignored functions
      ftrace: Use hash instead for FTRACE_FL_FILTER
      ftrace: Create a global_ops to hold the filter and notrace hashes
      ftrace: Separate hash allocation and assignment
      ftrace: Use counters to enable functions to trace
      ftrace: Add enabled_functions file
      ftrace: Add ops parameter to ftrace_startup/shutdown functions
      ftrace: Have global_ops store the functions that are to be traced
      ftrace: Free hash with call_rcu_sched()
      ftrace: Implement separate user function filtering
      ftrace: Allow dynamically allocated function tracers
      ftrace: Modify ftrace_set_filter/notrace to take ops
      ftrace: Add self-tests for multiple function trace users


 Makefile                                      |    1 +
 arch/mips/include/asm/jump_label.h            |   22 +-
 arch/s390/Kconfig                             |    1 +
 arch/s390/include/asm/ftrace.h                |    4 +-
 arch/s390/include/asm/jump_label.h            |   37 +
 arch/s390/kernel/Makefile                     |    2 +-
 arch/s390/kernel/jump_label.c                 |   59 ++
 arch/sparc/include/asm/jump_label.h           |   25 +-
 arch/x86/include/asm/alternative-asm.h        |    9 +
 arch/x86/include/asm/alternative.h            |    3 +-
 arch/x86/include/asm/cpufeature.h             |    1 +
 arch/x86/include/asm/ftrace.h                 |    7 +-
 arch/x86/include/asm/jump_label.h             |   27 +-
 arch/x86/include/asm/setup.h                  |    2 +-
 arch/x86/include/asm/stacktrace.h             |    3 -
 arch/x86/include/asm/uaccess.h                |    2 +-
 arch/x86/kernel/alternative.c                 |   11 +-
 arch/x86/kernel/cpu/common.c                  |    3 +-
 arch/x86/kernel/cpu/intel.c                   |   19 +-
 arch/x86/kernel/cpu/perf_event.c              |   28 +-
 arch/x86/kernel/cpu/perf_event_amd.c          |   14 +-
 arch/x86/kernel/cpu/perf_event_intel.c        |   37 +-
 arch/x86/kernel/cpu/perf_event_p4.c           |    7 +-
 arch/x86/kernel/dumpstack.c                   |   16 -
 arch/x86/kernel/module.c                      |    1 +
 arch/x86/kernel/stacktrace.c                  |   13 -
 arch/x86/lib/clear_page_64.S                  |   33 +-
 arch/x86/lib/copy_user_64.S                   |   69 ++-
 arch/x86/lib/memcpy_64.S                      |   45 +-
 arch/x86/lib/memmove_64.S                     |   29 +-
 arch/x86/lib/memset_64.S                      |   54 +-
 arch/x86/oprofile/backtrace.c                 |   13 -
 include/asm-generic/vmlinux.lds.h             |   14 +-
 include/linux/dynamic_debug.h                 |    2 -
 include/linux/ftrace.h                        |   35 +-
 include/linux/init.h                          |   14 +-
 include/linux/jump_label.h                    |   89 ++-
 include/linux/jump_label_ref.h                |   44 -
 include/linux/kernel.h                        |    1 +
 include/linux/perf_event.h                    |  121 ++--
 include/linux/tracepoint.h                    |   22 +-
 kernel/Makefile                               |    6 +-
 kernel/events/Makefile                        |    6 +
 kernel/{perf_event.c => events/core.c}        |   44 +-
 kernel/{ => events}/hw_breakpoint.c           |    0
 kernel/extable.c                              |    8 +
 kernel/jump_label.c                           |  539 +++++------
 kernel/trace/ftrace.c                         | 1283 +++++++++++++++++++------
 kernel/trace/trace.c                          |   15 +-
 kernel/trace/trace.h                          |    2 +
 kernel/trace/trace_functions.c                |    2 +
 kernel/trace/trace_irqsoff.c                  |    1 +
 kernel/trace/trace_output.c                   |    3 +
 kernel/trace/trace_printk.c                   |  120 +++-
 kernel/trace/trace_sched_wakeup.c             |    1 +
 kernel/trace/trace_selftest.c                 |  214 ++++-
 kernel/trace/trace_selftest_dynamic.c         |    6 +
 kernel/trace/trace_stack.c                    |    1 +
 kernel/tracepoint.c                           |   23 +-
 scripts/Makefile.build                        |   12 +-
 scripts/recordmcount.c                        |  168 +++-
 scripts/recordmcount.h                        |  174 +++-
 scripts/recordmcount.pl                       |    5 +
 tools/perf/Documentation/perf-script.txt      |   52 +-
 tools/perf/Makefile                           |  107 ++-
 tools/perf/builtin-script.c                   |  296 +++++--
 tools/perf/builtin-stat.c                     |  573 ++++++++++--
 tools/perf/{ => config}/feature-tests.mak     |   16 +-
 tools/perf/config/utilities.mak               |  188 ++++
 tools/perf/util/include/asm/alternative-asm.h |    8 +
 tools/perf/util/parse-events.c                |  123 ++-
 tools/perf/util/probe-finder.c                |   73 ++
 tools/perf/util/probe-finder.h                |    2 +
 tools/perf/util/python.c                      |    3 +
 tools/perf/util/session.c                     |   12 +
 tools/perf/util/session.h                     |    3 +
 tools/perf/util/symbol.c                      |  629 ++++++------
 tools/perf/util/symbol.h                      |   78 +-
 78 files changed, 4024 insertions(+), 1711 deletions(-)
 create mode 100644 arch/s390/include/asm/jump_label.h
 create mode 100644 arch/s390/kernel/jump_label.c
 delete mode 100644 include/linux/jump_label_ref.h
 create mode 100644 kernel/events/Makefile
 rename kernel/{perf_event.c => events/core.c} (99%)
 rename kernel/{ => events}/hw_breakpoint.c (100%)
 rename tools/perf/{ => config}/feature-tests.mak (86%)
 create mode 100644 tools/perf/config/utilities.mak
 create mode 100644 tools/perf/util/include/asm/alternative-asm.h

diff --git a/Makefile b/Makefile
index 41ea6fb..e7d01ad 100644
--- a/Makefile
+++ b/Makefile
@@ -1268,6 +1268,7 @@ help:
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
 	@echo  '  make W=1   [targets] Enable extra gcc checks'
+	@echo  '  make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
index 7622ccf..1881b31 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -20,16 +20,18 @@
 #define WORD_INSN ".word"
 #endif
 
-#define JUMP_LABEL(key, label)						\
-	do {								\
-		asm goto("1:\tnop\n\t"					\
-			"nop\n\t"					\
-			".pushsection __jump_table,  \"a\"\n\t"		\
-			WORD_INSN " 1b, %l[" #label "], %0\n\t"		\
-			".popsection\n\t"				\
-			: :  "i" (key) :  : label);			\
-	} while (0)
-
+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+	asm goto("1:\tnop\n\t"
+		"nop\n\t"
+		".pushsection __jump_table,  \"aw\"\n\t"
+		WORD_INSN " 1b, %l[l_yes], %0\n\t"
+		".popsection\n\t"
+		: :  "i" (key) : : l_yes);
+	return false;
+l_yes:
+	return true;
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2508a6f..4a7f140 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -88,6 +88,7 @@ config S390
 	select HAVE_KERNEL_XZ
 	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_ARCH_MUTEX_CPU_RELAX
+	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index 3c29be4..b7931fa 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -11,15 +11,13 @@ struct dyn_arch_ftrace { };
 
 #ifdef CONFIG_64BIT
 #define MCOUNT_INSN_SIZE  12
-#define MCOUNT_OFFSET	   8
 #else
 #define MCOUNT_INSN_SIZE  20
-#define MCOUNT_OFFSET	   4
 #endif
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
-	return addr - MCOUNT_OFFSET;
+	return addr;
 }
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
new file mode 100644
index 0000000..95a6cf2
--- /dev/null
+++ b/arch/s390/include/asm/jump_label.h
@@ -0,0 +1,37 @@
+#ifndef _ASM_S390_JUMP_LABEL_H
+#define _ASM_S390_JUMP_LABEL_H
+
+#include <linux/types.h>
+
+#define JUMP_LABEL_NOP_SIZE 6
+
+#ifdef CONFIG_64BIT
+#define ASM_PTR ".quad"
+#define ASM_ALIGN ".balign 8"
+#else
+#define ASM_PTR ".long"
+#define ASM_ALIGN ".balign 4"
+#endif
+
+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+	asm goto("0:	brcl 0,0\n"
+		".pushsection __jump_table, \"aw\"\n"
+		ASM_ALIGN "\n"
+		ASM_PTR " 0b, %l[label], %0\n"
+		".popsection\n"
+		: : "X" (key) : : label);
+	return false;
+label:
+	return true;
+}
+
+typedef unsigned long jump_label_t;
+
+struct jump_entry {
+	jump_label_t code;
+	jump_label_t target;
+	jump_label_t key;
+};
+
+#endif
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 64230bc..5ff15da 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -23,7 +23,7 @@ CFLAGS_sysinfo.o += -Iinclude/math-emu -Iarch/s390/math-emu -w
 obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o setup.o \
 	    processor.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o \
 	    s390_ext.o debug.o irq.o ipl.o dis.o diag.o mem_detect.o \
-	    vdso.o vtime.o sysinfo.o nmi.o sclp.o
+	    vdso.o vtime.o sysinfo.o nmi.o sclp.o jump_label.o
 
 obj-y	+= $(if $(CONFIG_64BIT),entry64.o,entry.o)
 obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,reipl.o)
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
new file mode 100644
index 0000000..44cc06b
--- /dev/null
+++ b/arch/s390/kernel/jump_label.c
@@ -0,0 +1,59 @@
+/*
+ * Jump label s390 support
+ *
+ * Copyright IBM Corp. 2011
+ * Author(s): Jan Glauber <jang@linux.vnet.ibm.com>
+ */
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/stop_machine.h>
+#include <linux/jump_label.h>
+#include <asm/ipl.h>
+
+#ifdef HAVE_JUMP_LABEL
+
+struct insn {
+	u16 opcode;
+	s32 offset;
+} __packed;
+
+struct insn_args {
+	unsigned long *target;
+	struct insn *insn;
+	ssize_t size;
+};
+
+static int __arch_jump_label_transform(void *data)
+{
+	struct insn_args *args = data;
+	int rc;
+
+	rc = probe_kernel_write(args->target, args->insn, args->size);
+	WARN_ON_ONCE(rc < 0);
+	return 0;
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
+	struct insn_args args;
+	struct insn insn;
+
+	if (type == JUMP_LABEL_ENABLE) {
+		/* brcl 15,offset */
+		insn.opcode = 0xc0f4;
+		insn.offset = (entry->target - entry->code) >> 1;
+	} else {
+		/* brcl 0,0 */
+		insn.opcode = 0xc004;
+		insn.offset = 0;
+	}
+
+	args.target = (void *) entry->code;
+	args.insn = &insn;
+	args.size = JUMP_LABEL_NOP_SIZE;
+
+	stop_machine(__arch_jump_label_transform, &args, NULL);
+}
+
+#endif
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 427d468..fc73a82 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -7,17 +7,20 @@
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-#define JUMP_LABEL(key, label)					\
-	do {							\
-		asm goto("1:\n\t"				\
-			 "nop\n\t"				\
-			 "nop\n\t"				\
-			 ".pushsection __jump_table,  \"a\"\n\t"\
-			 ".align 4\n\t"				\
-			 ".word 1b, %l[" #label "], %c0\n\t"	\
-			 ".popsection \n\t"			\
-			 : :  "i" (key) :  : label);\
-	} while (0)
+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+		asm goto("1:\n\t"
+			 "nop\n\t"
+			 "nop\n\t"
+			 ".pushsection __jump_table,  \"aw\"\n\t"
+			 ".align 4\n\t"
+			 ".word 1b, %l[l_yes], %c0\n\t"
+			 ".popsection \n\t"
+			 : :  "i" (key) : : l_yes);
+	return false;
+l_yes:
+	return true;
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index a63a68b..94d420b 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -15,4 +15,13 @@
 	.endm
 #endif
 
+.macro altinstruction_entry orig alt feature orig_len alt_len
+	.align 8
+	.quad \orig
+	.quad \alt
+	.word \feature
+	.byte \orig_len
+	.byte \alt_len
+.endm
+
 #endif  /*  __ASSEMBLY__  */
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 13009d1..8cdd1e2 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -4,7 +4,6 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/stringify.h>
-#include <linux/jump_label.h>
 #include <asm/asm.h>
 
 /*
@@ -191,7 +190,7 @@ extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 extern void text_poke_smp_batch(struct text_poke_param *params, int n);
 
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_JUMP_LABEL)
 #define IDEAL_NOP_SIZE_5 5
 extern unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
 extern void arch_init_ideal_nop5(void);
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 91f3e087..7f2f7b1 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -195,6 +195,7 @@
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
 #define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
+#define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index db24c22..268c783 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -38,11 +38,10 @@ extern void mcount(void);
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
 	/*
-	 * call mcount is "e8 <4 byte offset>"
-	 * The addr points to the 4 byte offset and the caller of this
-	 * function wants the pointer to e8. Simply subtract one.
+	 * addr is the address of the mcount call instruction.
+	 * recordmcount does the necessary offset calculation.
 	 */
-	return addr - 1;
+	return addr;
 }
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 574dbc2..a32b18c 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -5,20 +5,25 @@
 
 #include <linux/types.h>
 #include <asm/nops.h>
+#include <asm/asm.h>
 
 #define JUMP_LABEL_NOP_SIZE 5
 
-# define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
-
-# define JUMP_LABEL(key, label)					\
-	do {							\
-		asm goto("1:"					\
-			JUMP_LABEL_INITIAL_NOP			\
-			".pushsection __jump_table,  \"aw\" \n\t"\
-			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
-			".popsection \n\t"			\
-			: :  "i" (key) :  : label);		\
-	} while (0)
+#define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+
+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+	asm goto("1:"
+		JUMP_LABEL_INITIAL_NOP
+		".pushsection __jump_table,  \"aw\" \n\t"
+		_ASM_ALIGN "\n\t"
+		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
+		".popsection \n\t"
+		: :  "i" (key) : : l_yes);
+	return false;
+l_yes:
+	return true;
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index db8aa19..647d8a0 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -88,7 +88,7 @@ void *extend_brk(size_t size, size_t align);
  * executable.)
  */
 #define RESERVE_BRK(name,sz)						\
-	static void __section(.discard.text) __used			\
+	static void __section(.discard.text) __used notrace		\
 	__brk_reservation_fn_##name##__(void) {				\
 		asm volatile (						\
 			".pushsection .brk_reservation,\"aw\",@nobits;" \
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index d7e89c8..70bbe39 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -37,9 +37,6 @@ print_context_stack_bp(struct thread_info *tinfo,
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
-	void (*warning)(void *data, char *msg);
-	/* msg must contain %s for the symbol */
-	void (*warning_symbol)(void *data, char *msg, unsigned long symbol);
 	void (*address)(void *data, unsigned long address, int reliable);
 	/* On negative return stop dumping */
 	int (*stack)(void *data, char *name);
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index abd3e0e..99f0ad7 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -42,7 +42,7 @@
  * Returns 0 if the range is valid, nonzero otherwise.
  *
  * This is equivalent to the following test:
- * (u33)addr + (u33)size >= (u33)current->addr_limit.seg (u65 for x86_64)
+ * (u33)addr + (u33)size > (u33)current->addr_limit.seg (u65 for x86_64)
  *
  * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
  */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4a23467..1eeeafc 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -210,6 +210,15 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	u8 insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
+	/*
+	 * The scan order should be from start to end. A later scanned
+	 * alternative code can overwrite a previous scanned alternative code.
+	 * Some kernel functions (e.g. memcpy, memset, etc) use this order to
+	 * patch code.
+	 *
+	 * So be careful if you want to change the scan order to any other
+	 * order.
+	 */
 	for (a = start; a < end; a++) {
 		u8 *instr = a->instr;
 		BUG_ON(a->replacementlen > a->instrlen);
@@ -679,7 +688,7 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
 	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 }
 
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_JUMP_LABEL)
 
 #ifdef CONFIG_X86_64
 unsigned char ideal_nop5[5] = { 0x66, 0x66, 0x66, 0x66, 0x90 };
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e2ced007..173f3a3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -565,8 +565,7 @@ void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 
 		cpuid_count(0x00000007, 0, &eax, &ebx, &ecx, &edx);
 
-		if (eax > 0)
-			c->x86_capability[9] = ebx;
+		c->x86_capability[9] = ebx;
 	}
 
 	/* AMD-defined flags: level 0x80000001 */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index df86bc8..fc73a34 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -29,10 +29,10 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	u64 misc_enable;
+
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
-		u64 misc_enable;
-
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
 		if (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID) {
@@ -118,8 +118,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * (model 2) with the same problem.
 	 */
 	if (c->x86 == 15) {
-		u64 misc_enable;
-
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
 		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
@@ -130,6 +128,19 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/*
+	 * If fast string is not enabled in IA32_MISC_ENABLE for any reason,
+	 * clear the fast string and enhanced fast string CPU capabilities.
+	 */
+	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		if (!(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
+			printk(KERN_INFO "Disabled fast string operations\n");
+			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
+			setup_clear_cpu_cap(X86_FEATURE_ERMS);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e638689..3a0338b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -31,6 +31,7 @@
 #include <asm/nmi.h>
 #include <asm/compat.h>
 #include <asm/smp.h>
+#include <asm/alternative.h>
 
 #if 0
 #undef wrmsrl
@@ -363,12 +364,18 @@ again:
 	return new_raw_count;
 }
 
-/* using X86_FEATURE_PERFCTR_CORE to later implement ALTERNATIVE() here */
 static inline int x86_pmu_addr_offset(int index)
 {
-	if (boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		return index << 1;
-	return index;
+	int offset;
+
+	/* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
+	alternative_io(ASM_NOP2,
+		       "shll $1, %%eax",
+		       X86_FEATURE_PERFCTR_CORE,
+		       "=a" (offset),
+		       "a"  (index));
+
+	return offset;
 }
 
 static inline unsigned int x86_pmu_config_addr(int index)
@@ -1766,17 +1773,6 @@ static struct pmu pmu = {
  * callchain support
  */
 
-static void
-backtrace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
-
 static int backtrace_stack(void *data, char *name)
 {
 	return 0;
@@ -1790,8 +1786,6 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops backtrace_ops = {
-	.warning		= backtrace_warning,
-	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
 	.walk_stack		= print_context_stack_bp,
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index cf4e369..fe29c1d 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -96,12 +96,14 @@ static __initconst const u64 amd_hw_cache_event_ids
  */
 static const u64 amd_perfmon_event_map[] =
 {
-  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
-  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0080,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0081,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
+  [PERF_COUNT_HW_CPU_CYCLES]			= 0x0076,
+  [PERF_COUNT_HW_INSTRUCTIONS]			= 0x00c0,
+  [PERF_COUNT_HW_CACHE_REFERENCES]		= 0x0080,
+  [PERF_COUNT_HW_CACHE_MISSES]			= 0x0081,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]		= 0x00c2,
+  [PERF_COUNT_HW_BRANCH_MISSES]			= 0x00c3,
+  [PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x00d0, /* "Decoder empty" event */
+  [PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= 0x00d1, /* "Dispatch stalls" event */
 };
 
 static u64 amd_pmu_event_map(int hw_event)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 447a28d..41178c8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -36,7 +36,7 @@ static u64 intel_perfmon_event_map[PERF_COUNT_HW_MAX] __read_mostly =
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
 };
 
-static struct event_constraint intel_core_event_constraints[] =
+static struct event_constraint intel_core_event_constraints[] __read_mostly =
 {
 	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
 	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
@@ -47,7 +47,7 @@ static struct event_constraint intel_core_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_core2_event_constraints[] =
+static struct event_constraint intel_core2_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
@@ -70,7 +70,7 @@ static struct event_constraint intel_core2_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_nehalem_event_constraints[] =
+static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
@@ -86,19 +86,19 @@ static struct event_constraint intel_nehalem_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct extra_reg intel_nehalem_extra_regs[] =
+static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
 	EVENT_EXTRA_END
 };
 
-static struct event_constraint intel_nehalem_percore_constraints[] =
+static struct event_constraint intel_nehalem_percore_constraints[] __read_mostly =
 {
 	INTEL_EVENT_CONSTRAINT(0xb7, 0),
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_westmere_event_constraints[] =
+static struct event_constraint intel_westmere_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
@@ -110,7 +110,7 @@ static struct event_constraint intel_westmere_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_snb_event_constraints[] =
+static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
@@ -123,21 +123,21 @@ static struct event_constraint intel_snb_event_constraints[] =
 	EVENT_CONSTRAINT_END
 };
 
-static struct extra_reg intel_westmere_extra_regs[] =
+static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff),
 	EVENT_EXTRA_END
 };
 
-static struct event_constraint intel_westmere_percore_constraints[] =
+static struct event_constraint intel_westmere_percore_constraints[] __read_mostly =
 {
 	INTEL_EVENT_CONSTRAINT(0xb7, 0),
 	INTEL_EVENT_CONSTRAINT(0xbb, 0),
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_gen_event_constraints[] =
+static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
@@ -1440,6 +1440,11 @@ static __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
+		/* UOPS_ISSUED.STALLED_CYCLES */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
+		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
+
 		if (ebx & 0x40) {
 			/*
 			 * Erratum AAJ80 detected, we work it around by using
@@ -1480,6 +1485,12 @@ static __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
+
+		/* UOPS_ISSUED.STALLED_CYCLES */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
+		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
+
 		pr_cont("Westmere events, ");
 		break;
 
@@ -1491,6 +1502,12 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+
+		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
+		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x18001b1;
+
 		pr_cont("SandyBridge events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index e93fcd5..ead584f 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -468,7 +468,7 @@ static struct p4_event_bind p4_event_bind_map[] = {
 		.opcode		= P4_OPCODE(P4_EVENT_MISPRED_BRANCH_RETIRED),
 		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
 		.escr_emask	=
-		P4_ESCR_EMASK_BIT(P4_EVENT_MISPRED_BRANCH_RETIRED, NBOGUS),
+			P4_ESCR_EMASK_BIT(P4_EVENT_MISPRED_BRANCH_RETIRED, NBOGUS),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_X87_ASSIST] = {
@@ -912,8 +912,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1197,7 +1196,7 @@ static __init int p4_pmu_init(void)
 {
 	unsigned int low, high;
 
-	/* If we get stripped -- indexig fails */
+	/* If we get stripped -- indexing fails */
 	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > X86_PMC_MAX_GENERIC);
 
 	rdmsr(MSR_IA32_MISC_ENABLE, low, high);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index e2a3f06..f478ff6 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -135,20 +135,6 @@ print_context_stack_bp(struct thread_info *tinfo,
 }
 EXPORT_SYMBOL_GPL(print_context_stack_bp);
 
-
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	printk(data);
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s%s\n", (char *)data, msg);
-}
-
 static int print_trace_stack(void *data, char *name)
 {
 	printk("%s <%s> ", (char *)data, name);
@@ -166,8 +152,6 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops print_trace_ops = {
-	.warning		= print_trace_warning,
-	.warning_symbol		= print_trace_warning_symbol,
 	.stack			= print_trace_stack,
 	.address		= print_trace_address,
 	.walk_stack		= print_context_stack,
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index ab23f1a..52f256f 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -24,6 +24,7 @@
 #include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/gfp.h>
+#include <linux/jump_label.h>
 
 #include <asm/system.h>
 #include <asm/page.h>
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 6515733..55d9bc0 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -9,15 +9,6 @@
 #include <linux/uaccess.h>
 #include <asm/stacktrace.h>
 
-static void save_stack_warning(void *data, char *msg)
-{
-}
-
-static void
-save_stack_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-}
-
 static int save_stack_stack(void *data, char *name)
 {
 	return 0;
@@ -53,16 +44,12 @@ save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops save_stack_ops = {
-	.warning	= save_stack_warning,
-	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address,
 	.walk_stack	= print_context_stack,
 };
 
 static const struct stacktrace_ops save_stack_ops_nosched = {
-	.warning	= save_stack_warning,
-	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address_nosched,
 	.walk_stack	= print_context_stack,
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index aa4326b..f2145cf 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -1,5 +1,6 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/alternative-asm.h>
 
 /*
  * Zero a page. 	
@@ -14,6 +15,15 @@ ENTRY(clear_page_c)
 	CFI_ENDPROC
 ENDPROC(clear_page_c)
 
+ENTRY(clear_page_c_e)
+	CFI_STARTPROC
+	movl $4096,%ecx
+	xorl %eax,%eax
+	rep stosb
+	ret
+	CFI_ENDPROC
+ENDPROC(clear_page_c_e)
+
 ENTRY(clear_page)
 	CFI_STARTPROC
 	xorl   %eax,%eax
@@ -38,21 +48,26 @@ ENTRY(clear_page)
 .Lclear_page_end:
 ENDPROC(clear_page)
 
-	/* Some CPUs run faster using the string instructions.
-	   It is also a lot simpler. Use this when possible */
+	/*
+	 * Some CPUs support enhanced REP MOVSB/STOSB instructions.
+	 * It is recommended to use this when possible.
+	 * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
+	 * Otherwise, use original function.
+	 *
+	 */
 
 #include <asm/cpufeature.h>
 
 	.section .altinstr_replacement,"ax"
 1:	.byte 0xeb					/* jmp <disp8> */
 	.byte (clear_page_c - clear_page) - (2f - 1b)	/* offset */
-2:
+2:	.byte 0xeb					/* jmp <disp8> */
+	.byte (clear_page_c_e - clear_page) - (3f - 2b)	/* offset */
+3:
 	.previous
 	.section .altinstructions,"a"
-	.align 8
-	.quad clear_page
-	.quad 1b
-	.word X86_FEATURE_REP_GOOD
-	.byte .Lclear_page_end - clear_page
-	.byte 2b - 1b
+	altinstruction_entry clear_page,1b,X86_FEATURE_REP_GOOD,\
+			     .Lclear_page_end-clear_page, 2b-1b
+	altinstruction_entry clear_page,2b,X86_FEATURE_ERMS,   \
+			     .Lclear_page_end-clear_page,3b-2b
 	.previous
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 99e4826..0248402 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -15,23 +15,30 @@
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/cpufeature.h>
+#include <asm/alternative-asm.h>
 
-	.macro ALTERNATIVE_JUMP feature,orig,alt
+/*
+ * By placing feature2 after feature1 in altinstructions section, we logically
+ * implement:
+ * If CPU has feature2, jmp to alt2 is used
+ * else if CPU has feature1, jmp to alt1 is used
+ * else jmp to orig is used.
+ */
+	.macro ALTERNATIVE_JUMP feature1,feature2,orig,alt1,alt2
 0:
 	.byte 0xe9	/* 32bit jump */
 	.long \orig-1f	/* by default jump to orig */
 1:
 	.section .altinstr_replacement,"ax"
 2:	.byte 0xe9			/* near jump with 32bit immediate */
-	.long \alt-1b /* offset */   /* or alternatively to alt */
+	.long \alt1-1b /* offset */   /* or alternatively to alt1 */
+3:	.byte 0xe9			/* near jump with 32bit immediate */
+	.long \alt2-1b /* offset */   /* or alternatively to alt2 */
 	.previous
+
 	.section .altinstructions,"a"
-	.align 8
-	.quad  0b
-	.quad  2b
-	.word  \feature			/* when feature is set */
-	.byte  5
-	.byte  5
+	altinstruction_entry 0b,2b,\feature1,5,5
+	altinstruction_entry 0b,3b,\feature2,5,5
 	.previous
 	.endm
 
@@ -72,8 +79,10 @@ ENTRY(_copy_to_user)
 	addq %rdx,%rcx
 	jc bad_to_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_to_user
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
+	ja bad_to_user
+	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
+		copy_user_generic_unrolled,copy_user_generic_string,	\
+		copy_user_enhanced_fast_string
 	CFI_ENDPROC
 ENDPROC(_copy_to_user)
 
@@ -85,8 +94,10 @@ ENTRY(_copy_from_user)
 	addq %rdx,%rcx
 	jc bad_from_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_from_user
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
+	ja bad_from_user
+	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
+		copy_user_generic_unrolled,copy_user_generic_string,	\
+		copy_user_enhanced_fast_string
 	CFI_ENDPROC
 ENDPROC(_copy_from_user)
 
@@ -255,3 +266,37 @@ ENTRY(copy_user_generic_string)
 	.previous
 	CFI_ENDPROC
 ENDPROC(copy_user_generic_string)
+
+/*
+ * Some CPUs are adding enhanced REP MOVSB/STOSB instructions.
+ * It's recommended to use enhanced REP MOVSB/STOSB if it's enabled.
+ *
+ * Input:
+ * rdi destination
+ * rsi source
+ * rdx count
+ *
+ * Output:
+ * eax uncopied bytes or 0 if successful.
+ */
+ENTRY(copy_user_enhanced_fast_string)
+	CFI_STARTPROC
+	andl %edx,%edx
+	jz 2f
+	movl %edx,%ecx
+1:	rep
+	movsb
+2:	xorl %eax,%eax
+	ret
+
+	.section .fixup,"ax"
+12:	movl %ecx,%edx		/* ecx is zerorest also */
+	jmp copy_user_handle_tail
+	.previous
+
+	.section __ex_table,"a"
+	.align 8
+	.quad 1b,12b
+	.previous
+	CFI_ENDPROC
+ENDPROC(copy_user_enhanced_fast_string)
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..daab21d 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -4,6 +4,7 @@
 
 #include <asm/cpufeature.h>
 #include <asm/dwarf2.h>
+#include <asm/alternative-asm.h>
 
 /*
  * memcpy - Copy a memory block.
@@ -37,6 +38,23 @@
 .Lmemcpy_e:
 	.previous
 
+/*
+ * memcpy_c_e() - enhanced fast string memcpy. This is faster and simpler than
+ * memcpy_c. Use memcpy_c_e when possible.
+ *
+ * This gets patched over the unrolled variant (below) via the
+ * alternative instructions framework:
+ */
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemcpy_c_e:
+	movq %rdi, %rax
+
+	movl %edx, %ecx
+	rep movsb
+	ret
+.Lmemcpy_e_e:
+	.previous
+
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
@@ -171,21 +189,22 @@ ENDPROC(memcpy)
 ENDPROC(__memcpy)
 
 	/*
-	 * Some CPUs run faster using the string copy instructions.
-	 * It is also a lot simpler. Use this when possible:
-	 */
-
-	.section .altinstructions, "a"
-	.align 8
-	.quad memcpy
-	.quad .Lmemcpy_c
-	.word X86_FEATURE_REP_GOOD
-
-	/*
+	 * Some CPUs are adding enhanced REP MOVSB/STOSB feature
+	 * If the feature is supported, memcpy_c_e() is the first choice.
+	 * If enhanced rep movsb copy is not available, use fast string copy
+	 * memcpy_c() when possible. This is faster and code is simpler than
+	 * original memcpy().
+	 * Otherwise, original memcpy() is used.
+	 * In .altinstructions section, ERMS feature is placed after REG_GOOD
+         * feature to implement the right patch order.
+	 *
 	 * Replace only beginning, memcpy is used to apply alternatives,
 	 * so it is silly to overwrite itself with nops - reboot is the
 	 * only outcome...
 	 */
-	.byte .Lmemcpy_e - .Lmemcpy_c
-	.byte .Lmemcpy_e - .Lmemcpy_c
+	.section .altinstructions, "a"
+	altinstruction_entry memcpy,.Lmemcpy_c,X86_FEATURE_REP_GOOD,\
+			     .Lmemcpy_e-.Lmemcpy_c,.Lmemcpy_e-.Lmemcpy_c
+	altinstruction_entry memcpy,.Lmemcpy_c_e,X86_FEATURE_ERMS, \
+			     .Lmemcpy_e_e-.Lmemcpy_c_e,.Lmemcpy_e_e-.Lmemcpy_c_e
 	.previous
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 0ecb843..d0ec9c2 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -8,6 +8,7 @@
 #define _STRING_C
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/cpufeature.h>
 
 #undef memmove
 
@@ -24,6 +25,7 @@
  */
 ENTRY(memmove)
 	CFI_STARTPROC
+
 	/* Handle more 32bytes in loop */
 	mov %rdi, %rax
 	cmp $0x20, %rdx
@@ -31,8 +33,13 @@ ENTRY(memmove)
 
 	/* Decide forward/backward copy mode */
 	cmp %rdi, %rsi
-	jb	2f
+	jge .Lmemmove_begin_forward
+	mov %rsi, %r8
+	add %rdx, %r8
+	cmp %rdi, %r8
+	jg 2f
 
+.Lmemmove_begin_forward:
 	/*
 	 * movsq instruction have many startup latency
 	 * so we handle small size by general register.
@@ -78,6 +85,8 @@ ENTRY(memmove)
 	rep movsq
 	movq %r11, (%r10)
 	jmp 13f
+.Lmemmove_end_forward:
+
 	/*
 	 * Handle data backward by movsq.
 	 */
@@ -194,4 +203,22 @@ ENTRY(memmove)
 13:
 	retq
 	CFI_ENDPROC
+
+	.section .altinstr_replacement,"ax"
+.Lmemmove_begin_forward_efs:
+	/* Forward moving data. */
+	movq %rdx, %rcx
+	rep movsb
+	retq
+.Lmemmove_end_forward_efs:
+	.previous
+
+	.section .altinstructions,"a"
+	.align 8
+	.quad .Lmemmove_begin_forward
+	.quad .Lmemmove_begin_forward_efs
+	.word X86_FEATURE_ERMS
+	.byte .Lmemmove_end_forward-.Lmemmove_begin_forward
+	.byte .Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
+	.previous
 ENDPROC(memmove)
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 09d3442..79bd454 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -2,9 +2,13 @@
 
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/cpufeature.h>
+#include <asm/alternative-asm.h>
 
 /*
- * ISO C memset - set a memory block to a byte value.
+ * ISO C memset - set a memory block to a byte value. This function uses fast
+ * string to get better performance than the original function. The code is
+ * simpler and shorter than the orignal function as well.
  *	
  * rdi   destination
  * rsi   value (char) 
@@ -31,6 +35,28 @@
 .Lmemset_e:
 	.previous
 
+/*
+ * ISO C memset - set a memory block to a byte value. This function uses
+ * enhanced rep stosb to override the fast string function.
+ * The code is simpler and shorter than the fast string function as well.
+ *
+ * rdi   destination
+ * rsi   value (char)
+ * rdx   count (bytes)
+ *
+ * rax   original destination
+ */
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemset_c_e:
+	movq %rdi,%r9
+	movb %sil,%al
+	movl %edx,%ecx
+	rep stosb
+	movq %r9,%rax
+	ret
+.Lmemset_e_e:
+	.previous
+
 ENTRY(memset)
 ENTRY(__memset)
 	CFI_STARTPROC
@@ -112,16 +138,20 @@ ENTRY(__memset)
 ENDPROC(memset)
 ENDPROC(__memset)
 
-	/* Some CPUs run faster using the string instructions.
-	   It is also a lot simpler. Use this when possible */
-
-#include <asm/cpufeature.h>
-
+	/* Some CPUs support enhanced REP MOVSB/STOSB feature.
+	 * It is recommended to use this when possible.
+	 *
+	 * If enhanced REP MOVSB/STOSB feature is not available, use fast string
+	 * instructions.
+	 *
+	 * Otherwise, use original memset function.
+	 *
+	 * In .altinstructions section, ERMS feature is placed after REG_GOOD
+         * feature to implement the right patch order.
+	 */
 	.section .altinstructions,"a"
-	.align 8
-	.quad memset
-	.quad .Lmemset_c
-	.word X86_FEATURE_REP_GOOD
-	.byte .Lfinal - memset
-	.byte .Lmemset_e - .Lmemset_c
+	altinstruction_entry memset,.Lmemset_c,X86_FEATURE_REP_GOOD,\
+			     .Lfinal-memset,.Lmemset_e-.Lmemset_c
+	altinstruction_entry memset,.Lmemset_c_e,X86_FEATURE_ERMS, \
+			     .Lfinal-memset,.Lmemset_e_e-.Lmemset_c_e
 	.previous
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 2d49d4e..a5b64ab 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -16,17 +16,6 @@
 #include <asm/stacktrace.h>
 #include <linux/compat.h>
 
-static void backtrace_warning_symbol(void *data, char *msg,
-				     unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
-
 static int backtrace_stack(void *data, char *name)
 {
 	/* Yes, we want all stacks */
@@ -42,8 +31,6 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 }
 
 static struct stacktrace_ops backtrace_ops = {
-	.warning	= backtrace_warning,
-	.warning_symbol	= backtrace_warning_symbol,
 	.stack		= backtrace_stack,
 	.address	= backtrace_address,
 	.walk_stack	= print_context_stack,
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bd297a2..75a8692 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -170,6 +170,10 @@
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
 	/* implement dynamic printk debug */				\
+	. = ALIGN(8);                                                   \
+	VMLINUX_SYMBOL(__start___jump_table) = .;                       \
+	*(__jump_table)                                                 \
+	VMLINUX_SYMBOL(__stop___jump_table) = .;                        \
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
 	*(__verbose)                                                    \
@@ -228,8 +232,6 @@
 									\
 	BUG_TABLE							\
 									\
-	JUMP_TABLE							\
-									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
@@ -589,14 +591,6 @@
 #define BUG_TABLE
 #endif
 
-#define JUMP_TABLE							\
-	. = ALIGN(8);							\
-	__jump_table : AT(ADDR(__jump_table) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start___jump_table) = .;		\
-		*(__jump_table)						\
-		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
-	}
-
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
 	. = ALIGN(4);							\
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 0c9653f..e747ecd 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -1,8 +1,6 @@
 #ifndef _DYNAMIC_DEBUG_H
 #define _DYNAMIC_DEBUG_H
 
-#include <linux/jump_label.h>
-
 /* dynamic_printk_enabled, and dynamic_printk_enabled2 are bitmasks in which
  * bit n is set to 1 if any modname hashes into the bucket n, 0 otherwise. They
  * use independent hash functions, to reduce the chance of false positives.
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ca29e03..9d88e1c 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -29,9 +29,22 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
+struct ftrace_hash;
+
+enum {
+	FTRACE_OPS_FL_ENABLED		= 1 << 0,
+	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
+	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
+};
+
 struct ftrace_ops {
-	ftrace_func_t	  func;
-	struct ftrace_ops *next;
+	ftrace_func_t			func;
+	struct ftrace_ops		*next;
+	unsigned long			flags;
+#ifdef CONFIG_DYNAMIC_FTRACE
+	struct ftrace_hash		*notrace_hash;
+	struct ftrace_hash		*filter_hash;
+#endif
 };
 
 extern int function_trace_stop;
@@ -146,14 +159,13 @@ extern void unregister_ftrace_function_probe_all(char *glob);
 extern int ftrace_text_reserved(void *start, void *end);
 
 enum {
-	FTRACE_FL_FREE		= (1 << 0),
-	FTRACE_FL_FAILED	= (1 << 1),
-	FTRACE_FL_FILTER	= (1 << 2),
-	FTRACE_FL_ENABLED	= (1 << 3),
-	FTRACE_FL_NOTRACE	= (1 << 4),
-	FTRACE_FL_CONVERTED	= (1 << 5),
+	FTRACE_FL_ENABLED	= (1 << 30),
+	FTRACE_FL_FREE		= (1 << 31),
 };
 
+#define FTRACE_FL_MASK		(0x3UL << 30)
+#define FTRACE_REF_MAX		((1 << 30) - 1)
+
 struct dyn_ftrace {
 	union {
 		unsigned long		ip; /* address of mcount call-site */
@@ -167,7 +179,12 @@ struct dyn_ftrace {
 };
 
 int ftrace_force_update(void);
-void ftrace_set_filter(unsigned char *buf, int len, int reset);
+void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+		       int len, int reset);
+void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+			int len, int reset);
+void ftrace_set_global_filter(unsigned char *buf, int len, int reset);
+void ftrace_set_global_notrace(unsigned char *buf, int len, int reset);
 
 int register_ftrace_command(struct ftrace_func_command *cmd);
 int unregister_ftrace_command(struct ftrace_func_command *cmd);
diff --git a/include/linux/init.h b/include/linux/init.h
index 577671c5..9146f39 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -79,29 +79,29 @@
 #define __exitused  __used
 #endif
 
-#define __exit          __section(.exit.text) __exitused __cold
+#define __exit          __section(.exit.text) __exitused __cold notrace
 
 /* Used for HOTPLUG */
-#define __devinit        __section(.devinit.text) __cold
+#define __devinit        __section(.devinit.text) __cold notrace
 #define __devinitdata    __section(.devinit.data)
 #define __devinitconst   __section(.devinit.rodata)
-#define __devexit        __section(.devexit.text) __exitused __cold
+#define __devexit        __section(.devexit.text) __exitused __cold notrace
 #define __devexitdata    __section(.devexit.data)
 #define __devexitconst   __section(.devexit.rodata)
 
 /* Used for HOTPLUG_CPU */
-#define __cpuinit        __section(.cpuinit.text) __cold
+#define __cpuinit        __section(.cpuinit.text) __cold notrace
 #define __cpuinitdata    __section(.cpuinit.data)
 #define __cpuinitconst   __section(.cpuinit.rodata)
-#define __cpuexit        __section(.cpuexit.text) __exitused __cold
+#define __cpuexit        __section(.cpuexit.text) __exitused __cold notrace
 #define __cpuexitdata    __section(.cpuexit.data)
 #define __cpuexitconst   __section(.cpuexit.rodata)
 
 /* Used for MEMORY_HOTPLUG */
-#define __meminit        __section(.meminit.text) __cold
+#define __meminit        __section(.meminit.text) __cold notrace
 #define __meminitdata    __section(.meminit.data)
 #define __meminitconst   __section(.meminit.rodata)
-#define __memexit        __section(.memexit.text) __exitused __cold
+#define __memexit        __section(.memexit.text) __exitused __cold notrace
 #define __memexitdata    __section(.memexit.data)
 #define __memexitconst   __section(.memexit.rodata)
 
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 7880f18..83e745f 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -1,20 +1,43 @@
 #ifndef _LINUX_JUMP_LABEL_H
 #define _LINUX_JUMP_LABEL_H
 
+#include <linux/types.h>
+#include <linux/compiler.h>
+
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+
+struct jump_label_key {
+	atomic_t enabled;
+	struct jump_entry *entries;
+#ifdef CONFIG_MODULES
+	struct jump_label_mod *next;
+#endif
+};
+
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif
 
 enum jump_label_type {
+	JUMP_LABEL_DISABLE = 0,
 	JUMP_LABEL_ENABLE,
-	JUMP_LABEL_DISABLE
 };
 
 struct module;
 
 #ifdef HAVE_JUMP_LABEL
 
+#ifdef CONFIG_MODULES
+#define JUMP_LABEL_INIT {{ 0 }, NULL, NULL}
+#else
+#define JUMP_LABEL_INIT {{ 0 }, NULL}
+#endif
+
+static __always_inline bool static_branch(struct jump_label_key *key)
+{
+	return arch_static_branch(key);
+}
+
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
@@ -23,37 +46,37 @@ extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
 extern void arch_jump_label_text_poke_early(jump_label_t addr);
-extern void jump_label_update(unsigned long key, enum jump_label_type type);
-extern void jump_label_apply_nops(struct module *mod);
 extern int jump_label_text_reserved(void *start, void *end);
+extern void jump_label_inc(struct jump_label_key *key);
+extern void jump_label_dec(struct jump_label_key *key);
+extern bool jump_label_enabled(struct jump_label_key *key);
+extern void jump_label_apply_nops(struct module *mod);
 
-#define jump_label_enable(key) \
-	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
+#else
 
-#define jump_label_disable(key) \
-	jump_label_update((unsigned long)key, JUMP_LABEL_DISABLE);
+#include <asm/atomic.h>
 
-#else
+#define JUMP_LABEL_INIT {ATOMIC_INIT(0)}
 
-#define JUMP_LABEL(key, label)			\
-do {						\
-	if (unlikely(*key))			\
-		goto label;			\
-} while (0)
+struct jump_label_key {
+	atomic_t enabled;
+};
 
-#define jump_label_enable(cond_var)	\
-do {					\
-       *(cond_var) = 1;			\
-} while (0)
+static __always_inline bool static_branch(struct jump_label_key *key)
+{
+	if (unlikely(atomic_read(&key->enabled)))
+		return true;
+	return false;
+}
 
-#define jump_label_disable(cond_var)	\
-do {					\
-       *(cond_var) = 0;			\
-} while (0)
+static inline void jump_label_inc(struct jump_label_key *key)
+{
+	atomic_inc(&key->enabled);
+}
 
-static inline int jump_label_apply_nops(struct module *mod)
+static inline void jump_label_dec(struct jump_label_key *key)
 {
-	return 0;
+	atomic_dec(&key->enabled);
 }
 
 static inline int jump_label_text_reserved(void *start, void *end)
@@ -64,16 +87,16 @@ static inline int jump_label_text_reserved(void *start, void *end)
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-#endif
+static inline bool jump_label_enabled(struct jump_label_key *key)
+{
+	return !!atomic_read(&key->enabled);
+}
 
-#define COND_STMT(key, stmt)					\
-do {								\
-	__label__ jl_enabled;					\
-	JUMP_LABEL(key, jl_enabled);				\
-	if (0) {						\
-jl_enabled:							\
-		stmt;						\
-	}							\
-} while (0)
+static inline int jump_label_apply_nops(struct module *mod)
+{
+	return 0;
+}
+
+#endif
 
 #endif
diff --git a/include/linux/jump_label_ref.h b/include/linux/jump_label_ref.h
deleted file mode 100644
index e5d012a..0000000
--- a/include/linux/jump_label_ref.h
+++ /dev/null
@@ -1,44 +0,0 @@
-#ifndef _LINUX_JUMP_LABEL_REF_H
-#define _LINUX_JUMP_LABEL_REF_H
-
-#include <linux/jump_label.h>
-#include <asm/atomic.h>
-
-#ifdef HAVE_JUMP_LABEL
-
-static inline void jump_label_inc(atomic_t *key)
-{
-	if (atomic_add_return(1, key) == 1)
-		jump_label_enable(key);
-}
-
-static inline void jump_label_dec(atomic_t *key)
-{
-	if (atomic_dec_and_test(key))
-		jump_label_disable(key);
-}
-
-#else /* !HAVE_JUMP_LABEL */
-
-static inline void jump_label_inc(atomic_t *key)
-{
-	atomic_inc(key);
-}
-
-static inline void jump_label_dec(atomic_t *key)
-{
-	atomic_dec(key);
-}
-
-#undef JUMP_LABEL
-#define JUMP_LABEL(key, label)						\
-do {									\
-	if (unlikely(__builtin_choose_expr(				\
-	      __builtin_types_compatible_p(typeof(key), atomic_t *),	\
-	      atomic_read((atomic_t *)(key)), *(key))))			\
-		goto label;						\
-} while (0)
-
-#endif /* HAVE_JUMP_LABEL */
-
-#endif /* _LINUX_JUMP_LABEL_REF_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 00cec4d..f37ba71 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -283,6 +283,7 @@ extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
+extern int core_kernel_data(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ee9f1e7..3412684 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -2,8 +2,8 @@
  * Performance events:
  *
  *    Copyright (C) 2008-2009, Thomas Gleixner <tglx@linutronix.de>
- *    Copyright (C) 2008-2009, Red Hat, Inc., Ingo Molnar
- *    Copyright (C) 2008-2009, Red Hat, Inc., Peter Zijlstra
+ *    Copyright (C) 2008-2011, Red Hat, Inc., Ingo Molnar
+ *    Copyright (C) 2008-2011, Red Hat, Inc., Peter Zijlstra
  *
  * Data type definitions, declarations, prototypes.
  *
@@ -52,6 +52,8 @@ enum perf_hw_id {
 	PERF_COUNT_HW_BRANCH_INSTRUCTIONS	= 4,
 	PERF_COUNT_HW_BRANCH_MISSES		= 5,
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
+	PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	= 7,
+	PERF_COUNT_HW_STALLED_CYCLES_BACKEND	= 8,
 
 	PERF_COUNT_HW_MAX,			/* non-ABI */
 };
@@ -468,9 +470,9 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
-#define PERF_FLAG_FD_NO_GROUP	(1U << 0)
-#define PERF_FLAG_FD_OUTPUT	(1U << 1)
-#define PERF_FLAG_PID_CGROUP	(1U << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_FD_NO_GROUP		(1U << 0)
+#define PERF_FLAG_FD_OUTPUT		(1U << 1)
+#define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
 #ifdef __KERNEL__
 /*
@@ -484,9 +486,9 @@ enum perf_callchain_context {
 #endif
 
 struct perf_guest_info_callbacks {
-	int (*is_in_guest) (void);
-	int (*is_user_mode) (void);
-	unsigned long (*get_guest_ip) (void);
+	int				(*is_in_guest)(void);
+	int				(*is_user_mode)(void);
+	unsigned long			(*get_guest_ip)(void);
 };
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
@@ -505,7 +507,7 @@ struct perf_guest_info_callbacks {
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
-#include <linux/jump_label_ref.h>
+#include <linux/jump_label.h>
 #include <asm/atomic.h>
 #include <asm/local.h>
 
@@ -652,19 +654,19 @@ struct pmu {
 	 * Start the transaction, after this ->add() doesn't need to
 	 * do schedulability tests.
 	 */
-	void (*start_txn)	(struct pmu *pmu); /* optional */
+	void (*start_txn)		(struct pmu *pmu); /* optional */
 	/*
 	 * If ->start_txn() disabled the ->add() schedulability test
 	 * then ->commit_txn() is required to perform one. On success
 	 * the transaction is closed. On error the transaction is kept
 	 * open until ->cancel_txn() is called.
 	 */
-	int  (*commit_txn)	(struct pmu *pmu); /* optional */
+	int  (*commit_txn)		(struct pmu *pmu); /* optional */
 	/*
 	 * Will cancel the transaction, assumes ->del() is called
 	 * for each successful ->add() during the transaction.
 	 */
-	void (*cancel_txn)	(struct pmu *pmu); /* optional */
+	void (*cancel_txn)		(struct pmu *pmu); /* optional */
 };
 
 /**
@@ -712,15 +714,15 @@ typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
 					struct pt_regs *regs);
 
 enum perf_group_flag {
-	PERF_GROUP_SOFTWARE = 0x1,
+	PERF_GROUP_SOFTWARE		= 0x1,
 };
 
-#define SWEVENT_HLIST_BITS	8
-#define SWEVENT_HLIST_SIZE	(1 << SWEVENT_HLIST_BITS)
+#define SWEVENT_HLIST_BITS		8
+#define SWEVENT_HLIST_SIZE		(1 << SWEVENT_HLIST_BITS)
 
 struct swevent_hlist {
-	struct hlist_head	heads[SWEVENT_HLIST_SIZE];
-	struct rcu_head		rcu_head;
+	struct hlist_head		heads[SWEVENT_HLIST_SIZE];
+	struct rcu_head			rcu_head;
 };
 
 #define PERF_ATTACH_CONTEXT	0x01
@@ -733,13 +735,13 @@ struct swevent_hlist {
  * This is a per-cpu dynamically allocated data structure.
  */
 struct perf_cgroup_info {
-	u64 time;
-	u64 timestamp;
+	u64				time;
+	u64				timestamp;
 };
 
 struct perf_cgroup {
-	struct cgroup_subsys_state css;
-	struct perf_cgroup_info *info;	/* timing info, one per cpu */
+	struct				cgroup_subsys_state css;
+	struct				perf_cgroup_info *info;	/* timing info, one per cpu */
 };
 #endif
 
@@ -923,7 +925,7 @@ struct perf_event_context {
 
 /*
  * Number of contexts where an event can trigger:
- * 	task, softirq, hardirq, nmi.
+ *	task, softirq, hardirq, nmi.
  */
 #define PERF_NR_CONTEXTS	4
 
@@ -1001,8 +1003,7 @@ struct perf_sample_data {
 	struct perf_raw_record		*raw;
 };
 
-static inline
-void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
+static inline void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
 {
 	data->addr = addr;
 	data->raw  = NULL;
@@ -1034,13 +1035,12 @@ static inline int is_software_event(struct perf_event *event)
 	return event->pmu->task_ctx_nr == perf_sw_context;
 }
 
-extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
+extern struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 
 #ifndef perf_arch_fetch_caller_regs
-static inline void
-perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
+static inline void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
 #endif
 
 /*
@@ -1063,26 +1063,24 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
-	JUMP_LABEL(&perf_swevent_enabled[event_id], have_event);
-	return;
-
-have_event:
-	if (!regs) {
-		perf_fetch_caller_regs(&hot_regs);
-		regs = &hot_regs;
+	if (static_branch(&perf_swevent_enabled[event_id])) {
+		if (!regs) {
+			perf_fetch_caller_regs(&hot_regs);
+			regs = &hot_regs;
+		}
+		__perf_sw_event(event_id, nr, nmi, regs, addr);
 	}
-	__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
-extern atomic_t perf_sched_events;
+extern struct jump_label_key perf_sched_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *task)
 {
-	COND_STMT(&perf_sched_events, __perf_event_task_sched_in(task));
+	if (static_branch(&perf_sched_events))
+		__perf_event_task_sched_in(task);
 }
 
-static inline
-void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
+static inline void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
@@ -1100,14 +1098,10 @@ extern void perf_event_fork(struct task_struct *tsk);
 /* Callchains */
 DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
 
-extern void perf_callchain_user(struct perf_callchain_entry *entry,
-				struct pt_regs *regs);
-extern void perf_callchain_kernel(struct perf_callchain_entry *entry,
-				  struct pt_regs *regs);
-
+extern void perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs);
+extern void perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs);
 
-static inline void
-perf_callchain_store(struct perf_callchain_entry *entry, u64 ip)
+static inline void perf_callchain_store(struct perf_callchain_entry *entry, u64 ip)
 {
 	if (entry->nr < PERF_MAX_STACK_DEPTH)
 		entry->ip[entry->nr++] = ip;
@@ -1143,9 +1137,9 @@ extern void perf_tp_event(u64 addr, u64 count, void *record,
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
-#define perf_misc_flags(regs)	(user_mode(regs) ? PERF_RECORD_MISC_USER : \
-				 PERF_RECORD_MISC_KERNEL)
-#define perf_instruction_pointer(regs)	instruction_pointer(regs)
+# define perf_misc_flags(regs) \
+		(user_mode(regs) ? PERF_RECORD_MISC_USER : PERF_RECORD_MISC_KERNEL)
+# define perf_instruction_pointer(regs)	instruction_pointer(regs)
 #endif
 
 extern int perf_output_begin(struct perf_output_handle *handle,
@@ -1180,9 +1174,9 @@ static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
 static inline int perf_register_guest_info_callbacks
-(struct perf_guest_info_callbacks *callbacks) { return 0; }
+(struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 static inline int perf_unregister_guest_info_callbacks
-(struct perf_guest_info_callbacks *callbacks) { return 0; }
+(struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
@@ -1195,23 +1189,22 @@ static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
 #endif
 
-#define perf_output_put(handle, x) \
-	perf_output_copy((handle), &(x), sizeof(x))
+#define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
 
 /*
  * This has to have a higher priority than migration_notifier in sched.c.
  */
-#define perf_cpu_notifier(fn)					\
-do {								\
-	static struct notifier_block fn##_nb __cpuinitdata =	\
-		{ .notifier_call = fn, .priority = CPU_PRI_PERF }; \
-	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,		\
-		(void *)(unsigned long)smp_processor_id());	\
-	fn(&fn##_nb, (unsigned long)CPU_STARTING,		\
-		(void *)(unsigned long)smp_processor_id());	\
-	fn(&fn##_nb, (unsigned long)CPU_ONLINE,			\
-		(void *)(unsigned long)smp_processor_id());	\
-	register_cpu_notifier(&fn##_nb);			\
+#define perf_cpu_notifier(fn)						\
+do {									\
+	static struct notifier_block fn##_nb __cpuinitdata =		\
+		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
+	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
+		(void *)(unsigned long)smp_processor_id());		\
+	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
+		(void *)(unsigned long)smp_processor_id());		\
+	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
+		(void *)(unsigned long)smp_processor_id());		\
+	register_cpu_notifier(&fn##_nb);				\
 } while (0)
 
 #endif /* __KERNEL__ */
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 97c84a5..d530a44 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -29,7 +29,7 @@ struct tracepoint_func {
 
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
-	int state;			/* State. */
+	struct jump_label_key key;
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	struct tracepoint_func __rcu *funcs;
@@ -146,9 +146,7 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
-		return;							\
-do_trace:								\
+		if (static_branch(&__tracepoint_##name.key))		\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
@@ -176,14 +174,14 @@ do_trace:								\
  * structures, so we create an array of pointers that will be used for iteration
  * on the tracepoints.
  */
-#define DEFINE_TRACE_FN(name, reg, unreg)				\
-	static const char __tpstrtab_##name[]				\
-	__attribute__((section("__tracepoints_strings"))) = #name;	\
-	struct tracepoint __tracepoint_##name				\
-	__attribute__((section("__tracepoints"))) =			\
-		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
-	static struct tracepoint * const __tracepoint_ptr_##name __used	\
-	__attribute__((section("__tracepoints_ptrs"))) =		\
+#define DEFINE_TRACE_FN(name, reg, unreg)				 \
+	static const char __tpstrtab_##name[]				 \
+	__attribute__((section("__tracepoints_strings"))) = #name;	 \
+	struct tracepoint __tracepoint_##name				 \
+	__attribute__((section("__tracepoints"))) =			 \
+		{ __tpstrtab_##name, JUMP_LABEL_INIT, reg, unreg, NULL };\
+	static struct tracepoint * const __tracepoint_ptr_##name __used	 \
+	__attribute__((section("__tracepoints_ptrs"))) =		 \
 		&__tracepoint_##name;
 
 #define DEFINE_TRACE(name)						\
diff --git a/kernel/Makefile b/kernel/Makefile
index 85cbfb3..e9cf191 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -21,7 +21,6 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_perf_event.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
@@ -103,8 +102,9 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
-obj-$(CONFIG_PERF_EVENTS) += perf_event.o
-obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
+
+obj-$(CONFIG_PERF_EVENTS) += events/
+
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
new file mode 100644
index 0000000..1ce23d3
--- /dev/null
+++ b/kernel/events/Makefile
@@ -0,0 +1,6 @@
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_core.o = -pg
+endif
+
+obj-y := core.o
+obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
diff --git a/kernel/perf_event.c b/kernel/events/core.c
similarity index 99%
rename from kernel/perf_event.c
rename to kernel/events/core.c
index 8e81a98..0fc34a3 100644
--- a/kernel/perf_event.c
+++ b/kernel/events/core.c
@@ -2,8 +2,8 @@
  * Performance events core code:
  *
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
- *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
- *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *  Copyright  �  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
@@ -39,10 +39,10 @@
 #include <asm/irq_regs.h>
 
 struct remote_function_call {
-	struct task_struct *p;
-	int (*func)(void *info);
-	void *info;
-	int ret;
+	struct task_struct	*p;
+	int			(*func)(void *info);
+	void			*info;
+	int			ret;
 };
 
 static void remote_function(void *data)
@@ -76,10 +76,10 @@ static int
 task_function_call(struct task_struct *p, int (*func) (void *info), void *info)
 {
 	struct remote_function_call data = {
-		.p = p,
-		.func = func,
-		.info = info,
-		.ret = -ESRCH, /* No such (running) process */
+		.p	= p,
+		.func	= func,
+		.info	= info,
+		.ret	= -ESRCH, /* No such (running) process */
 	};
 
 	if (task_curr(p))
@@ -100,10 +100,10 @@ task_function_call(struct task_struct *p, int (*func) (void *info), void *info)
 static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 {
 	struct remote_function_call data = {
-		.p = NULL,
-		.func = func,
-		.info = info,
-		.ret = -ENXIO, /* No such CPU */
+		.p	= NULL,
+		.func	= func,
+		.info	= info,
+		.ret	= -ENXIO, /* No such CPU */
 	};
 
 	smp_call_function_single(cpu, remote_function, &data, 1);
@@ -125,7 +125,7 @@ enum event_type_t {
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
  */
-atomic_t perf_sched_events __read_mostly;
+struct jump_label_key perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 
 static atomic_t nr_mmap_events __read_mostly;
@@ -5429,7 +5429,7 @@ fail:
 	return err;
 }
 
-atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
+struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 static void sw_perf_event_destroy(struct perf_event *event)
 {
@@ -7445,11 +7445,11 @@ static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 }
 
 struct cgroup_subsys perf_subsys = {
-	.name = "perf_event",
-	.subsys_id = perf_subsys_id,
-	.create = perf_cgroup_create,
-	.destroy = perf_cgroup_destroy,
-	.exit = perf_cgroup_exit,
-	.attach = perf_cgroup_attach,
+	.name		= "perf_event",
+	.subsys_id	= perf_subsys_id,
+	.create		= perf_cgroup_create,
+	.destroy	= perf_cgroup_destroy,
+	.exit		= perf_cgroup_exit,
+	.attach		= perf_cgroup_attach,
 };
 #endif /* CONFIG_CGROUP_PERF */
diff --git a/kernel/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
similarity index 100%
rename from kernel/hw_breakpoint.c
rename to kernel/events/hw_breakpoint.c
diff --git a/kernel/extable.c b/kernel/extable.c
index 7f8f263..c2d625f 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -72,6 +72,14 @@ int core_kernel_text(unsigned long addr)
 	return 0;
 }
 
+int core_kernel_data(unsigned long addr)
+{
+	if (addr >= (unsigned long)_sdata &&
+	    addr < (unsigned long)_edata)
+		return 1;
+	return 0;
+}
+
 int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 3b79bd9..74d1c09 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -2,43 +2,23 @@
  * jump label support
  *
  * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
+ * Copyright (C) 2011 Peter Zijlstra <pzijlstr@redhat.com>
  *
  */
-#include <linux/jump_label.h>
 #include <linux/memory.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/list.h>
-#include <linux/jhash.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/err.h>
+#include <linux/jump_label.h>
 
 #ifdef HAVE_JUMP_LABEL
 
-#define JUMP_LABEL_HASH_BITS 6
-#define JUMP_LABEL_TABLE_SIZE (1 << JUMP_LABEL_HASH_BITS)
-static struct hlist_head jump_label_table[JUMP_LABEL_TABLE_SIZE];
-
 /* mutex to protect coming/going of the the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
 
-struct jump_label_entry {
-	struct hlist_node hlist;
-	struct jump_entry *table;
-	int nr_entries;
-	/* hang modules off here */
-	struct hlist_head modules;
-	unsigned long key;
-};
-
-struct jump_label_module_entry {
-	struct hlist_node hlist;
-	struct jump_entry *table;
-	int nr_entries;
-	struct module *mod;
-};
-
 void jump_label_lock(void)
 {
 	mutex_lock(&jump_label_mutex);
@@ -49,6 +29,11 @@ void jump_label_unlock(void)
 	mutex_unlock(&jump_label_mutex);
 }
 
+bool jump_label_enabled(struct jump_label_key *key)
+{
+	return !!atomic_read(&key->enabled);
+}
+
 static int jump_label_cmp(const void *a, const void *b)
 {
 	const struct jump_entry *jea = a;
@@ -64,7 +49,7 @@ static int jump_label_cmp(const void *a, const void *b)
 }
 
 static void
-sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
+jump_label_sort_entries(struct jump_entry *start, struct jump_entry *stop)
 {
 	unsigned long size;
 
@@ -73,118 +58,25 @@ sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
 	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
 }
 
-static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
-{
-	struct hlist_head *head;
-	struct hlist_node *node;
-	struct jump_label_entry *e;
-	u32 hash = jhash((void *)&key, sizeof(jump_label_t), 0);
-
-	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
-		if (key == e->key)
-			return e;
-	}
-	return NULL;
-}
+static void jump_label_update(struct jump_label_key *key, int enable);
 
-static struct jump_label_entry *
-add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
+void jump_label_inc(struct jump_label_key *key)
 {
-	struct hlist_head *head;
-	struct jump_label_entry *e;
-	u32 hash;
-
-	e = get_jump_label_entry(key);
-	if (e)
-		return ERR_PTR(-EEXIST);
-
-	e = kmalloc(sizeof(struct jump_label_entry), GFP_KERNEL);
-	if (!e)
-		return ERR_PTR(-ENOMEM);
-
-	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
-	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
-	e->key = key;
-	e->table = table;
-	e->nr_entries = nr_entries;
-	INIT_HLIST_HEAD(&(e->modules));
-	hlist_add_head(&e->hlist, head);
-	return e;
-}
+	if (atomic_inc_not_zero(&key->enabled))
+		return;
 
-static int
-build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
-{
-	struct jump_entry *iter, *iter_begin;
-	struct jump_label_entry *entry;
-	int count;
-
-	sort_jump_label_entries(start, stop);
-	iter = start;
-	while (iter < stop) {
-		entry = get_jump_label_entry(iter->key);
-		if (!entry) {
-			iter_begin = iter;
-			count = 0;
-			while ((iter < stop) &&
-				(iter->key == iter_begin->key)) {
-				iter++;
-				count++;
-			}
-			entry = add_jump_label_entry(iter_begin->key,
-							count, iter_begin);
-			if (IS_ERR(entry))
-				return PTR_ERR(entry);
-		 } else {
-			WARN_ONCE(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
-			return -1;
-		}
-	}
-	return 0;
+	jump_label_lock();
+	if (atomic_add_return(1, &key->enabled) == 1)
+		jump_label_update(key, JUMP_LABEL_ENABLE);
+	jump_label_unlock();
 }
 
-/***
- * jump_label_update - update jump label text
- * @key -  key value associated with a a jump label
- * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
- *
- * Will enable/disable the jump for jump label @key, depending on the
- * value of @type.
- *
- */
-
-void jump_label_update(unsigned long key, enum jump_label_type type)
+void jump_label_dec(struct jump_label_key *key)
 {
-	struct jump_entry *iter;
-	struct jump_label_entry *entry;
-	struct hlist_node *module_node;
-	struct jump_label_module_entry *e_module;
-	int count;
+	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
+		return;
 
-	jump_label_lock();
-	entry = get_jump_label_entry((jump_label_t)key);
-	if (entry) {
-		count = entry->nr_entries;
-		iter = entry->table;
-		while (count--) {
-			if (kernel_text_address(iter->code))
-				arch_jump_label_transform(iter, type);
-			iter++;
-		}
-		/* eanble/disable jump labels in modules */
-		hlist_for_each_entry(e_module, module_node, &(entry->modules),
-							hlist) {
-			count = e_module->nr_entries;
-			iter = e_module->table;
-			while (count--) {
-				if (iter->key &&
-						kernel_text_address(iter->code))
-					arch_jump_label_transform(iter, type);
-				iter++;
-			}
-		}
-	}
+	jump_label_update(key, JUMP_LABEL_DISABLE);
 	jump_label_unlock();
 }
 
@@ -197,77 +89,33 @@ static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 	return 0;
 }
 
-#ifdef CONFIG_MODULES
-
-static int module_conflict(void *start, void *end)
+static int __jump_label_text_reserved(struct jump_entry *iter_start,
+		struct jump_entry *iter_stop, void *start, void *end)
 {
-	struct hlist_head *head;
-	struct hlist_node *node, *node_next, *module_node, *module_node_next;
-	struct jump_label_entry *e;
-	struct jump_label_module_entry *e_module;
 	struct jump_entry *iter;
-	int i, count;
-	int conflict = 0;
-
-	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
-		head = &jump_label_table[i];
-		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
-			hlist_for_each_entry_safe(e_module, module_node,
-							module_node_next,
-							&(e->modules), hlist) {
-				count = e_module->nr_entries;
-				iter = e_module->table;
-				while (count--) {
-					if (addr_conflict(iter, start, end)) {
-						conflict = 1;
-						goto out;
-					}
-					iter++;
-				}
-			}
-		}
-	}
-out:
-	return conflict;
-}
-
-#endif
-
-/***
- * jump_label_text_reserved - check if addr range is reserved
- * @start: start text addr
- * @end: end text addr
- *
- * checks if the text addr located between @start and @end
- * overlaps with any of the jump label patch addresses. Code
- * that wants to modify kernel text should first verify that
- * it does not overlap with any of the jump label addresses.
- * Caller must hold jump_label_mutex.
- *
- * returns 1 if there is an overlap, 0 otherwise
- */
-int jump_label_text_reserved(void *start, void *end)
-{
-	struct jump_entry *iter;
-	struct jump_entry *iter_start = __start___jump_table;
-	struct jump_entry *iter_stop = __start___jump_table;
-	int conflict = 0;
 
 	iter = iter_start;
 	while (iter < iter_stop) {
-		if (addr_conflict(iter, start, end)) {
-			conflict = 1;
-			goto out;
-		}
+		if (addr_conflict(iter, start, end))
+			return 1;
 		iter++;
 	}
 
-	/* now check modules */
-#ifdef CONFIG_MODULES
-	conflict = module_conflict(start, end);
-#endif
-out:
-	return conflict;
+	return 0;
+}
+
+static void __jump_label_update(struct jump_label_key *key,
+		struct jump_entry *entry, int enable)
+{
+	for (; entry->key == (jump_label_t)(unsigned long)key; entry++) {
+		/*
+		 * entry->code set to 0 invalidates module init text sections
+		 * kernel_text_address() verifies we are not in core kernel
+		 * init code, see jump_label_invalidate_module_init().
+		 */
+		if (entry->code && kernel_text_address(entry->code))
+			arch_jump_label_transform(entry, enable);
+	}
 }
 
 /*
@@ -277,142 +125,173 @@ void __weak arch_jump_label_text_poke_early(jump_label_t addr)
 {
 }
 
-static __init int init_jump_label(void)
+static __init int jump_label_init(void)
 {
-	int ret;
 	struct jump_entry *iter_start = __start___jump_table;
 	struct jump_entry *iter_stop = __stop___jump_table;
+	struct jump_label_key *key = NULL;
 	struct jump_entry *iter;
 
 	jump_label_lock();
-	ret = build_jump_label_hashtable(__start___jump_table,
-					 __stop___jump_table);
-	iter = iter_start;
-	while (iter < iter_stop) {
+	jump_label_sort_entries(iter_start, iter_stop);
+
+	for (iter = iter_start; iter < iter_stop; iter++) {
 		arch_jump_label_text_poke_early(iter->code);
-		iter++;
+		if (iter->key == (jump_label_t)(unsigned long)key)
+			continue;
+
+		key = (struct jump_label_key *)(unsigned long)iter->key;
+		atomic_set(&key->enabled, 0);
+		key->entries = iter;
+#ifdef CONFIG_MODULES
+		key->next = NULL;
+#endif
 	}
 	jump_label_unlock();
-	return ret;
+
+	return 0;
 }
-early_initcall(init_jump_label);
+early_initcall(jump_label_init);
 
 #ifdef CONFIG_MODULES
 
-static struct jump_label_module_entry *
-add_jump_label_module_entry(struct jump_label_entry *entry,
-			    struct jump_entry *iter_begin,
-			    int count, struct module *mod)
+struct jump_label_mod {
+	struct jump_label_mod *next;
+	struct jump_entry *entries;
+	struct module *mod;
+};
+
+static int __jump_label_mod_text_reserved(void *start, void *end)
+{
+	struct module *mod;
+
+	mod = __module_text_address((unsigned long)start);
+	if (!mod)
+		return 0;
+
+	WARN_ON_ONCE(__module_text_address((unsigned long)end) != mod);
+
+	return __jump_label_text_reserved(mod->jump_entries,
+				mod->jump_entries + mod->num_jump_entries,
+				start, end);
+}
+
+static void __jump_label_mod_update(struct jump_label_key *key, int enable)
+{
+	struct jump_label_mod *mod = key->next;
+
+	while (mod) {
+		__jump_label_update(key, mod->entries, enable);
+		mod = mod->next;
+	}
+}
+
+/***
+ * apply_jump_label_nops - patch module jump labels with arch_get_jump_label_nop()
+ * @mod: module to patch
+ *
+ * Allow for run-time selection of the optimal nops. Before the module
+ * loads patch these with arch_get_jump_label_nop(), which is specified by
+ * the arch specific jump label code.
+ */
+void jump_label_apply_nops(struct module *mod)
 {
-	struct jump_label_module_entry *e;
-
-	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
-	if (!e)
-		return ERR_PTR(-ENOMEM);
-	e->mod = mod;
-	e->nr_entries = count;
-	e->table = iter_begin;
-	hlist_add_head(&e->hlist, &entry->modules);
-	return e;
+	struct jump_entry *iter_start = mod->jump_entries;
+	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
+	struct jump_entry *iter;
+
+	/* if the module doesn't have jump label entries, just return */
+	if (iter_start == iter_stop)
+		return;
+
+	for (iter = iter_start; iter < iter_stop; iter++)
+		arch_jump_label_text_poke_early(iter->code);
 }
 
-static int add_jump_label_module(struct module *mod)
+static int jump_label_add_module(struct module *mod)
 {
-	struct jump_entry *iter, *iter_begin;
-	struct jump_label_entry *entry;
-	struct jump_label_module_entry *module_entry;
-	int count;
+	struct jump_entry *iter_start = mod->jump_entries;
+	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
+	struct jump_entry *iter;
+	struct jump_label_key *key = NULL;
+	struct jump_label_mod *jlm;
 
 	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
+	if (iter_start == iter_stop)
 		return 0;
 
-	sort_jump_label_entries(mod->jump_entries,
-				mod->jump_entries + mod->num_jump_entries);
-	iter = mod->jump_entries;
-	while (iter < mod->jump_entries + mod->num_jump_entries) {
-		entry = get_jump_label_entry(iter->key);
-		iter_begin = iter;
-		count = 0;
-		while ((iter < mod->jump_entries + mod->num_jump_entries) &&
-			(iter->key == iter_begin->key)) {
-				iter++;
-				count++;
-		}
-		if (!entry) {
-			entry = add_jump_label_entry(iter_begin->key, 0, NULL);
-			if (IS_ERR(entry))
-				return PTR_ERR(entry);
+	jump_label_sort_entries(iter_start, iter_stop);
+
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		if (iter->key == (jump_label_t)(unsigned long)key)
+			continue;
+
+		key = (struct jump_label_key *)(unsigned long)iter->key;
+
+		if (__module_address(iter->key) == mod) {
+			atomic_set(&key->enabled, 0);
+			key->entries = iter;
+			key->next = NULL;
+			continue;
 		}
-		module_entry = add_jump_label_module_entry(entry, iter_begin,
-							   count, mod);
-		if (IS_ERR(module_entry))
-			return PTR_ERR(module_entry);
+
+		jlm = kzalloc(sizeof(struct jump_label_mod), GFP_KERNEL);
+		if (!jlm)
+			return -ENOMEM;
+
+		jlm->mod = mod;
+		jlm->entries = iter;
+		jlm->next = key->next;
+		key->next = jlm;
+
+		if (jump_label_enabled(key))
+			__jump_label_update(key, iter, JUMP_LABEL_ENABLE);
 	}
+
 	return 0;
 }
 
-static void remove_jump_label_module(struct module *mod)
+static void jump_label_del_module(struct module *mod)
 {
-	struct hlist_head *head;
-	struct hlist_node *node, *node_next, *module_node, *module_node_next;
-	struct jump_label_entry *e;
-	struct jump_label_module_entry *e_module;
-	int i;
+	struct jump_entry *iter_start = mod->jump_entries;
+	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
+	struct jump_entry *iter;
+	struct jump_label_key *key = NULL;
+	struct jump_label_mod *jlm, **prev;
 
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		if (iter->key == (jump_label_t)(unsigned long)key)
+			continue;
+
+		key = (struct jump_label_key *)(unsigned long)iter->key;
+
+		if (__module_address(iter->key) == mod)
+			continue;
+
+		prev = &key->next;
+		jlm = key->next;
 
-	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
-		head = &jump_label_table[i];
-		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
-			hlist_for_each_entry_safe(e_module, module_node,
-						  module_node_next,
-						  &(e->modules), hlist) {
-				if (e_module->mod == mod) {
-					hlist_del(&e_module->hlist);
-					kfree(e_module);
-				}
-			}
-			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
-				hlist_del(&e->hlist);
-				kfree(e);
-			}
+		while (jlm && jlm->mod != mod) {
+			prev = &jlm->next;
+			jlm = jlm->next;
+		}
+
+		if (jlm) {
+			*prev = jlm->next;
+			kfree(jlm);
 		}
 	}
 }
 
-static void remove_jump_label_module_init(struct module *mod)
+static void jump_label_invalidate_module_init(struct module *mod)
 {
-	struct hlist_head *head;
-	struct hlist_node *node, *node_next, *module_node, *module_node_next;
-	struct jump_label_entry *e;
-	struct jump_label_module_entry *e_module;
+	struct jump_entry *iter_start = mod->jump_entries;
+	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
 	struct jump_entry *iter;
-	int i, count;
-
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
 
-	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
-		head = &jump_label_table[i];
-		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
-			hlist_for_each_entry_safe(e_module, module_node,
-						  module_node_next,
-						  &(e->modules), hlist) {
-				if (e_module->mod != mod)
-					continue;
-				count = e_module->nr_entries;
-				iter = e_module->table;
-				while (count--) {
-					if (within_module_init(iter->code, mod))
-						iter->key = 0;
-					iter++;
-				}
-			}
-		}
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		if (within_module_init(iter->code, mod))
+			iter->code = 0;
 	}
 }
 
@@ -426,59 +305,77 @@ jump_label_module_notify(struct notifier_block *self, unsigned long val,
 	switch (val) {
 	case MODULE_STATE_COMING:
 		jump_label_lock();
-		ret = add_jump_label_module(mod);
+		ret = jump_label_add_module(mod);
 		if (ret)
-			remove_jump_label_module(mod);
+			jump_label_del_module(mod);
 		jump_label_unlock();
 		break;
 	case MODULE_STATE_GOING:
 		jump_label_lock();
-		remove_jump_label_module(mod);
+		jump_label_del_module(mod);
 		jump_label_unlock();
 		break;
 	case MODULE_STATE_LIVE:
 		jump_label_lock();
-		remove_jump_label_module_init(mod);
+		jump_label_invalidate_module_init(mod);
 		jump_label_unlock();
 		break;
 	}
-	return ret;
-}
 
-/***
- * apply_jump_label_nops - patch module jump labels with arch_get_jump_label_nop()
- * @mod: module to patch
- *
- * Allow for run-time selection of the optimal nops. Before the module
- * loads patch these with arch_get_jump_label_nop(), which is specified by
- * the arch specific jump label code.
- */
-void jump_label_apply_nops(struct module *mod)
-{
-	struct jump_entry *iter;
-
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
-
-	iter = mod->jump_entries;
-	while (iter < mod->jump_entries + mod->num_jump_entries) {
-		arch_jump_label_text_poke_early(iter->code);
-		iter++;
-	}
+	return notifier_from_errno(ret);
 }
 
 struct notifier_block jump_label_module_nb = {
 	.notifier_call = jump_label_module_notify,
-	.priority = 0,
+	.priority = 1, /* higher than tracepoints */
 };
 
-static __init int init_jump_label_module(void)
+static __init int jump_label_init_module(void)
 {
 	return register_module_notifier(&jump_label_module_nb);
 }
-early_initcall(init_jump_label_module);
+early_initcall(jump_label_init_module);
 
 #endif /* CONFIG_MODULES */
 
+/***
+ * jump_label_text_reserved - check if addr range is reserved
+ * @start: start text addr
+ * @end: end text addr
+ *
+ * checks if the text addr located between @start and @end
+ * overlaps with any of the jump label patch addresses. Code
+ * that wants to modify kernel text should first verify that
+ * it does not overlap with any of the jump label addresses.
+ * Caller must hold jump_label_mutex.
+ *
+ * returns 1 if there is an overlap, 0 otherwise
+ */
+int jump_label_text_reserved(void *start, void *end)
+{
+	int ret = __jump_label_text_reserved(__start___jump_table,
+			__stop___jump_table, start, end);
+
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_MODULES
+	ret = __jump_label_mod_text_reserved(start, end);
+#endif
+	return ret;
+}
+
+static void jump_label_update(struct jump_label_key *key, int enable)
+{
+	struct jump_entry *entry = key->entries;
+
+	/* if there are no users, entry can be NULL */
+	if (entry)
+		__jump_label_update(key, entry, enable);
+
+#ifdef CONFIG_MODULES
+	__jump_label_mod_update(key, enable);
+#endif
+}
+
 #endif
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ee24fa1..d017c2c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -39,20 +39,26 @@
 #include "trace_stat.h"
 
 #define FTRACE_WARN_ON(cond)			\
-	do {					\
-		if (WARN_ON(cond))		\
+	({					\
+		int ___r = cond;		\
+		if (WARN_ON(___r))		\
 			ftrace_kill();		\
-	} while (0)
+		___r;				\
+	})
 
 #define FTRACE_WARN_ON_ONCE(cond)		\
-	do {					\
-		if (WARN_ON_ONCE(cond))		\
+	({					\
+		int ___r = cond;		\
+		if (WARN_ON_ONCE(___r))		\
 			ftrace_kill();		\
-	} while (0)
+		___r;				\
+	})
 
 /* hash bits for specific function selection */
 #define FTRACE_HASH_BITS 7
 #define FTRACE_FUNC_HASHSIZE (1 << FTRACE_HASH_BITS)
+#define FTRACE_HASH_DEFAULT_BITS 10
+#define FTRACE_HASH_MAX_BITS 12
 
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
@@ -81,23 +87,29 @@ static struct ftrace_ops ftrace_list_end __read_mostly =
 	.func		= ftrace_stub,
 };
 
-static struct ftrace_ops *ftrace_list __read_mostly = &ftrace_list_end;
+static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
+static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
+static struct ftrace_ops global_ops;
+
+static void
+ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
 
 /*
- * Traverse the ftrace_list, invoking all entries.  The reason that we
+ * Traverse the ftrace_global_list, invoking all entries.  The reason that we
  * can use rcu_dereference_raw() is that elements removed from this list
  * are simply leaked, so there is no need to interact with a grace-period
  * mechanism.  The rcu_dereference_raw() calls are needed to handle
- * concurrent insertions into the ftrace_list.
+ * concurrent insertions into the ftrace_global_list.
  *
  * Silly Alpha and silly pointer-speculation compiler optimizations!
  */
-static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
+static void ftrace_global_list_func(unsigned long ip,
+				    unsigned long parent_ip)
 {
-	struct ftrace_ops *op = rcu_dereference_raw(ftrace_list); /*see above*/
+	struct ftrace_ops *op = rcu_dereference_raw(ftrace_global_list); /*see above*/
 
 	while (op != &ftrace_list_end) {
 		op->func(ip, parent_ip);
@@ -147,46 +159,69 @@ static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
 }
 #endif
 
-static int __register_ftrace_function(struct ftrace_ops *ops)
+static void update_global_ops(void)
 {
-	ops->next = ftrace_list;
+	ftrace_func_t func;
+
 	/*
-	 * We are entering ops into the ftrace_list but another
-	 * CPU might be walking that list. We need to make sure
-	 * the ops->next pointer is valid before another CPU sees
-	 * the ops pointer included into the ftrace_list.
+	 * If there's only one function registered, then call that
+	 * function directly. Otherwise, we need to iterate over the
+	 * registered callers.
 	 */
-	rcu_assign_pointer(ftrace_list, ops);
+	if (ftrace_global_list == &ftrace_list_end ||
+	    ftrace_global_list->next == &ftrace_list_end)
+		func = ftrace_global_list->func;
+	else
+		func = ftrace_global_list_func;
 
-	if (ftrace_enabled) {
-		ftrace_func_t func;
+	/* If we filter on pids, update to use the pid function */
+	if (!list_empty(&ftrace_pids)) {
+		set_ftrace_pid_function(func);
+		func = ftrace_pid_func;
+	}
 
-		if (ops->next == &ftrace_list_end)
-			func = ops->func;
-		else
-			func = ftrace_list_func;
+	global_ops.func = func;
+}
 
-		if (!list_empty(&ftrace_pids)) {
-			set_ftrace_pid_function(func);
-			func = ftrace_pid_func;
-		}
+static void update_ftrace_function(void)
+{
+	ftrace_func_t func;
+
+	update_global_ops();
+
+	/*
+	 * If we are at the end of the list and this ops is
+	 * not dynamic, then have the mcount trampoline call
+	 * the function directly
+	 */
+	if (ftrace_ops_list == &ftrace_list_end ||
+	    (ftrace_ops_list->next == &ftrace_list_end &&
+	     !(ftrace_ops_list->flags & FTRACE_OPS_FL_DYNAMIC)))
+		func = ftrace_ops_list->func;
+	else
+		func = ftrace_ops_list_func;
 
-		/*
-		 * For one func, simply call it directly.
-		 * For more than one func, call the chain.
-		 */
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-		ftrace_trace_function = func;
+	ftrace_trace_function = func;
 #else
-		__ftrace_trace_function = func;
-		ftrace_trace_function = ftrace_test_stop_func;
+	__ftrace_trace_function = func;
+	ftrace_trace_function = ftrace_test_stop_func;
 #endif
-	}
+}
 
-	return 0;
+static void add_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
+{
+	ops->next = *list;
+	/*
+	 * We are entering ops into the list but another
+	 * CPU might be walking that list. We need to make sure
+	 * the ops->next pointer is valid before another CPU sees
+	 * the ops pointer included into the list.
+	 */
+	rcu_assign_pointer(*list, ops);
 }
 
-static int __unregister_ftrace_function(struct ftrace_ops *ops)
+static int remove_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 {
 	struct ftrace_ops **p;
 
@@ -194,13 +229,12 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	 * If we are removing the last function, then simply point
 	 * to the ftrace_stub.
 	 */
-	if (ftrace_list == ops && ops->next == &ftrace_list_end) {
-		ftrace_trace_function = ftrace_stub;
-		ftrace_list = &ftrace_list_end;
+	if (*list == ops && ops->next == &ftrace_list_end) {
+		*list = &ftrace_list_end;
 		return 0;
 	}
 
-	for (p = &ftrace_list; *p != &ftrace_list_end; p = &(*p)->next)
+	for (p = list; *p != &ftrace_list_end; p = &(*p)->next)
 		if (*p == ops)
 			break;
 
@@ -208,53 +242,83 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 		return -1;
 
 	*p = (*p)->next;
+	return 0;
+}
 
-	if (ftrace_enabled) {
-		/* If we only have one func left, then call that directly */
-		if (ftrace_list->next == &ftrace_list_end) {
-			ftrace_func_t func = ftrace_list->func;
+static int __register_ftrace_function(struct ftrace_ops *ops)
+{
+	if (ftrace_disabled)
+		return -ENODEV;
 
-			if (!list_empty(&ftrace_pids)) {
-				set_ftrace_pid_function(func);
-				func = ftrace_pid_func;
-			}
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-			ftrace_trace_function = func;
-#else
-			__ftrace_trace_function = func;
-#endif
-		}
-	}
+	if (FTRACE_WARN_ON(ops == &global_ops))
+		return -EINVAL;
+
+	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return -EBUSY;
+
+	if (!core_kernel_data((unsigned long)ops))
+		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
+
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
+		int first = ftrace_global_list == &ftrace_list_end;
+		add_ftrace_ops(&ftrace_global_list, ops);
+		ops->flags |= FTRACE_OPS_FL_ENABLED;
+		if (first)
+			add_ftrace_ops(&ftrace_ops_list, &global_ops);
+	} else
+		add_ftrace_ops(&ftrace_ops_list, ops);
+
+	if (ftrace_enabled)
+		update_ftrace_function();
 
 	return 0;
 }
 
-static void ftrace_update_pid_func(void)
+static int __unregister_ftrace_function(struct ftrace_ops *ops)
 {
-	ftrace_func_t func;
+	int ret;
 
-	if (ftrace_trace_function == ftrace_stub)
-		return;
+	if (ftrace_disabled)
+		return -ENODEV;
 
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	func = ftrace_trace_function;
-#else
-	func = __ftrace_trace_function;
-#endif
+	if (WARN_ON(!(ops->flags & FTRACE_OPS_FL_ENABLED)))
+		return -EBUSY;
 
-	if (!list_empty(&ftrace_pids)) {
-		set_ftrace_pid_function(func);
-		func = ftrace_pid_func;
-	} else {
-		if (func == ftrace_pid_func)
-			func = ftrace_pid_function;
-	}
+	if (FTRACE_WARN_ON(ops == &global_ops))
+		return -EINVAL;
 
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	ftrace_trace_function = func;
-#else
-	__ftrace_trace_function = func;
-#endif
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
+		ret = remove_ftrace_ops(&ftrace_global_list, ops);
+		if (!ret && ftrace_global_list == &ftrace_list_end)
+			ret = remove_ftrace_ops(&ftrace_ops_list, &global_ops);
+		if (!ret)
+			ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+	} else
+		ret = remove_ftrace_ops(&ftrace_ops_list, ops);
+
+	if (ret < 0)
+		return ret;
+
+	if (ftrace_enabled)
+		update_ftrace_function();
+
+	/*
+	 * Dynamic ops may be freed, we must make sure that all
+	 * callers are done before leaving this function.
+	 */
+	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
+		synchronize_sched();
+
+	return 0;
+}
+
+static void ftrace_update_pid_func(void)
+{
+	/* Only do something if we are tracing something */
+	if (ftrace_trace_function == ftrace_stub)
+		return;
+
+	update_ftrace_function();
 }
 
 #ifdef CONFIG_FUNCTION_PROFILER
@@ -888,8 +952,35 @@ enum {
 	FTRACE_START_FUNC_RET		= (1 << 3),
 	FTRACE_STOP_FUNC_RET		= (1 << 4),
 };
+struct ftrace_func_entry {
+	struct hlist_node hlist;
+	unsigned long ip;
+};
+
+struct ftrace_hash {
+	unsigned long		size_bits;
+	struct hlist_head	*buckets;
+	unsigned long		count;
+	struct rcu_head		rcu;
+};
+
+/*
+ * We make these constant because no one should touch them,
+ * but they are used as the default "empty hash", to avoid allocating
+ * it all the time. These are in a read only section such that if
+ * anyone does try to modify it, it will cause an exception.
+ */
+static const struct hlist_head empty_buckets[1];
+static const struct ftrace_hash empty_hash = {
+	.buckets = (struct hlist_head *)empty_buckets,
+};
+#define EMPTY_HASH	((struct ftrace_hash *)&empty_hash)
 
-static int ftrace_filtered;
+static struct ftrace_ops global_ops = {
+	.func			= ftrace_stub,
+	.notrace_hash		= EMPTY_HASH,
+	.filter_hash		= EMPTY_HASH,
+};
 
 static struct dyn_ftrace *ftrace_new_addrs;
 
@@ -912,6 +1003,269 @@ static struct ftrace_page	*ftrace_pages;
 
 static struct dyn_ftrace *ftrace_free_records;
 
+static struct ftrace_func_entry *
+ftrace_lookup_ip(struct ftrace_hash *hash, unsigned long ip)
+{
+	unsigned long key;
+	struct ftrace_func_entry *entry;
+	struct hlist_head *hhd;
+	struct hlist_node *n;
+
+	if (!hash->count)
+		return NULL;
+
+	if (hash->size_bits > 0)
+		key = hash_long(ip, hash->size_bits);
+	else
+		key = 0;
+
+	hhd = &hash->buckets[key];
+
+	hlist_for_each_entry_rcu(entry, n, hhd, hlist) {
+		if (entry->ip == ip)
+			return entry;
+	}
+	return NULL;
+}
+
+static void __add_hash_entry(struct ftrace_hash *hash,
+			     struct ftrace_func_entry *entry)
+{
+	struct hlist_head *hhd;
+	unsigned long key;
+
+	if (hash->size_bits)
+		key = hash_long(entry->ip, hash->size_bits);
+	else
+		key = 0;
+
+	hhd = &hash->buckets[key];
+	hlist_add_head(&entry->hlist, hhd);
+	hash->count++;
+}
+
+static int add_hash_entry(struct ftrace_hash *hash, unsigned long ip)
+{
+	struct ftrace_func_entry *entry;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->ip = ip;
+	__add_hash_entry(hash, entry);
+
+	return 0;
+}
+
+static void
+free_hash_entry(struct ftrace_hash *hash,
+		  struct ftrace_func_entry *entry)
+{
+	hlist_del(&entry->hlist);
+	kfree(entry);
+	hash->count--;
+}
+
+static void
+remove_hash_entry(struct ftrace_hash *hash,
+		  struct ftrace_func_entry *entry)
+{
+	hlist_del(&entry->hlist);
+	hash->count--;
+}
+
+static void ftrace_hash_clear(struct ftrace_hash *hash)
+{
+	struct hlist_head *hhd;
+	struct hlist_node *tp, *tn;
+	struct ftrace_func_entry *entry;
+	int size = 1 << hash->size_bits;
+	int i;
+
+	if (!hash->count)
+		return;
+
+	for (i = 0; i < size; i++) {
+		hhd = &hash->buckets[i];
+		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist)
+			free_hash_entry(hash, entry);
+	}
+	FTRACE_WARN_ON(hash->count);
+}
+
+static void free_ftrace_hash(struct ftrace_hash *hash)
+{
+	if (!hash || hash == EMPTY_HASH)
+		return;
+	ftrace_hash_clear(hash);
+	kfree(hash->buckets);
+	kfree(hash);
+}
+
+static void __free_ftrace_hash_rcu(struct rcu_head *rcu)
+{
+	struct ftrace_hash *hash;
+
+	hash = container_of(rcu, struct ftrace_hash, rcu);
+	free_ftrace_hash(hash);
+}
+
+static void free_ftrace_hash_rcu(struct ftrace_hash *hash)
+{
+	if (!hash || hash == EMPTY_HASH)
+		return;
+	call_rcu_sched(&hash->rcu, __free_ftrace_hash_rcu);
+}
+
+static struct ftrace_hash *alloc_ftrace_hash(int size_bits)
+{
+	struct ftrace_hash *hash;
+	int size;
+
+	hash = kzalloc(sizeof(*hash), GFP_KERNEL);
+	if (!hash)
+		return NULL;
+
+	size = 1 << size_bits;
+	hash->buckets = kzalloc(sizeof(*hash->buckets) * size, GFP_KERNEL);
+
+	if (!hash->buckets) {
+		kfree(hash);
+		return NULL;
+	}
+
+	hash->size_bits = size_bits;
+
+	return hash;
+}
+
+static struct ftrace_hash *
+alloc_and_copy_ftrace_hash(int size_bits, struct ftrace_hash *hash)
+{
+	struct ftrace_func_entry *entry;
+	struct ftrace_hash *new_hash;
+	struct hlist_node *tp;
+	int size;
+	int ret;
+	int i;
+
+	new_hash = alloc_ftrace_hash(size_bits);
+	if (!new_hash)
+		return NULL;
+
+	/* Empty hash? */
+	if (!hash || !hash->count)
+		return new_hash;
+
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, tp, &hash->buckets[i], hlist) {
+			ret = add_hash_entry(new_hash, entry->ip);
+			if (ret < 0)
+				goto free_hash;
+		}
+	}
+
+	FTRACE_WARN_ON(new_hash->count != hash->count);
+
+	return new_hash;
+
+ free_hash:
+	free_ftrace_hash(new_hash);
+	return NULL;
+}
+
+static int
+ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
+{
+	struct ftrace_func_entry *entry;
+	struct hlist_node *tp, *tn;
+	struct hlist_head *hhd;
+	struct ftrace_hash *old_hash;
+	struct ftrace_hash *new_hash;
+	unsigned long key;
+	int size = src->count;
+	int bits = 0;
+	int i;
+
+	/*
+	 * If the new source is empty, just free dst and assign it
+	 * the empty_hash.
+	 */
+	if (!src->count) {
+		free_ftrace_hash_rcu(*dst);
+		rcu_assign_pointer(*dst, EMPTY_HASH);
+		return 0;
+	}
+
+	/*
+	 * Make the hash size about 1/2 the # found
+	 */
+	for (size /= 2; size; size >>= 1)
+		bits++;
+
+	/* Don't allocate too much */
+	if (bits > FTRACE_HASH_MAX_BITS)
+		bits = FTRACE_HASH_MAX_BITS;
+
+	new_hash = alloc_ftrace_hash(bits);
+	if (!new_hash)
+		return -ENOMEM;
+
+	size = 1 << src->size_bits;
+	for (i = 0; i < size; i++) {
+		hhd = &src->buckets[i];
+		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist) {
+			if (bits > 0)
+				key = hash_long(entry->ip, bits);
+			else
+				key = 0;
+			remove_hash_entry(src, entry);
+			__add_hash_entry(new_hash, entry);
+		}
+	}
+
+	old_hash = *dst;
+	rcu_assign_pointer(*dst, new_hash);
+	free_ftrace_hash_rcu(old_hash);
+
+	return 0;
+}
+
+/*
+ * Test the hashes for this ops to see if we want to call
+ * the ops->func or not.
+ *
+ * It's a match if the ip is in the ops->filter_hash or
+ * the filter_hash does not exist or is empty,
+ *  AND
+ * the ip is not in the ops->notrace_hash.
+ *
+ * This needs to be called with preemption disabled as
+ * the hashes are freed with call_rcu_sched().
+ */
+static int
+ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
+{
+	struct ftrace_hash *filter_hash;
+	struct ftrace_hash *notrace_hash;
+	int ret;
+
+	filter_hash = rcu_dereference_raw(ops->filter_hash);
+	notrace_hash = rcu_dereference_raw(ops->notrace_hash);
+
+	if ((!filter_hash || !filter_hash->count ||
+	     ftrace_lookup_ip(filter_hash, ip)) &&
+	    (!notrace_hash || !notrace_hash->count ||
+	     !ftrace_lookup_ip(notrace_hash, ip)))
+		ret = 1;
+	else
+		ret = 0;
+
+	return ret;
+}
+
 /*
  * This is a double for. Do not use 'break' to break out of the loop,
  * you must use a goto.
@@ -926,6 +1280,105 @@ static struct dyn_ftrace *ftrace_free_records;
 		}				\
 	}
 
+static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
+				     int filter_hash,
+				     bool inc)
+{
+	struct ftrace_hash *hash;
+	struct ftrace_hash *other_hash;
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+	int count = 0;
+	int all = 0;
+
+	/* Only update if the ops has been registered */
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return;
+
+	/*
+	 * In the filter_hash case:
+	 *   If the count is zero, we update all records.
+	 *   Otherwise we just update the items in the hash.
+	 *
+	 * In the notrace_hash case:
+	 *   We enable the update in the hash.
+	 *   As disabling notrace means enabling the tracing,
+	 *   and enabling notrace means disabling, the inc variable
+	 *   gets inversed.
+	 */
+	if (filter_hash) {
+		hash = ops->filter_hash;
+		other_hash = ops->notrace_hash;
+		if (!hash || !hash->count)
+			all = 1;
+	} else {
+		inc = !inc;
+		hash = ops->notrace_hash;
+		other_hash = ops->filter_hash;
+		/*
+		 * If the notrace hash has no items,
+		 * then there's nothing to do.
+		 */
+		if (hash && !hash->count)
+			return;
+	}
+
+	do_for_each_ftrace_rec(pg, rec) {
+		int in_other_hash = 0;
+		int in_hash = 0;
+		int match = 0;
+
+		if (all) {
+			/*
+			 * Only the filter_hash affects all records.
+			 * Update if the record is not in the notrace hash.
+			 */
+			if (!other_hash || !ftrace_lookup_ip(other_hash, rec->ip))
+				match = 1;
+		} else {
+			in_hash = hash && !!ftrace_lookup_ip(hash, rec->ip);
+			in_other_hash = other_hash && !!ftrace_lookup_ip(other_hash, rec->ip);
+
+			/*
+			 *
+			 */
+			if (filter_hash && in_hash && !in_other_hash)
+				match = 1;
+			else if (!filter_hash && in_hash &&
+				 (in_other_hash || !other_hash->count))
+				match = 1;
+		}
+		if (!match)
+			continue;
+
+		if (inc) {
+			rec->flags++;
+			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == FTRACE_REF_MAX))
+				return;
+		} else {
+			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
+				return;
+			rec->flags--;
+		}
+		count++;
+		/* Shortcut, if we handled all records, we are done. */
+		if (!all && count == hash->count)
+			return;
+	} while_for_each_ftrace_rec();
+}
+
+static void ftrace_hash_rec_disable(struct ftrace_ops *ops,
+				    int filter_hash)
+{
+	__ftrace_hash_rec_update(ops, filter_hash, 0);
+}
+
+static void ftrace_hash_rec_enable(struct ftrace_ops *ops,
+				   int filter_hash)
+{
+	__ftrace_hash_rec_update(ops, filter_hash, 1);
+}
+
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
 	rec->freelist = ftrace_free_records;
@@ -1047,18 +1500,18 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	ftrace_addr = (unsigned long)FTRACE_ADDR;
 
 	/*
-	 * If this record is not to be traced or we want to disable it,
-	 * then disable it.
+	 * If we are enabling tracing:
+	 *
+	 *   If the record has a ref count, then we need to enable it
+	 *   because someone is using it.
 	 *
-	 * If we want to enable it and filtering is off, then enable it.
+	 *   Otherwise we make sure its disabled.
 	 *
-	 * If we want to enable it and filtering is on, enable it only if
-	 * it's filtered
+	 * If we are disabling tracing, then disable all records that
+	 * are enabled.
 	 */
-	if (enable && !(rec->flags & FTRACE_FL_NOTRACE)) {
-		if (!ftrace_filtered || (rec->flags & FTRACE_FL_FILTER))
-			flag = FTRACE_FL_ENABLED;
-	}
+	if (enable && (rec->flags & ~FTRACE_FL_MASK))
+		flag = FTRACE_FL_ENABLED;
 
 	/* If the state of this record hasn't changed, then do nothing */
 	if ((rec->flags & FTRACE_FL_ENABLED) == flag)
@@ -1079,19 +1532,16 @@ static void ftrace_replace_code(int enable)
 	struct ftrace_page *pg;
 	int failed;
 
+	if (unlikely(ftrace_disabled))
+		return;
+
 	do_for_each_ftrace_rec(pg, rec) {
-		/*
-		 * Skip over free records, records that have
-		 * failed and not converted.
-		 */
-		if (rec->flags & FTRACE_FL_FREE ||
-		    rec->flags & FTRACE_FL_FAILED ||
-		    !(rec->flags & FTRACE_FL_CONVERTED))
+		/* Skip over free records */
+		if (rec->flags & FTRACE_FL_FREE)
 			continue;
 
 		failed = __ftrace_replace_code(rec, enable);
 		if (failed) {
-			rec->flags |= FTRACE_FL_FAILED;
 			ftrace_bug(failed, rec->ip);
 			/* Stop processing */
 			return;
@@ -1107,10 +1557,12 @@ ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
 
 	ip = rec->ip;
 
+	if (unlikely(ftrace_disabled))
+		return 0;
+
 	ret = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
 	if (ret) {
 		ftrace_bug(ret, ip);
-		rec->flags |= FTRACE_FL_FAILED;
 		return 0;
 	}
 	return 1;
@@ -1171,6 +1623,7 @@ static void ftrace_run_update_code(int command)
 
 static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
+static int global_start_up;
 
 static void ftrace_startup_enable(int command)
 {
@@ -1185,19 +1638,36 @@ static void ftrace_startup_enable(int command)
 	ftrace_run_update_code(command);
 }
 
-static void ftrace_startup(int command)
+static void ftrace_startup(struct ftrace_ops *ops, int command)
 {
+	bool hash_enable = true;
+
 	if (unlikely(ftrace_disabled))
 		return;
 
 	ftrace_start_up++;
 	command |= FTRACE_ENABLE_CALLS;
 
+	/* ops marked global share the filter hashes */
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
+		ops = &global_ops;
+		/* Don't update hash if global is already set */
+		if (global_start_up)
+			hash_enable = false;
+		global_start_up++;
+	}
+
+	ops->flags |= FTRACE_OPS_FL_ENABLED;
+	if (hash_enable)
+		ftrace_hash_rec_enable(ops, 1);
+
 	ftrace_startup_enable(command);
 }
 
-static void ftrace_shutdown(int command)
+static void ftrace_shutdown(struct ftrace_ops *ops, int command)
 {
+	bool hash_disable = true;
+
 	if (unlikely(ftrace_disabled))
 		return;
 
@@ -1209,6 +1679,23 @@ static void ftrace_shutdown(int command)
 	 */
 	WARN_ON_ONCE(ftrace_start_up < 0);
 
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
+		ops = &global_ops;
+		global_start_up--;
+		WARN_ON_ONCE(global_start_up < 0);
+		/* Don't update hash if global still has users */
+		if (global_start_up) {
+			WARN_ON_ONCE(!ftrace_start_up);
+			hash_disable = false;
+		}
+	}
+
+	if (hash_disable)
+		ftrace_hash_rec_disable(ops, 1);
+
+	if (ops != &global_ops || !global_start_up)
+		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+
 	if (!ftrace_start_up)
 		command |= FTRACE_DISABLE_CALLS;
 
@@ -1273,10 +1760,10 @@ static int ftrace_update_code(struct module *mod)
 		 */
 		if (!ftrace_code_disable(mod, p)) {
 			ftrace_free_rec(p);
-			continue;
+			/* Game over */
+			break;
 		}
 
-		p->flags |= FTRACE_FL_CONVERTED;
 		ftrace_update_cnt++;
 
 		/*
@@ -1351,9 +1838,9 @@ static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 enum {
 	FTRACE_ITER_FILTER	= (1 << 0),
 	FTRACE_ITER_NOTRACE	= (1 << 1),
-	FTRACE_ITER_FAILURES	= (1 << 2),
-	FTRACE_ITER_PRINTALL	= (1 << 3),
-	FTRACE_ITER_HASH	= (1 << 4),
+	FTRACE_ITER_PRINTALL	= (1 << 2),
+	FTRACE_ITER_HASH	= (1 << 3),
+	FTRACE_ITER_ENABLED	= (1 << 4),
 };
 
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
@@ -1365,6 +1852,8 @@ struct ftrace_iterator {
 	struct dyn_ftrace		*func;
 	struct ftrace_func_probe	*probe;
 	struct trace_parser		parser;
+	struct ftrace_hash		*hash;
+	struct ftrace_ops		*ops;
 	int				hidx;
 	int				idx;
 	unsigned			flags;
@@ -1461,8 +1950,12 @@ static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
+	struct ftrace_ops *ops = &global_ops;
 	struct dyn_ftrace *rec = NULL;
 
+	if (unlikely(ftrace_disabled))
+		return NULL;
+
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_next(m, pos);
 
@@ -1483,17 +1976,15 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		rec = &iter->pg->records[iter->idx++];
 		if ((rec->flags & FTRACE_FL_FREE) ||
 
-		    (!(iter->flags & FTRACE_ITER_FAILURES) &&
-		     (rec->flags & FTRACE_FL_FAILED)) ||
-
-		    ((iter->flags & FTRACE_ITER_FAILURES) &&
-		     !(rec->flags & FTRACE_FL_FAILED)) ||
-
 		    ((iter->flags & FTRACE_ITER_FILTER) &&
-		     !(rec->flags & FTRACE_FL_FILTER)) ||
+		     !(ftrace_lookup_ip(ops->filter_hash, rec->ip))) ||
 
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
-		     !(rec->flags & FTRACE_FL_NOTRACE))) {
+		     !ftrace_lookup_ip(ops->notrace_hash, rec->ip)) ||
+
+		    ((iter->flags & FTRACE_ITER_ENABLED) &&
+		     !(rec->flags & ~FTRACE_FL_MASK))) {
+
 			rec = NULL;
 			goto retry;
 		}
@@ -1517,10 +2008,15 @@ static void reset_iter_read(struct ftrace_iterator *iter)
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
+	struct ftrace_ops *ops = &global_ops;
 	void *p = NULL;
 	loff_t l;
 
 	mutex_lock(&ftrace_lock);
+
+	if (unlikely(ftrace_disabled))
+		return NULL;
+
 	/*
 	 * If an lseek was done, then reset and start from beginning.
 	 */
@@ -1532,7 +2028,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	 * off, we can short cut and just print out that all
 	 * functions are enabled.
 	 */
-	if (iter->flags & FTRACE_ITER_FILTER && !ftrace_filtered) {
+	if (iter->flags & FTRACE_ITER_FILTER && !ops->filter_hash->count) {
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
@@ -1590,7 +2086,11 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	seq_printf(m, "%ps\n", (void *)rec->ip);
+	seq_printf(m, "%ps", (void *)rec->ip);
+	if (iter->flags & FTRACE_ITER_ENABLED)
+		seq_printf(m, " (%ld)",
+			   rec->flags & ~FTRACE_FL_MASK);
+	seq_printf(m, "\n");
 
 	return 0;
 }
@@ -1603,7 +2103,34 @@ static const struct seq_operations show_ftrace_seq_ops = {
 };
 
 static int
-ftrace_avail_open(struct inode *inode, struct file *file)
+ftrace_avail_open(struct inode *inode, struct file *file)
+{
+	struct ftrace_iterator *iter;
+	int ret;
+
+	if (unlikely(ftrace_disabled))
+		return -ENODEV;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	iter->pg = ftrace_pages_start;
+
+	ret = seq_open(file, &show_ftrace_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+
+		m->private = iter;
+	} else {
+		kfree(iter);
+	}
+
+	return ret;
+}
+
+static int
+ftrace_enabled_open(struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
 	int ret;
@@ -1616,6 +2143,7 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	iter->pg = ftrace_pages_start;
+	iter->flags = FTRACE_ITER_ENABLED;
 
 	ret = seq_open(file, &show_ftrace_seq_ops);
 	if (!ret) {
@@ -1629,45 +2157,19 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static int
-ftrace_failures_open(struct inode *inode, struct file *file)
-{
-	int ret;
-	struct seq_file *m;
-	struct ftrace_iterator *iter;
-
-	ret = ftrace_avail_open(inode, file);
-	if (!ret) {
-		m = file->private_data;
-		iter = m->private;
-		iter->flags = FTRACE_ITER_FAILURES;
-	}
-
-	return ret;
-}
-
-
-static void ftrace_filter_reset(int enable)
+static void ftrace_filter_reset(struct ftrace_hash *hash)
 {
-	struct ftrace_page *pg;
-	struct dyn_ftrace *rec;
-	unsigned long type = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-
 	mutex_lock(&ftrace_lock);
-	if (enable)
-		ftrace_filtered = 0;
-	do_for_each_ftrace_rec(pg, rec) {
-		if (rec->flags & FTRACE_FL_FAILED)
-			continue;
-		rec->flags &= ~type;
-	} while_for_each_ftrace_rec();
+	ftrace_hash_clear(hash);
 	mutex_unlock(&ftrace_lock);
 }
 
 static int
-ftrace_regex_open(struct inode *inode, struct file *file, int enable)
+ftrace_regex_open(struct ftrace_ops *ops, int flag,
+		  struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
+	struct ftrace_hash *hash;
 	int ret = 0;
 
 	if (unlikely(ftrace_disabled))
@@ -1682,21 +2184,42 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 		return -ENOMEM;
 	}
 
+	if (flag & FTRACE_ITER_NOTRACE)
+		hash = ops->notrace_hash;
+	else
+		hash = ops->filter_hash;
+
+	iter->ops = ops;
+	iter->flags = flag;
+
+	if (file->f_mode & FMODE_WRITE) {
+		mutex_lock(&ftrace_lock);
+		iter->hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, hash);
+		mutex_unlock(&ftrace_lock);
+
+		if (!iter->hash) {
+			trace_parser_put(&iter->parser);
+			kfree(iter);
+			return -ENOMEM;
+		}
+	}
+
 	mutex_lock(&ftrace_regex_lock);
+
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
-		ftrace_filter_reset(enable);
+		ftrace_filter_reset(iter->hash);
 
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
-		iter->flags = enable ? FTRACE_ITER_FILTER :
-			FTRACE_ITER_NOTRACE;
 
 		ret = seq_open(file, &show_ftrace_seq_ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = iter;
 		} else {
+			/* Failed */
+			free_ftrace_hash(iter->hash);
 			trace_parser_put(&iter->parser);
 			kfree(iter);
 		}
@@ -1710,13 +2233,15 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 static int
 ftrace_filter_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(inode, file, 1);
+	return ftrace_regex_open(&global_ops, FTRACE_ITER_FILTER,
+				 inode, file);
 }
 
 static int
 ftrace_notrace_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(inode, file, 0);
+	return ftrace_regex_open(&global_ops, FTRACE_ITER_NOTRACE,
+				 inode, file);
 }
 
 static loff_t
@@ -1761,86 +2286,99 @@ static int ftrace_match(char *str, char *regex, int len, int type)
 }
 
 static int
-ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
+enter_record(struct ftrace_hash *hash, struct dyn_ftrace *rec, int not)
+{
+	struct ftrace_func_entry *entry;
+	int ret = 0;
+
+	entry = ftrace_lookup_ip(hash, rec->ip);
+	if (not) {
+		/* Do nothing if it doesn't exist */
+		if (!entry)
+			return 0;
+
+		free_hash_entry(hash, entry);
+	} else {
+		/* Do nothing if it exists */
+		if (entry)
+			return 0;
+
+		ret = add_hash_entry(hash, rec->ip);
+	}
+	return ret;
+}
+
+static int
+ftrace_match_record(struct dyn_ftrace *rec, char *mod,
+		    char *regex, int len, int type)
 {
 	char str[KSYM_SYMBOL_LEN];
+	char *modname;
+
+	kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
+
+	if (mod) {
+		/* module lookup requires matching the module */
+		if (!modname || strcmp(modname, mod))
+			return 0;
+
+		/* blank search means to match all funcs in the mod */
+		if (!len)
+			return 1;
+	}
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 	return ftrace_match(str, regex, len, type);
 }
 
-static int ftrace_match_records(char *buff, int len, int enable)
+static int
+match_records(struct ftrace_hash *hash, char *buff,
+	      int len, char *mod, int not)
 {
-	unsigned int search_len;
+	unsigned search_len = 0;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
-	unsigned long flag;
-	char *search;
-	int type;
-	int not;
+	int type = MATCH_FULL;
+	char *search = buff;
 	int found = 0;
+	int ret;
 
-	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-	type = filter_parse_regex(buff, len, &search, &not);
-
-	search_len = strlen(search);
+	if (len) {
+		type = filter_parse_regex(buff, len, &search, &not);
+		search_len = strlen(search);
+	}
 
 	mutex_lock(&ftrace_lock);
-	do_for_each_ftrace_rec(pg, rec) {
 
-		if (rec->flags & FTRACE_FL_FAILED)
-			continue;
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
 
-		if (ftrace_match_record(rec, search, search_len, type)) {
-			if (not)
-				rec->flags &= ~flag;
-			else
-				rec->flags |= flag;
+	do_for_each_ftrace_rec(pg, rec) {
+
+		if (ftrace_match_record(rec, mod, search, search_len, type)) {
+			ret = enter_record(hash, rec, not);
+			if (ret < 0) {
+				found = ret;
+				goto out_unlock;
+			}
 			found = 1;
 		}
-		/*
-		 * Only enable filtering if we have a function that
-		 * is filtered on.
-		 */
-		if (enable && (rec->flags & FTRACE_FL_FILTER))
-			ftrace_filtered = 1;
 	} while_for_each_ftrace_rec();
+ out_unlock:
 	mutex_unlock(&ftrace_lock);
 
 	return found;
 }
 
 static int
-ftrace_match_module_record(struct dyn_ftrace *rec, char *mod,
-			   char *regex, int len, int type)
+ftrace_match_records(struct ftrace_hash *hash, char *buff, int len)
 {
-	char str[KSYM_SYMBOL_LEN];
-	char *modname;
-
-	kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
-
-	if (!modname || strcmp(modname, mod))
-		return 0;
-
-	/* blank search means to match all funcs in the mod */
-	if (len)
-		return ftrace_match(str, regex, len, type);
-	else
-		return 1;
+	return match_records(hash, buff, len, NULL, 0);
 }
 
-static int ftrace_match_module_records(char *buff, char *mod, int enable)
+static int
+ftrace_match_module_records(struct ftrace_hash *hash, char *buff, char *mod)
 {
-	unsigned search_len = 0;
-	struct ftrace_page *pg;
-	struct dyn_ftrace *rec;
-	int type = MATCH_FULL;
-	char *search = buff;
-	unsigned long flag;
 	int not = 0;
-	int found = 0;
-
-	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
 	/* blank or '*' mean the same */
 	if (strcmp(buff, "*") == 0)
@@ -1852,32 +2390,7 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 		not = 1;
 	}
 
-	if (strlen(buff)) {
-		type = filter_parse_regex(buff, strlen(buff), &search, &not);
-		search_len = strlen(search);
-	}
-
-	mutex_lock(&ftrace_lock);
-	do_for_each_ftrace_rec(pg, rec) {
-
-		if (rec->flags & FTRACE_FL_FAILED)
-			continue;
-
-		if (ftrace_match_module_record(rec, mod,
-					       search, search_len, type)) {
-			if (not)
-				rec->flags &= ~flag;
-			else
-				rec->flags |= flag;
-			found = 1;
-		}
-		if (enable && (rec->flags & FTRACE_FL_FILTER))
-			ftrace_filtered = 1;
-
-	} while_for_each_ftrace_rec();
-	mutex_unlock(&ftrace_lock);
-
-	return found;
+	return match_records(hash, buff, strlen(buff), mod, not);
 }
 
 /*
@@ -1888,7 +2401,10 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 static int
 ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 {
+	struct ftrace_ops *ops = &global_ops;
+	struct ftrace_hash *hash;
 	char *mod;
+	int ret = -EINVAL;
 
 	/*
 	 * cmd == 'mod' because we only registered this func
@@ -1900,15 +2416,24 @@ ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 
 	/* we must have a module name */
 	if (!param)
-		return -EINVAL;
+		return ret;
 
 	mod = strsep(&param, ":");
 	if (!strlen(mod))
-		return -EINVAL;
+		return ret;
 
-	if (ftrace_match_module_records(func, mod, enable))
-		return 0;
-	return -EINVAL;
+	if (enable)
+		hash = ops->filter_hash;
+	else
+		hash = ops->notrace_hash;
+
+	ret = ftrace_match_module_records(hash, func, mod);
+	if (!ret)
+		ret = -EINVAL;
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static struct ftrace_func_command ftrace_mod_cmd = {
@@ -1959,6 +2484,7 @@ static int ftrace_probe_registered;
 
 static void __enable_ftrace_function_probe(void)
 {
+	int ret;
 	int i;
 
 	if (ftrace_probe_registered)
@@ -1973,13 +2499,16 @@ static void __enable_ftrace_function_probe(void)
 	if (i == FTRACE_FUNC_HASHSIZE)
 		return;
 
-	__register_ftrace_function(&trace_probe_ops);
-	ftrace_startup(0);
+	ret = __register_ftrace_function(&trace_probe_ops);
+	if (!ret)
+		ftrace_startup(&trace_probe_ops, 0);
+
 	ftrace_probe_registered = 1;
 }
 
 static void __disable_ftrace_function_probe(void)
 {
+	int ret;
 	int i;
 
 	if (!ftrace_probe_registered)
@@ -1992,8 +2521,10 @@ static void __disable_ftrace_function_probe(void)
 	}
 
 	/* no more funcs left */
-	__unregister_ftrace_function(&trace_probe_ops);
-	ftrace_shutdown(0);
+	ret = __unregister_ftrace_function(&trace_probe_ops);
+	if (!ret)
+		ftrace_shutdown(&trace_probe_ops, 0);
+
 	ftrace_probe_registered = 0;
 }
 
@@ -2029,12 +2560,13 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 		return -EINVAL;
 
 	mutex_lock(&ftrace_lock);
-	do_for_each_ftrace_rec(pg, rec) {
 
-		if (rec->flags & FTRACE_FL_FAILED)
-			continue;
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
+	do_for_each_ftrace_rec(pg, rec) {
 
-		if (!ftrace_match_record(rec, search, len, type))
+		if (!ftrace_match_record(rec, NULL, search, len, type))
 			continue;
 
 		entry = kmalloc(sizeof(*entry), GFP_KERNEL);
@@ -2195,18 +2727,22 @@ int unregister_ftrace_command(struct ftrace_func_command *cmd)
 	return ret;
 }
 
-static int ftrace_process_regex(char *buff, int len, int enable)
+static int ftrace_process_regex(struct ftrace_hash *hash,
+				char *buff, int len, int enable)
 {
 	char *func, *command, *next = buff;
 	struct ftrace_func_command *p;
-	int ret = -EINVAL;
+	int ret;
 
 	func = strsep(&next, ":");
 
 	if (!next) {
-		if (ftrace_match_records(func, len, enable))
-			return 0;
-		return ret;
+		ret = ftrace_match_records(hash, func, len);
+		if (!ret)
+			ret = -EINVAL;
+		if (ret < 0)
+			return ret;
+		return 0;
 	}
 
 	/* command found */
@@ -2239,6 +2775,10 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 
 	mutex_lock(&ftrace_regex_lock);
 
+	ret = -ENODEV;
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
 	if (file->f_mode & FMODE_READ) {
 		struct seq_file *m = file->private_data;
 		iter = m->private;
@@ -2250,7 +2790,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 
 	if (read >= 0 && trace_parser_loaded(parser) &&
 	    !trace_parser_cont(parser)) {
-		ret = ftrace_process_regex(parser->buffer,
+		ret = ftrace_process_regex(iter->hash, parser->buffer,
 					   parser->idx, enable);
 		trace_parser_clear(parser);
 		if (ret)
@@ -2278,22 +2818,83 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
 	return ftrace_regex_write(file, ubuf, cnt, ppos, 0);
 }
 
-static void
-ftrace_set_regex(unsigned char *buf, int len, int reset, int enable)
+static int
+ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
+		 int reset, int enable)
 {
+	struct ftrace_hash **orig_hash;
+	struct ftrace_hash *hash;
+	int ret;
+
+	/* All global ops uses the global ops filters */
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL)
+		ops = &global_ops;
+
 	if (unlikely(ftrace_disabled))
-		return;
+		return -ENODEV;
+
+	if (enable)
+		orig_hash = &ops->filter_hash;
+	else
+		orig_hash = &ops->notrace_hash;
+
+	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	if (!hash)
+		return -ENOMEM;
 
 	mutex_lock(&ftrace_regex_lock);
 	if (reset)
-		ftrace_filter_reset(enable);
+		ftrace_filter_reset(hash);
 	if (buf)
-		ftrace_match_records(buf, len, enable);
+		ftrace_match_records(hash, buf, len);
+
+	mutex_lock(&ftrace_lock);
+	ret = ftrace_hash_move(orig_hash, hash);
+	mutex_unlock(&ftrace_lock);
+
 	mutex_unlock(&ftrace_regex_lock);
+
+	free_ftrace_hash(hash);
+	return ret;
+}
+
+/**
+ * ftrace_set_filter - set a function to filter on in ftrace
+ * @ops - the ops to set the filter with
+ * @buf - the string that holds the function filter text.
+ * @len - the length of the string.
+ * @reset - non zero to reset all filters before applying this filter.
+ *
+ * Filters denote which functions should be enabled when tracing is enabled.
+ * If @buf is NULL and reset is set, all functions will be enabled for tracing.
+ */
+void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+		       int len, int reset)
+{
+	ftrace_set_regex(ops, buf, len, reset, 1);
 }
+EXPORT_SYMBOL_GPL(ftrace_set_filter);
 
 /**
+ * ftrace_set_notrace - set a function to not trace in ftrace
+ * @ops - the ops to set the notrace filter with
+ * @buf - the string that holds the function notrace text.
+ * @len - the length of the string.
+ * @reset - non zero to reset all filters before applying this filter.
+ *
+ * Notrace Filters denote which functions should not be enabled when tracing
+ * is enabled. If @buf is NULL and reset is set, all functions will be enabled
+ * for tracing.
+ */
+void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+			int len, int reset)
+{
+	ftrace_set_regex(ops, buf, len, reset, 0);
+}
+EXPORT_SYMBOL_GPL(ftrace_set_notrace);
+/**
  * ftrace_set_filter - set a function to filter on in ftrace
+ * @ops - the ops to set the filter with
  * @buf - the string that holds the function filter text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
@@ -2301,13 +2902,15 @@ ftrace_set_regex(unsigned char *buf, int len, int reset, int enable)
  * Filters denote which functions should be enabled when tracing is enabled.
  * If @buf is NULL and reset is set, all functions will be enabled for tracing.
  */
-void ftrace_set_filter(unsigned char *buf, int len, int reset)
+void ftrace_set_global_filter(unsigned char *buf, int len, int reset)
 {
-	ftrace_set_regex(buf, len, reset, 1);
+	ftrace_set_regex(&global_ops, buf, len, reset, 1);
 }
+EXPORT_SYMBOL_GPL(ftrace_set_global_filter);
 
 /**
  * ftrace_set_notrace - set a function to not trace in ftrace
+ * @ops - the ops to set the notrace filter with
  * @buf - the string that holds the function notrace text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
@@ -2316,10 +2919,11 @@ void ftrace_set_filter(unsigned char *buf, int len, int reset)
  * is enabled. If @buf is NULL and reset is set, all functions will be enabled
  * for tracing.
  */
-void ftrace_set_notrace(unsigned char *buf, int len, int reset)
+void ftrace_set_global_notrace(unsigned char *buf, int len, int reset)
 {
-	ftrace_set_regex(buf, len, reset, 0);
+	ftrace_set_regex(&global_ops, buf, len, reset, 0);
 }
+EXPORT_SYMBOL_GPL(ftrace_set_global_notrace);
 
 /*
  * command line interface to allow users to set filters on boot up.
@@ -2370,22 +2974,23 @@ static void __init set_ftrace_early_graph(char *buf)
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-static void __init set_ftrace_early_filter(char *buf, int enable)
+static void __init
+set_ftrace_early_filter(struct ftrace_ops *ops, char *buf, int enable)
 {
 	char *func;
 
 	while (buf) {
 		func = strsep(&buf, ",");
-		ftrace_set_regex(func, strlen(func), 0, enable);
+		ftrace_set_regex(ops, func, strlen(func), 0, enable);
 	}
 }
 
 static void __init set_ftrace_early_filters(void)
 {
 	if (ftrace_filter_buf[0])
-		set_ftrace_early_filter(ftrace_filter_buf, 1);
+		set_ftrace_early_filter(&global_ops, ftrace_filter_buf, 1);
 	if (ftrace_notrace_buf[0])
-		set_ftrace_early_filter(ftrace_notrace_buf, 0);
+		set_ftrace_early_filter(&global_ops, ftrace_notrace_buf, 0);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (ftrace_graph_buf[0])
 		set_ftrace_early_graph(ftrace_graph_buf);
@@ -2393,11 +2998,14 @@ static void __init set_ftrace_early_filters(void)
 }
 
 static int
-ftrace_regex_release(struct inode *inode, struct file *file, int enable)
+ftrace_regex_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter;
+	struct ftrace_hash **orig_hash;
 	struct trace_parser *parser;
+	int filter_hash;
+	int ret;
 
 	mutex_lock(&ftrace_regex_lock);
 	if (file->f_mode & FMODE_READ) {
@@ -2410,33 +3018,41 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 	parser = &iter->parser;
 	if (trace_parser_loaded(parser)) {
 		parser->buffer[parser->idx] = 0;
-		ftrace_match_records(parser->buffer, parser->idx, enable);
+		ftrace_match_records(iter->hash, parser->buffer, parser->idx);
 	}
 
-	mutex_lock(&ftrace_lock);
-	if (ftrace_start_up && ftrace_enabled)
-		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
-	mutex_unlock(&ftrace_lock);
-
 	trace_parser_put(parser);
+
+	if (file->f_mode & FMODE_WRITE) {
+		filter_hash = !!(iter->flags & FTRACE_ITER_FILTER);
+
+		if (filter_hash)
+			orig_hash = &iter->ops->filter_hash;
+		else
+			orig_hash = &iter->ops->notrace_hash;
+
+		mutex_lock(&ftrace_lock);
+		/*
+		 * Remove the current set, update the hash and add
+		 * them back.
+		 */
+		ftrace_hash_rec_disable(iter->ops, filter_hash);
+		ret = ftrace_hash_move(orig_hash, iter->hash);
+		if (!ret) {
+			ftrace_hash_rec_enable(iter->ops, filter_hash);
+			if (iter->ops->flags & FTRACE_OPS_FL_ENABLED
+			    && ftrace_enabled)
+				ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+		}
+		mutex_unlock(&ftrace_lock);
+	}
+	free_ftrace_hash(iter->hash);
 	kfree(iter);
 
 	mutex_unlock(&ftrace_regex_lock);
 	return 0;
 }
 
-static int
-ftrace_filter_release(struct inode *inode, struct file *file)
-{
-	return ftrace_regex_release(inode, file, 1);
-}
-
-static int
-ftrace_notrace_release(struct inode *inode, struct file *file)
-{
-	return ftrace_regex_release(inode, file, 0);
-}
-
 static const struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
@@ -2444,8 +3060,8 @@ static const struct file_operations ftrace_avail_fops = {
 	.release = seq_release_private,
 };
 
-static const struct file_operations ftrace_failures_fops = {
-	.open = ftrace_failures_open,
+static const struct file_operations ftrace_enabled_fops = {
+	.open = ftrace_enabled_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = seq_release_private,
@@ -2456,7 +3072,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.read = seq_read,
 	.write = ftrace_filter_write,
 	.llseek = ftrace_regex_lseek,
-	.release = ftrace_filter_release,
+	.release = ftrace_regex_release,
 };
 
 static const struct file_operations ftrace_notrace_fops = {
@@ -2464,7 +3080,7 @@ static const struct file_operations ftrace_notrace_fops = {
 	.read = seq_read,
 	.write = ftrace_notrace_write,
 	.llseek = ftrace_regex_lseek,
-	.release = ftrace_notrace_release,
+	.release = ftrace_regex_release,
 };
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -2573,9 +3189,6 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 	bool exists;
 	int i;
 
-	if (ftrace_disabled)
-		return -ENODEV;
-
 	/* decode regex */
 	type = filter_parse_regex(buffer, strlen(buffer), &search, &not);
 	if (!not && *idx >= FTRACE_GRAPH_MAX_FUNCS)
@@ -2584,12 +3197,18 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 	search_len = strlen(search);
 
 	mutex_lock(&ftrace_lock);
+
+	if (unlikely(ftrace_disabled)) {
+		mutex_unlock(&ftrace_lock);
+		return -ENODEV;
+	}
+
 	do_for_each_ftrace_rec(pg, rec) {
 
-		if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
+		if (rec->flags & FTRACE_FL_FREE)
 			continue;
 
-		if (ftrace_match_record(rec, search, search_len, type)) {
+		if (ftrace_match_record(rec, NULL, search, search_len, type)) {
 			/* if it is in the array */
 			exists = false;
 			for (i = 0; i < *idx; i++) {
@@ -2679,8 +3298,8 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	trace_create_file("available_filter_functions", 0444,
 			d_tracer, NULL, &ftrace_avail_fops);
 
-	trace_create_file("failures", 0444,
-			d_tracer, NULL, &ftrace_failures_fops);
+	trace_create_file("enabled_functions", 0444,
+			d_tracer, NULL, &ftrace_enabled_fops);
 
 	trace_create_file("set_ftrace_filter", 0644, d_tracer,
 			NULL, &ftrace_filter_fops);
@@ -2703,7 +3322,6 @@ static int ftrace_process_locs(struct module *mod,
 {
 	unsigned long *p;
 	unsigned long addr;
-	unsigned long flags;
 
 	mutex_lock(&ftrace_lock);
 	p = start;
@@ -2720,10 +3338,7 @@ static int ftrace_process_locs(struct module *mod,
 		ftrace_record_ip(addr);
 	}
 
-	/* disable interrupts to prevent kstop machine */
-	local_irq_save(flags);
 	ftrace_update_code(mod);
-	local_irq_restore(flags);
 	mutex_unlock(&ftrace_lock);
 
 	return 0;
@@ -2735,10 +3350,11 @@ void ftrace_release_mod(struct module *mod)
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
 
+	mutex_lock(&ftrace_lock);
+
 	if (ftrace_disabled)
-		return;
+		goto out_unlock;
 
-	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 		if (within_module_core(rec->ip, mod)) {
 			/*
@@ -2749,6 +3365,7 @@ void ftrace_release_mod(struct module *mod)
 			ftrace_free_rec(rec);
 		}
 	} while_for_each_ftrace_rec();
+ out_unlock:
 	mutex_unlock(&ftrace_lock);
 }
 
@@ -2835,6 +3452,10 @@ void __init ftrace_init(void)
 
 #else
 
+static struct ftrace_ops global_ops = {
+	.func			= ftrace_stub,
+};
+
 static int __init ftrace_nodyn_init(void)
 {
 	ftrace_enabled = 1;
@@ -2845,12 +3466,38 @@ device_initcall(ftrace_nodyn_init);
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
 /* Keep as macros so we do not need to define the commands */
-# define ftrace_startup(command)	do { } while (0)
-# define ftrace_shutdown(command)	do { } while (0)
+# define ftrace_startup(ops, command)	do { } while (0)
+# define ftrace_shutdown(ops, command)	do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
+
+static inline int
+ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
+{
+	return 1;
+}
+
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+static void
+ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_ops *op;
+
+	/*
+	 * Some of the ops may be dynamically allocated,
+	 * they must be freed after a synchronize_sched().
+	 */
+	preempt_disable_notrace();
+	op = rcu_dereference_raw(ftrace_ops_list);
+	while (op != &ftrace_list_end) {
+		if (ftrace_ops_test(op, ip))
+			op->func(ip, parent_ip);
+		op = rcu_dereference_raw(op->next);
+	};
+	preempt_enable_notrace();
+}
+
 static void clear_ftrace_swapper(void)
 {
 	struct task_struct *p;
@@ -3143,19 +3790,23 @@ void ftrace_kill(void)
  */
 int register_ftrace_function(struct ftrace_ops *ops)
 {
-	int ret;
-
-	if (unlikely(ftrace_disabled))
-		return -1;
+	int ret = -1;
 
 	mutex_lock(&ftrace_lock);
 
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
 	ret = __register_ftrace_function(ops);
-	ftrace_startup(0);
+	if (!ret)
+		ftrace_startup(ops, 0);
 
+
+ out_unlock:
 	mutex_unlock(&ftrace_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_ftrace_function);
 
 /**
  * unregister_ftrace_function - unregister a function for profiling.
@@ -3169,25 +3820,27 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_lock);
 	ret = __unregister_ftrace_function(ops);
-	ftrace_shutdown(0);
+	if (!ret)
+		ftrace_shutdown(ops, 0);
 	mutex_unlock(&ftrace_lock);
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(unregister_ftrace_function);
 
 int
 ftrace_enable_sysctl(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp,
 		     loff_t *ppos)
 {
-	int ret;
-
-	if (unlikely(ftrace_disabled))
-		return -ENODEV;
+	int ret = -ENODEV;
 
 	mutex_lock(&ftrace_lock);
 
-	ret  = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (unlikely(ftrace_disabled))
+		goto out;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 
 	if (ret || !write || (last_ftrace_enabled == !!ftrace_enabled))
 		goto out;
@@ -3199,11 +3852,11 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 		ftrace_startup_sysctl();
 
 		/* we are starting ftrace again */
-		if (ftrace_list != &ftrace_list_end) {
-			if (ftrace_list->next == &ftrace_list_end)
-				ftrace_trace_function = ftrace_list->func;
+		if (ftrace_ops_list != &ftrace_list_end) {
+			if (ftrace_ops_list->next == &ftrace_list_end)
+				ftrace_trace_function = ftrace_ops_list->func;
 			else
-				ftrace_trace_function = ftrace_list_func;
+				ftrace_trace_function = ftrace_ops_list_func;
 		}
 
 	} else {
@@ -3392,7 +4045,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
-	ftrace_startup(FTRACE_START_FUNC_RET);
+	ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
 
 out:
 	mutex_unlock(&ftrace_lock);
@@ -3409,7 +4062,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_active--;
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
-	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
+	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1cb49be..ee9c921 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2014,9 +2014,10 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
-	if (iter->lost_events)
-		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
-				 iter->cpu, iter->lost_events);
+	if (iter->lost_events &&
+	    !trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->cpu, iter->lost_events))
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
@@ -3230,6 +3231,14 @@ waitagain:
 
 		if (iter->seq.len >= cnt)
 			break;
+
+		/*
+		 * Setting the full flag means we reached the trace_seq buffer
+		 * size and we should leave by partial output condition above.
+		 * One of the trace_seq_* functions is not used properly.
+		 */
+		WARN_ONCE(iter->seq.full, "full flag set for trace type %d",
+			  iter->ent->type);
 	}
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5e9dfc6..6b69c4b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -419,6 +419,8 @@ extern void trace_find_cmdline(int pid, char comm[]);
 extern unsigned long ftrace_update_tot_cnt;
 #define DYN_FTRACE_TEST_NAME trace_selftest_dynamic_test_func
 extern int DYN_FTRACE_TEST_NAME(void);
+#define DYN_FTRACE_TEST_NAME2 trace_selftest_dynamic_test_func2
+extern int DYN_FTRACE_TEST_NAME2(void);
 #endif
 
 extern int ring_buffer_expanded;
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 16aee4d..8d0e1cc 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -149,11 +149,13 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = function_trace_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 
 static struct ftrace_ops trace_stack_ops __read_mostly =
 {
 	.func = function_stack_trace_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 
 /* Our two options */
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index a4969b4..c77424b 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -153,6 +153,7 @@ irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip)
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = irqsoff_tracer_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 #endif /* CONFIG_FUNCTION_TRACER */
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 456be90..cf535cc 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -830,6 +830,9 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_event);
 enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags,
 				  struct trace_event *event)
 {
+	if (!trace_seq_printf(&iter->seq, "type: %d\n", iter->ent->type))
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	return TRACE_TYPE_HANDLED;
 }
 
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 2547d88..dff763b 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -32,7 +32,7 @@ static DEFINE_MUTEX(btrace_mutex);
 
 struct trace_bprintk_fmt {
 	struct list_head list;
-	char fmt[0];
+	const char *fmt;
 };
 
 static inline struct trace_bprintk_fmt *lookup_format(const char *fmt)
@@ -49,6 +49,7 @@ static
 void hold_module_trace_bprintk_format(const char **start, const char **end)
 {
 	const char **iter;
+	char *fmt;
 
 	mutex_lock(&btrace_mutex);
 	for (iter = start; iter < end; iter++) {
@@ -58,14 +59,18 @@ void hold_module_trace_bprintk_format(const char **start, const char **end)
 			continue;
 		}
 
-		tb_fmt = kmalloc(offsetof(struct trace_bprintk_fmt, fmt)
-				+ strlen(*iter) + 1, GFP_KERNEL);
-		if (tb_fmt) {
+		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
+		if (tb_fmt)
+			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
+		if (tb_fmt && fmt) {
 			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
-			strcpy(tb_fmt->fmt, *iter);
+			strcpy(fmt, *iter);
+			tb_fmt->fmt = fmt;
 			*iter = tb_fmt->fmt;
-		} else
+		} else {
+			kfree(tb_fmt);
 			*iter = NULL;
+		}
 	}
 	mutex_unlock(&btrace_mutex);
 }
@@ -84,6 +89,76 @@ static int module_trace_bprintk_format_notify(struct notifier_block *self,
 	return 0;
 }
 
+/*
+ * The debugfs/tracing/printk_formats file maps the addresses with
+ * the ASCII formats that are used in the bprintk events in the
+ * buffer. For userspace tools to be able to decode the events from
+ * the buffer, they need to be able to map the address with the format.
+ *
+ * The addresses of the bprintk formats are in their own section
+ * __trace_printk_fmt. But for modules we copy them into a link list.
+ * The code to print the formats and their addresses passes around the
+ * address of the fmt string. If the fmt address passed into the seq
+ * functions is within the kernel core __trace_printk_fmt section, then
+ * it simply uses the next pointer in the list.
+ *
+ * When the fmt pointer is outside the kernel core __trace_printk_fmt
+ * section, then we need to read the link list pointers. The trick is
+ * we pass the address of the string to the seq function just like
+ * we do for the kernel core formats. To get back the structure that
+ * holds the format, we simply use containerof() and then go to the
+ * next format in the list.
+ */
+static const char **
+find_next_mod_format(int start_index, void *v, const char **fmt, loff_t *pos)
+{
+	struct trace_bprintk_fmt *mod_fmt;
+
+	if (list_empty(&trace_bprintk_fmt_list))
+		return NULL;
+
+	/*
+	 * v will point to the address of the fmt record from t_next
+	 * v will be NULL from t_start.
+	 * If this is the first pointer or called from start
+	 * then we need to walk the list.
+	 */
+	if (!v || start_index == *pos) {
+		struct trace_bprintk_fmt *p;
+
+		/* search the module list */
+		list_for_each_entry(p, &trace_bprintk_fmt_list, list) {
+			if (start_index == *pos)
+				return &p->fmt;
+			start_index++;
+		}
+		/* pos > index */
+		return NULL;
+	}
+
+	/*
+	 * v points to the address of the fmt field in the mod list
+	 * structure that holds the module print format.
+	 */
+	mod_fmt = container_of(v, typeof(*mod_fmt), fmt);
+	if (mod_fmt->list.next == &trace_bprintk_fmt_list)
+		return NULL;
+
+	mod_fmt = container_of(mod_fmt->list.next, typeof(*mod_fmt), list);
+
+	return &mod_fmt->fmt;
+}
+
+static void format_mod_start(void)
+{
+	mutex_lock(&btrace_mutex);
+}
+
+static void format_mod_stop(void)
+{
+	mutex_unlock(&btrace_mutex);
+}
+
 #else /* !CONFIG_MODULES */
 __init static int
 module_trace_bprintk_format_notify(struct notifier_block *self,
@@ -91,6 +166,13 @@ module_trace_bprintk_format_notify(struct notifier_block *self,
 {
 	return 0;
 }
+static inline const char **
+find_next_mod_format(int start_index, void *v, const char **fmt, loff_t *pos)
+{
+	return NULL;
+}
+static inline void format_mod_start(void) { }
+static inline void format_mod_stop(void) { }
 #endif /* CONFIG_MODULES */
 
 
@@ -153,20 +235,33 @@ int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 }
 EXPORT_SYMBOL_GPL(__ftrace_vprintk);
 
+static const char **find_next(void *v, loff_t *pos)
+{
+	const char **fmt = v;
+	int start_index;
+
+	if (!fmt)
+		fmt = __start___trace_bprintk_fmt + *pos;
+
+	start_index = __stop___trace_bprintk_fmt - __start___trace_bprintk_fmt;
+
+	if (*pos < start_index)
+		return fmt;
+
+	return find_next_mod_format(start_index, v, fmt, pos);
+}
+
 static void *
 t_start(struct seq_file *m, loff_t *pos)
 {
-	const char **fmt = __start___trace_bprintk_fmt + *pos;
-
-	if ((unsigned long)fmt >= (unsigned long)__stop___trace_bprintk_fmt)
-		return NULL;
-	return fmt;
+	format_mod_start();
+	return find_next(NULL, pos);
 }
 
 static void *t_next(struct seq_file *m, void * v, loff_t *pos)
 {
 	(*pos)++;
-	return t_start(m, pos);
+	return find_next(v, pos);
 }
 
 static int t_show(struct seq_file *m, void *v)
@@ -205,6 +300,7 @@ static int t_show(struct seq_file *m, void *v)
 
 static void t_stop(struct seq_file *m, void *p)
 {
+	format_mod_stop();
 }
 
 static const struct seq_operations show_format_seq_ops = {
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 7319559..f029dd4 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -129,6 +129,7 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = wakeup_tracer_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 #endif /* CONFIG_FUNCTION_TRACER */
 
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 659732e..288541f 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -101,6 +101,206 @@ static inline void warn_failed_init_tracer(struct tracer *trace, int init_ret)
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+static int trace_selftest_test_probe1_cnt;
+static void trace_selftest_test_probe1_func(unsigned long ip,
+					    unsigned long pip)
+{
+	trace_selftest_test_probe1_cnt++;
+}
+
+static int trace_selftest_test_probe2_cnt;
+static void trace_selftest_test_probe2_func(unsigned long ip,
+					    unsigned long pip)
+{
+	trace_selftest_test_probe2_cnt++;
+}
+
+static int trace_selftest_test_probe3_cnt;
+static void trace_selftest_test_probe3_func(unsigned long ip,
+					    unsigned long pip)
+{
+	trace_selftest_test_probe3_cnt++;
+}
+
+static int trace_selftest_test_global_cnt;
+static void trace_selftest_test_global_func(unsigned long ip,
+					    unsigned long pip)
+{
+	trace_selftest_test_global_cnt++;
+}
+
+static int trace_selftest_test_dyn_cnt;
+static void trace_selftest_test_dyn_func(unsigned long ip,
+					 unsigned long pip)
+{
+	trace_selftest_test_dyn_cnt++;
+}
+
+static struct ftrace_ops test_probe1 = {
+	.func			= trace_selftest_test_probe1_func,
+};
+
+static struct ftrace_ops test_probe2 = {
+	.func			= trace_selftest_test_probe2_func,
+};
+
+static struct ftrace_ops test_probe3 = {
+	.func			= trace_selftest_test_probe3_func,
+};
+
+static struct ftrace_ops test_global = {
+	.func			= trace_selftest_test_global_func,
+	.flags			= FTRACE_OPS_FL_GLOBAL,
+};
+
+static void print_counts(void)
+{
+	printk("(%d %d %d %d %d) ",
+	       trace_selftest_test_probe1_cnt,
+	       trace_selftest_test_probe2_cnt,
+	       trace_selftest_test_probe3_cnt,
+	       trace_selftest_test_global_cnt,
+	       trace_selftest_test_dyn_cnt);
+}
+
+static void reset_counts(void)
+{
+	trace_selftest_test_probe1_cnt = 0;
+	trace_selftest_test_probe2_cnt = 0;
+	trace_selftest_test_probe3_cnt = 0;
+	trace_selftest_test_global_cnt = 0;
+	trace_selftest_test_dyn_cnt = 0;
+}
+
+static int trace_selftest_ops(int cnt)
+{
+	int save_ftrace_enabled = ftrace_enabled;
+	struct ftrace_ops *dyn_ops;
+	char *func1_name;
+	char *func2_name;
+	int len1;
+	int len2;
+	int ret = -1;
+
+	printk(KERN_CONT "PASSED\n");
+	pr_info("Testing dynamic ftrace ops #%d: ", cnt);
+
+	ftrace_enabled = 1;
+	reset_counts();
+
+	/* Handle PPC64 '.' name */
+	func1_name = "*" __stringify(DYN_FTRACE_TEST_NAME);
+	func2_name = "*" __stringify(DYN_FTRACE_TEST_NAME2);
+	len1 = strlen(func1_name);
+	len2 = strlen(func2_name);
+
+	/*
+	 * Probe 1 will trace function 1.
+	 * Probe 2 will trace function 2.
+	 * Probe 3 will trace functions 1 and 2.
+	 */
+	ftrace_set_filter(&test_probe1, func1_name, len1, 1);
+	ftrace_set_filter(&test_probe2, func2_name, len2, 1);
+	ftrace_set_filter(&test_probe3, func1_name, len1, 1);
+	ftrace_set_filter(&test_probe3, func2_name, len2, 0);
+
+	register_ftrace_function(&test_probe1);
+	register_ftrace_function(&test_probe2);
+	register_ftrace_function(&test_probe3);
+	register_ftrace_function(&test_global);
+
+	DYN_FTRACE_TEST_NAME();
+
+	print_counts();
+
+	if (trace_selftest_test_probe1_cnt != 1)
+		goto out;
+	if (trace_selftest_test_probe2_cnt != 0)
+		goto out;
+	if (trace_selftest_test_probe3_cnt != 1)
+		goto out;
+	if (trace_selftest_test_global_cnt == 0)
+		goto out;
+
+	DYN_FTRACE_TEST_NAME2();
+
+	print_counts();
+
+	if (trace_selftest_test_probe1_cnt != 1)
+		goto out;
+	if (trace_selftest_test_probe2_cnt != 1)
+		goto out;
+	if (trace_selftest_test_probe3_cnt != 2)
+		goto out;
+
+	/* Add a dynamic probe */
+	dyn_ops = kzalloc(sizeof(*dyn_ops), GFP_KERNEL);
+	if (!dyn_ops) {
+		printk("MEMORY ERROR ");
+		goto out;
+	}
+
+	dyn_ops->func = trace_selftest_test_dyn_func;
+
+	register_ftrace_function(dyn_ops);
+
+	trace_selftest_test_global_cnt = 0;
+
+	DYN_FTRACE_TEST_NAME();
+
+	print_counts();
+
+	if (trace_selftest_test_probe1_cnt != 2)
+		goto out_free;
+	if (trace_selftest_test_probe2_cnt != 1)
+		goto out_free;
+	if (trace_selftest_test_probe3_cnt != 3)
+		goto out_free;
+	if (trace_selftest_test_global_cnt == 0)
+		goto out;
+	if (trace_selftest_test_dyn_cnt == 0)
+		goto out_free;
+
+	DYN_FTRACE_TEST_NAME2();
+
+	print_counts();
+
+	if (trace_selftest_test_probe1_cnt != 2)
+		goto out_free;
+	if (trace_selftest_test_probe2_cnt != 2)
+		goto out_free;
+	if (trace_selftest_test_probe3_cnt != 4)
+		goto out_free;
+
+	ret = 0;
+ out_free:
+	unregister_ftrace_function(dyn_ops);
+	kfree(dyn_ops);
+
+ out:
+	/* Purposely unregister in the same order */
+	unregister_ftrace_function(&test_probe1);
+	unregister_ftrace_function(&test_probe2);
+	unregister_ftrace_function(&test_probe3);
+	unregister_ftrace_function(&test_global);
+
+	/* Make sure everything is off */
+	reset_counts();
+	DYN_FTRACE_TEST_NAME();
+	DYN_FTRACE_TEST_NAME();
+
+	if (trace_selftest_test_probe1_cnt ||
+	    trace_selftest_test_probe2_cnt ||
+	    trace_selftest_test_probe3_cnt ||
+	    trace_selftest_test_global_cnt ||
+	    trace_selftest_test_dyn_cnt)
+		ret = -1;
+
+	ftrace_enabled = save_ftrace_enabled;
+
+	return ret;
+}
+
 /* Test dynamic code modification and ftrace filters */
 int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 					   struct trace_array *tr,
@@ -131,7 +331,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	func_name = "*" __stringify(DYN_FTRACE_TEST_NAME);
 
 	/* filter only on our function */
-	ftrace_set_filter(func_name, strlen(func_name), 1);
+	ftrace_set_global_filter(func_name, strlen(func_name), 1);
 
 	/* enable tracing */
 	ret = tracer_init(trace, tr);
@@ -166,22 +366,30 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 
 	/* check the trace buffer */
 	ret = trace_test_buffer(tr, &count);
-	trace->reset(tr);
 	tracing_start();
 
 	/* we should only have one item */
 	if (!ret && count != 1) {
+		trace->reset(tr);
 		printk(KERN_CONT ".. filter failed count=%ld ..", count);
 		ret = -1;
 		goto out;
 	}
 
+	/* Test the ops with global tracing running */
+	ret = trace_selftest_ops(1);
+	trace->reset(tr);
+
  out:
 	ftrace_enabled = save_ftrace_enabled;
 	tracer_enabled = save_tracer_enabled;
 
 	/* Enable tracing on all functions again */
-	ftrace_set_filter(NULL, 0, 1);
+	ftrace_set_global_filter(NULL, 0, 1);
+
+	/* Test the ops with global tracing off */
+	if (!ret)
+		ret = trace_selftest_ops(2);
 
 	return ret;
 }
diff --git a/kernel/trace/trace_selftest_dynamic.c b/kernel/trace/trace_selftest_dynamic.c
index 54dd77c..b4c475a 100644
--- a/kernel/trace/trace_selftest_dynamic.c
+++ b/kernel/trace/trace_selftest_dynamic.c
@@ -5,3 +5,9 @@ int DYN_FTRACE_TEST_NAME(void)
 	/* used to call mcount */
 	return 0;
 }
+
+int DYN_FTRACE_TEST_NAME2(void)
+{
+	/* used to call mcount */
+	return 0;
+}
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 4c5dead..b0b53b8 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -133,6 +133,7 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip)
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = stack_trace_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 
 static ssize_t
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 68187af..b219f14 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -251,9 +251,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
-	if (elem->regfunc && !elem->state && active)
+	if (elem->regfunc && !jump_label_enabled(&elem->key) && active)
 		elem->regfunc();
-	else if (elem->unregfunc && elem->state && !active)
+	else if (elem->unregfunc && jump_label_enabled(&elem->key) && !active)
 		elem->unregfunc();
 
 	/*
@@ -264,13 +264,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	if (!elem->state && active) {
-		jump_label_enable(&elem->state);
-		elem->state = active;
-	} else if (elem->state && !active) {
-		jump_label_disable(&elem->state);
-		elem->state = active;
-	}
+	if (active && !jump_label_enabled(&elem->key))
+		jump_label_inc(&elem->key);
+	else if (!active && jump_label_enabled(&elem->key))
+		jump_label_dec(&elem->key);
 }
 
 /*
@@ -281,13 +278,11 @@ static void set_tracepoint(struct tracepoint_entry **entry,
  */
 static void disable_tracepoint(struct tracepoint *elem)
 {
-	if (elem->unregfunc && elem->state)
+	if (elem->unregfunc && jump_label_enabled(&elem->key))
 		elem->unregfunc();
 
-	if (elem->state) {
-		jump_label_disable(&elem->state);
-		elem->state = 0;
-	}
+	if (jump_label_enabled(&elem->key))
+		jump_label_dec(&elem->key);
 	rcu_assign_pointer(elem->funcs, NULL);
 }
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..6165622 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -244,14 +244,19 @@ endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 ifdef BUILD_C_RECORDMCOUNT
+ifeq ("$(origin RECORDMCOUNT_WARN)", "command line")
+  RECORDMCOUNT_FLAGS = -w
+endif
 # Due to recursion, we must skip empty.o.
 # The empty.o file is created in the make process in order to determine
 #  the target endianness and word size. It is made before all other C
 #  files, including recordmcount.
 sub_cmd_record_mcount =					\
 	if [ $(@) != "scripts/mod/empty.o" ]; then	\
-		$(objtree)/scripts/recordmcount "$(@)";	\
+		$(objtree)/scripts/recordmcount $(RECORDMCOUNT_FLAGS) "$(@)";	\
 	fi;
+recordmcount_source := $(srctree)/scripts/recordmcount.c \
+		    $(srctree)/scripts/recordmcount.h
 else
 sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
@@ -259,6 +264,7 @@ sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
 	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
+recordmcount_source := $(srctree)/scripts/recordmcount.pl
 endif
 cmd_record_mcount = 						\
 	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\
@@ -279,13 +285,13 @@ define rule_cc_o_c
 endef
 
 # Built-in and composite module parts
-$(obj)/%.o: $(src)/%.c FORCE
+$(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 
 # Single-part modules are special since we need to mark them in $(MODVERDIR)
 
-$(single-used-m): $(obj)/%.o: $(src)/%.c FORCE
+$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 	@{ echo $(@:.o=.ko); echo $@; } > $(MODVERDIR)/$(@F:.o=.mod)
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index f9f6f52..ee52cb8 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -24,6 +24,7 @@
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
+#include <getopt.h>
 #include <elf.h>
 #include <fcntl.h>
 #include <setjmp.h>
@@ -39,6 +40,7 @@ static char gpfx;	/* prefix for global symbol name (sometimes '_') */
 static struct stat sb;	/* Remember .st_size, etc. */
 static jmp_buf jmpenv;	/* setjmp/longjmp per-file error escape */
 static const char *altmcount;	/* alternate mcount symbol name */
+static int warn_on_notrace_sect; /* warn when section has mcount not being recorded */
 
 /* setjmp() return values */
 enum {
@@ -78,7 +80,7 @@ static off_t
 ulseek(int const fd, off_t const offset, int const whence)
 {
 	off_t const w = lseek(fd, offset, whence);
-	if ((off_t)-1 == w) {
+	if (w == (off_t)-1) {
 		perror("lseek");
 		fail_file();
 	}
@@ -111,13 +113,41 @@ static void *
 umalloc(size_t size)
 {
 	void *const addr = malloc(size);
-	if (0 == addr) {
+	if (addr == 0) {
 		fprintf(stderr, "malloc failed: %zu bytes\n", size);
 		fail_file();
 	}
 	return addr;
 }
 
+static unsigned char ideal_nop5_x86_64[5] = { 0x0f, 0x1f, 0x44, 0x00, 0x00 };
+static unsigned char ideal_nop5_x86_32[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
+static unsigned char *ideal_nop;
+
+static char rel_type_nop;
+
+static int (*make_nop)(void *map, size_t const offset);
+
+static int make_nop_x86(void *map, size_t const offset)
+{
+	uint32_t *ptr;
+	unsigned char *op;
+
+	/* Confirm we have 0xe8 0x0 0x0 0x0 0x0 */
+	ptr = map + offset;
+	if (*ptr != 0)
+		return -1;
+
+	op = map + offset - 1;
+	if (*op != 0xe8)
+		return -1;
+
+	/* convert to nop */
+	ulseek(fd_map, offset - 1, SEEK_SET);
+	uwrite(fd_map, ideal_nop, 5);
+	return 0;
+}
+
 /*
  * Get the whole file as a programming convenience in order to avoid
  * malloc+lseek+read+free of many pieces.  If successful, then mmap
@@ -136,7 +166,7 @@ static void *mmap_file(char const *fname)
 	void *addr;
 
 	fd_map = open(fname, O_RDWR);
-	if (0 > fd_map || 0 > fstat(fd_map, &sb)) {
+	if (fd_map < 0 || fstat(fd_map, &sb) < 0) {
 		perror(fname);
 		fail_file();
 	}
@@ -147,7 +177,7 @@ static void *mmap_file(char const *fname)
 	addr = mmap(0, sb.st_size, PROT_READ|PROT_WRITE, MAP_PRIVATE,
 		    fd_map, 0);
 	mmap_failed = 0;
-	if (MAP_FAILED == addr) {
+	if (addr == MAP_FAILED) {
 		mmap_failed = 1;
 		addr = umalloc(sb.st_size);
 		uread(fd_map, addr, sb.st_size);
@@ -206,12 +236,13 @@ static uint32_t (*w2)(uint16_t);
 static int
 is_mcounted_section_name(char const *const txtname)
 {
-	return 0 == strcmp(".text",           txtname) ||
-		0 == strcmp(".ref.text",      txtname) ||
-		0 == strcmp(".sched.text",    txtname) ||
-		0 == strcmp(".spinlock.text", txtname) ||
-		0 == strcmp(".irqentry.text", txtname) ||
-		0 == strcmp(".text.unlikely", txtname);
+	return strcmp(".text",           txtname) == 0 ||
+		strcmp(".ref.text",      txtname) == 0 ||
+		strcmp(".sched.text",    txtname) == 0 ||
+		strcmp(".spinlock.text", txtname) == 0 ||
+		strcmp(".irqentry.text", txtname) == 0 ||
+		strcmp(".kprobes.text", txtname) == 0 ||
+		strcmp(".text.unlikely", txtname) == 0;
 }
 
 /* 32 bit and 64 bit are very similar */
@@ -264,43 +295,48 @@ do_file(char const *const fname)
 	w8 = w8nat;
 	switch (ehdr->e_ident[EI_DATA]) {
 		static unsigned int const endian = 1;
-	default: {
+	default:
 		fprintf(stderr, "unrecognized ELF data encoding %d: %s\n",
 			ehdr->e_ident[EI_DATA], fname);
 		fail_file();
-	} break;
-	case ELFDATA2LSB: {
-		if (1 != *(unsigned char const *)&endian) {
+		break;
+	case ELFDATA2LSB:
+		if (*(unsigned char const *)&endian != 1) {
 			/* main() is big endian, file.o is little endian. */
 			w = w4rev;
 			w2 = w2rev;
 			w8 = w8rev;
 		}
-	} break;
-	case ELFDATA2MSB: {
-		if (0 != *(unsigned char const *)&endian) {
+		break;
+	case ELFDATA2MSB:
+		if (*(unsigned char const *)&endian != 0) {
 			/* main() is little endian, file.o is big endian. */
 			w = w4rev;
 			w2 = w2rev;
 			w8 = w8rev;
 		}
-	} break;
+		break;
 	}  /* end switch */
-	if (0 != memcmp(ELFMAG, ehdr->e_ident, SELFMAG)
-	||  ET_REL != w2(ehdr->e_type)
-	||  EV_CURRENT != ehdr->e_ident[EI_VERSION]) {
+	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
+	||  w2(ehdr->e_type) != ET_REL
+	||  ehdr->e_ident[EI_VERSION] != EV_CURRENT) {
 		fprintf(stderr, "unrecognized ET_REL file %s\n", fname);
 		fail_file();
 	}
 
 	gpfx = 0;
 	switch (w2(ehdr->e_machine)) {
-	default: {
+	default:
 		fprintf(stderr, "unrecognized e_machine %d %s\n",
 			w2(ehdr->e_machine), fname);
 		fail_file();
-	} break;
-	case EM_386:	 reltype = R_386_32;                   break;
+		break;
+	case EM_386:
+		reltype = R_386_32;
+		make_nop = make_nop_x86;
+		ideal_nop = ideal_nop5_x86_32;
+		mcount_adjust_32 = -1;
+		break;
 	case EM_ARM:	 reltype = R_ARM_ABS32;
 			 altmcount = "__gnu_mcount_nc";
 			 break;
@@ -311,67 +347,91 @@ do_file(char const *const fname)
 	case EM_S390:    /* reltype: e_class    */ gpfx = '_'; break;
 	case EM_SH:	 reltype = R_SH_DIR32;                 break;
 	case EM_SPARCV9: reltype = R_SPARC_64;     gpfx = '_'; break;
-	case EM_X86_64:	 reltype = R_X86_64_64;                break;
+	case EM_X86_64:
+		make_nop = make_nop_x86;
+		ideal_nop = ideal_nop5_x86_64;
+		reltype = R_X86_64_64;
+		mcount_adjust_64 = -1;
+		break;
 	}  /* end switch */
 
 	switch (ehdr->e_ident[EI_CLASS]) {
-	default: {
+	default:
 		fprintf(stderr, "unrecognized ELF class %d %s\n",
 			ehdr->e_ident[EI_CLASS], fname);
 		fail_file();
-	} break;
-	case ELFCLASS32: {
-		if (sizeof(Elf32_Ehdr) != w2(ehdr->e_ehsize)
-		||  sizeof(Elf32_Shdr) != w2(ehdr->e_shentsize)) {
+		break;
+	case ELFCLASS32:
+		if (w2(ehdr->e_ehsize) != sizeof(Elf32_Ehdr)
+		||  w2(ehdr->e_shentsize) != sizeof(Elf32_Shdr)) {
 			fprintf(stderr,
 				"unrecognized ET_REL file: %s\n", fname);
 			fail_file();
 		}
-		if (EM_S390 == w2(ehdr->e_machine))
+		if (w2(ehdr->e_machine) == EM_S390) {
 			reltype = R_390_32;
-		if (EM_MIPS == w2(ehdr->e_machine)) {
+			mcount_adjust_32 = -4;
+		}
+		if (w2(ehdr->e_machine) == EM_MIPS) {
 			reltype = R_MIPS_32;
 			is_fake_mcount32 = MIPS32_is_fake_mcount;
 		}
 		do32(ehdr, fname, reltype);
-	} break;
+		break;
 	case ELFCLASS64: {
 		Elf64_Ehdr *const ghdr = (Elf64_Ehdr *)ehdr;
-		if (sizeof(Elf64_Ehdr) != w2(ghdr->e_ehsize)
-		||  sizeof(Elf64_Shdr) != w2(ghdr->e_shentsize)) {
+		if (w2(ghdr->e_ehsize) != sizeof(Elf64_Ehdr)
+		||  w2(ghdr->e_shentsize) != sizeof(Elf64_Shdr)) {
 			fprintf(stderr,
 				"unrecognized ET_REL file: %s\n", fname);
 			fail_file();
 		}
-		if (EM_S390 == w2(ghdr->e_machine))
+		if (w2(ghdr->e_machine) == EM_S390) {
 			reltype = R_390_64;
-		if (EM_MIPS == w2(ghdr->e_machine)) {
+			mcount_adjust_64 = -8;
+		}
+		if (w2(ghdr->e_machine) == EM_MIPS) {
 			reltype = R_MIPS_64;
 			Elf64_r_sym = MIPS64_r_sym;
 			Elf64_r_info = MIPS64_r_info;
 			is_fake_mcount64 = MIPS64_is_fake_mcount;
 		}
 		do64(ghdr, fname, reltype);
-	} break;
+		break;
+	}
 	}  /* end switch */
 
 	cleanup();
 }
 
 int
-main(int argc, char const *argv[])
+main(int argc, char *argv[])
 {
 	const char ftrace[] = "/ftrace.o";
 	int ftrace_size = sizeof(ftrace) - 1;
 	int n_error = 0;  /* gcc-4.3.0 false positive complaint */
+	int c;
+	int i;
+
+	while ((c = getopt(argc, argv, "w")) >= 0) {
+		switch (c) {
+		case 'w':
+			warn_on_notrace_sect = 1;
+			break;
+		default:
+			fprintf(stderr, "usage: recordmcount [-w] file.o...\n");
+			return 0;
+		}
+	}
 
-	if (argc <= 1) {
-		fprintf(stderr, "usage: recordmcount file.o...\n");
+	if ((argc - optind) < 1) {
+		fprintf(stderr, "usage: recordmcount [-w] file.o...\n");
 		return 0;
 	}
 
 	/* Process each file in turn, allowing deep failure. */
-	for (--argc, ++argv; 0 < argc; --argc, ++argv) {
+	for (i = optind; i < argc; i++) {
+		char *file = argv[i];
 		int const sjval = setjmp(jmpenv);
 		int len;
 
@@ -380,29 +440,29 @@ main(int argc, char const *argv[])
 		 * function but does not call it. Since ftrace.o should
 		 * not be traced anyway, we just skip it.
 		 */
-		len = strlen(argv[0]);
+		len = strlen(file);
 		if (len >= ftrace_size &&
-		    strcmp(argv[0] + (len - ftrace_size), ftrace) == 0)
+		    strcmp(file + (len - ftrace_size), ftrace) == 0)
 			continue;
 
 		switch (sjval) {
-		default: {
-			fprintf(stderr, "internal error: %s\n", argv[0]);
+		default:
+			fprintf(stderr, "internal error: %s\n", file);
 			exit(1);
-		} break;
-		case SJ_SETJMP: {  /* normal sequence */
+			break;
+		case SJ_SETJMP:    /* normal sequence */
 			/* Avoid problems if early cleanup() */
 			fd_map = -1;
 			ehdr_curr = NULL;
 			mmap_failed = 1;
-			do_file(argv[0]);
-		} break;
-		case SJ_FAIL: {  /* error in do_file or below */
+			do_file(file);
+			break;
+		case SJ_FAIL:    /* error in do_file or below */
 			++n_error;
-		} break;
-		case SJ_SUCCEED: {  /* premature success */
+			break;
+		case SJ_SUCCEED:    /* premature success */
 			/* do nothing */
-		} break;
+			break;
 		}  /* end switch */
 	}
 	return !!n_error;
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index baf187b..4be6036 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -22,11 +22,15 @@
 #undef is_fake_mcount
 #undef fn_is_fake_mcount
 #undef MIPS_is_fake_mcount
+#undef mcount_adjust
 #undef sift_rel_mcount
+#undef nop_mcount
 #undef find_secsym_ndx
 #undef __has_rel_mcount
 #undef has_rel_mcount
 #undef tot_relsize
+#undef get_mcountsym
+#undef get_sym_str_and_relp
 #undef do_func
 #undef Elf_Addr
 #undef Elf_Ehdr
@@ -49,14 +53,18 @@
 #ifdef RECORD_MCOUNT_64
 # define append_func		append64
 # define sift_rel_mcount	sift64_rel_mcount
+# define nop_mcount		nop_mcount_64
 # define find_secsym_ndx	find64_secsym_ndx
 # define __has_rel_mcount	__has64_rel_mcount
 # define has_rel_mcount		has64_rel_mcount
 # define tot_relsize		tot64_relsize
+# define get_sym_str_and_relp	get_sym_str_and_relp_64
 # define do_func		do64
+# define get_mcountsym		get_mcountsym_64
 # define is_fake_mcount		is_fake_mcount64
 # define fn_is_fake_mcount	fn_is_fake_mcount64
 # define MIPS_is_fake_mcount	MIPS64_is_fake_mcount
+# define mcount_adjust		mcount_adjust_64
 # define Elf_Addr		Elf64_Addr
 # define Elf_Ehdr		Elf64_Ehdr
 # define Elf_Shdr		Elf64_Shdr
@@ -77,14 +85,18 @@
 #else
 # define append_func		append32
 # define sift_rel_mcount	sift32_rel_mcount
+# define nop_mcount		nop_mcount_32
 # define find_secsym_ndx	find32_secsym_ndx
 # define __has_rel_mcount	__has32_rel_mcount
 # define has_rel_mcount		has32_rel_mcount
 # define tot_relsize		tot32_relsize
+# define get_sym_str_and_relp	get_sym_str_and_relp_32
 # define do_func		do32
+# define get_mcountsym		get_mcountsym_32
 # define is_fake_mcount		is_fake_mcount32
 # define fn_is_fake_mcount	fn_is_fake_mcount32
 # define MIPS_is_fake_mcount	MIPS32_is_fake_mcount
+# define mcount_adjust		mcount_adjust_32
 # define Elf_Addr		Elf32_Addr
 # define Elf_Ehdr		Elf32_Ehdr
 # define Elf_Shdr		Elf32_Shdr
@@ -123,6 +135,8 @@ static void fn_ELF_R_INFO(Elf_Rel *const rp, unsigned sym, unsigned type)
 }
 static void (*Elf_r_info)(Elf_Rel *const rp, unsigned sym, unsigned type) = fn_ELF_R_INFO;
 
+static int mcount_adjust = 0;
+
 /*
  * MIPS mcount long call has 2 _mcount symbols, only the position of the 1st
  * _mcount symbol is needed for dynamic function tracer, with it, to disable
@@ -234,6 +248,49 @@ static void append_func(Elf_Ehdr *const ehdr,
 	uwrite(fd_map, ehdr, sizeof(*ehdr));
 }
 
+static unsigned get_mcountsym(Elf_Sym const *const sym0,
+			      Elf_Rel const *relp,
+			      char const *const str0)
+{
+	unsigned mcountsym = 0;
+
+	Elf_Sym const *const symp =
+		&sym0[Elf_r_sym(relp)];
+	char const *symname = &str0[w(symp->st_name)];
+	char const *mcount = gpfx == '_' ? "_mcount" : "mcount";
+
+	if (symname[0] == '.')
+		++symname;  /* ppc64 hack */
+	if (strcmp(mcount, symname) == 0 ||
+	    (altmcount && strcmp(altmcount, symname) == 0))
+		mcountsym = Elf_r_sym(relp);
+
+	return mcountsym;
+}
+
+static void get_sym_str_and_relp(Elf_Shdr const *const relhdr,
+				 Elf_Ehdr const *const ehdr,
+				 Elf_Sym const **sym0,
+				 char const **str0,
+				 Elf_Rel const **relp)
+{
+	Elf_Shdr *const shdr0 = (Elf_Shdr *)(_w(ehdr->e_shoff)
+		+ (void *)ehdr);
+	unsigned const symsec_sh_link = w(relhdr->sh_link);
+	Elf_Shdr const *const symsec = &shdr0[symsec_sh_link];
+	Elf_Shdr const *const strsec = &shdr0[w(symsec->sh_link)];
+	Elf_Rel const *const rel0 = (Elf_Rel const *)(_w(relhdr->sh_offset)
+		+ (void *)ehdr);
+
+	*sym0 = (Elf_Sym const *)(_w(symsec->sh_offset)
+				  + (void *)ehdr);
+
+	*str0 = (char const *)(_w(strsec->sh_offset)
+			       + (void *)ehdr);
+
+	*relp = rel0;
+}
+
 /*
  * Look at the relocations in order to find the calls to mcount.
  * Accumulate the section offsets that are found, and their relocation info,
@@ -250,47 +307,27 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 {
 	uint_t *const mloc0 = mlocp;
 	Elf_Rel *mrelp = *mrelpp;
-	Elf_Shdr *const shdr0 = (Elf_Shdr *)(_w(ehdr->e_shoff)
-		+ (void *)ehdr);
-	unsigned const symsec_sh_link = w(relhdr->sh_link);
-	Elf_Shdr const *const symsec = &shdr0[symsec_sh_link];
-	Elf_Sym const *const sym0 = (Elf_Sym const *)(_w(symsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf_Shdr const *const strsec = &shdr0[w(symsec->sh_link)];
-	char const *const str0 = (char const *)(_w(strsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf_Rel const *const rel0 = (Elf_Rel const *)(_w(relhdr->sh_offset)
-		+ (void *)ehdr);
+	Elf_Sym const *sym0;
+	char const *str0;
+	Elf_Rel const *relp;
 	unsigned rel_entsize = _w(relhdr->sh_entsize);
 	unsigned const nrel = _w(relhdr->sh_size) / rel_entsize;
-	Elf_Rel const *relp = rel0;
-
 	unsigned mcountsym = 0;
 	unsigned t;
 
+	get_sym_str_and_relp(relhdr, ehdr, &sym0, &str0, &relp);
+
 	for (t = nrel; t; --t) {
-		if (!mcountsym) {
-			Elf_Sym const *const symp =
-				&sym0[Elf_r_sym(relp)];
-			char const *symname = &str0[w(symp->st_name)];
-			char const *mcount = '_' == gpfx ? "_mcount" : "mcount";
-
-			if ('.' == symname[0])
-				++symname;  /* ppc64 hack */
-			if (0 == strcmp(mcount, symname) ||
-			    (altmcount && 0 == strcmp(altmcount, symname)))
-				mcountsym = Elf_r_sym(relp);
-		}
+		if (!mcountsym)
+			mcountsym = get_mcountsym(sym0, relp, str0);
 
 		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp)) {
-			uint_t const addend = _w(_w(relp->r_offset) - recval);
-
+			uint_t const addend =
+				_w(_w(relp->r_offset) - recval + mcount_adjust);
 			mrelp->r_offset = _w(offbase
 				+ ((void *)mlocp - (void *)mloc0));
 			Elf_r_info(mrelp, recsym, reltype);
-			if (sizeof(Elf_Rela) == rel_entsize) {
+			if (rel_entsize == sizeof(Elf_Rela)) {
 				((Elf_Rela *)mrelp)->r_addend = addend;
 				*mlocp++ = 0;
 			} else
@@ -304,6 +341,63 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 	return mlocp;
 }
 
+/*
+ * Read the relocation table again, but this time its called on sections
+ * that are not going to be traced. The mcount calls here will be converted
+ * into nops.
+ */
+static void nop_mcount(Elf_Shdr const *const relhdr,
+		       Elf_Ehdr const *const ehdr,
+		       const char *const txtname)
+{
+	Elf_Shdr *const shdr0 = (Elf_Shdr *)(_w(ehdr->e_shoff)
+		+ (void *)ehdr);
+	Elf_Sym const *sym0;
+	char const *str0;
+	Elf_Rel const *relp;
+	Elf_Shdr const *const shdr = &shdr0[w(relhdr->sh_info)];
+	unsigned rel_entsize = _w(relhdr->sh_entsize);
+	unsigned const nrel = _w(relhdr->sh_size) / rel_entsize;
+	unsigned mcountsym = 0;
+	unsigned t;
+	int once = 0;
+
+	get_sym_str_and_relp(relhdr, ehdr, &sym0, &str0, &relp);
+
+	for (t = nrel; t; --t) {
+		int ret = -1;
+
+		if (!mcountsym)
+			mcountsym = get_mcountsym(sym0, relp, str0);
+
+		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp)) {
+			if (make_nop)
+				ret = make_nop((void *)ehdr, shdr->sh_offset + relp->r_offset);
+			if (warn_on_notrace_sect && !once) {
+				printf("Section %s has mcount callers being ignored\n",
+				       txtname);
+				once = 1;
+				/* just warn? */
+				if (!make_nop)
+					return;
+			}
+		}
+
+		/*
+		 * If we successfully removed the mcount, mark the relocation
+		 * as a nop (don't do anything with it).
+		 */
+		if (!ret) {
+			Elf_Rel rel;
+			rel = *(Elf_Rel *)relp;
+			Elf_r_info(&rel, Elf_r_sym(relp), rel_type_nop);
+			ulseek(fd_map, (void *)relp - (void *)ehdr, SEEK_SET);
+			uwrite(fd_map, &rel, sizeof(rel));
+		}
+		relp = (Elf_Rel const *)(rel_entsize + (void *)relp);
+	}
+}
+
 
 /*
  * Find a symbol in the given section, to be used as the base for relocating
@@ -354,13 +448,13 @@ __has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
 	Elf_Shdr const *const txthdr = &shdr0[w(relhdr->sh_info)];
 	char const *const txtname = &shstrtab[w(txthdr->sh_name)];
 
-	if (0 == strcmp("__mcount_loc", txtname)) {
+	if (strcmp("__mcount_loc", txtname) == 0) {
 		fprintf(stderr, "warning: __mcount_loc already exists: %s\n",
 			fname);
 		succeed_file();
 	}
-	if (SHT_PROGBITS != w(txthdr->sh_type) ||
-	    !is_mcounted_section_name(txtname))
+	if (w(txthdr->sh_type) != SHT_PROGBITS ||
+	    !(w(txthdr->sh_flags) & SHF_EXECINSTR))
 		return NULL;
 	return txtname;
 }
@@ -370,7 +464,7 @@ static char const *has_rel_mcount(Elf_Shdr const *const relhdr,
 				  char const *const shstrtab,
 				  char const *const fname)
 {
-	if (SHT_REL  != w(relhdr->sh_type) && SHT_RELA != w(relhdr->sh_type))
+	if (w(relhdr->sh_type) != SHT_REL && w(relhdr->sh_type) != SHT_RELA)
 		return NULL;
 	return __has_rel_mcount(relhdr, shdr0, shstrtab, fname);
 }
@@ -383,9 +477,11 @@ static unsigned tot_relsize(Elf_Shdr const *const shdr0,
 {
 	unsigned totrelsz = 0;
 	Elf_Shdr const *shdrp = shdr0;
+	char const *txtname;
 
 	for (; nhdr; --nhdr, ++shdrp) {
-		if (has_rel_mcount(shdrp, shdr0, shstrtab, fname))
+		txtname = has_rel_mcount(shdrp, shdr0, shstrtab, fname);
+		if (txtname && is_mcounted_section_name(txtname))
 			totrelsz += _w(shdrp->sh_size);
 	}
 	return totrelsz;
@@ -421,7 +517,7 @@ do_func(Elf_Ehdr *const ehdr, char const *const fname, unsigned const reltype)
 	for (relhdr = shdr0, k = nhdr; k; --k, ++relhdr) {
 		char const *const txtname = has_rel_mcount(relhdr, shdr0,
 			shstrtab, fname);
-		if (txtname) {
+		if (txtname && is_mcounted_section_name(txtname)) {
 			uint_t recval = 0;
 			unsigned const recsym = find_secsym_ndx(
 				w(relhdr->sh_info), txtname, &recval,
@@ -432,6 +528,12 @@ do_func(Elf_Ehdr *const ehdr, char const *const fname, unsigned const reltype)
 			mlocp = sift_rel_mcount(mlocp,
 				(void *)mlocp - (void *)mloc0, &mrelp,
 				relhdr, ehdr, recsym, recval, reltype);
+		} else if (txtname && (warn_on_notrace_sect || make_nop)) {
+			/*
+			 * This section is ignored by ftrace, but still
+			 * has mcount calls. Convert them to nops now.
+			 */
+			nop_mcount(relhdr, ehdr, txtname);
 		}
 	}
 	if (mloc0 != mlocp) {
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 4be0dee..858966a 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -134,6 +134,7 @@ my %text_sections = (
      ".sched.text" => 1,
      ".spinlock.text" => 1,
      ".irqentry.text" => 1,
+     ".kprobes.text" => 1,
      ".text.unlikely" => 1,
 );
 
@@ -222,6 +223,7 @@ if ($arch eq "x86_64") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
     $alignment = 8;
+    $mcount_adjust = -1;
 
     # force flags for this arch
     $ld .= " -m elf_x86_64";
@@ -231,6 +233,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "i386") {
     $alignment = 4;
+    $mcount_adjust = -1;
 
     # force flags for this arch
     $ld .= " -m elf_i386";
@@ -240,12 +243,14 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 32) {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_32\\s+_mcount\$";
+    $mcount_adjust = -4;
     $alignment = 4;
     $ld .= " -m elf_s390";
     $cc .= " -m31";
 
 } elsif ($arch eq "s390" && $bits == 64) {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
+    $mcount_adjust = -8;
     $alignment = 8;
     $type = ".quad";
     $ld .= " -m elf64_s390";
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 66f040b..86c87e2 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -113,13 +113,61 @@ OPTIONS
         Do various checks like samples ordering and lost events.
 
 -f::
---fields
+--fields::
         Comma separated list of fields to print. Options are:
         comm, tid, pid, time, cpu, event, trace, sym. Field
-        list must be prepended with the type, trace, sw or hw,
+        list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,sym  and -f trace:time,cpu,trace
 
+		perf script -f <fields>
+
+	is equivalent to:
+
+		perf script -f trace:<fields> -f sw:<fields> -f hw:<fields>
+    
+	i.e., the specified fields apply to all event types if the type string
+	is not given.
+    
+	The arguments are processed in the order received. A later usage can
+	reset a prior request. e.g.:
+    
+		-f trace: -f comm,tid,time,sym
+    
+	The first -f suppresses trace events (field list is ""), but then the
+	second invocation sets the fields to comm,tid,time,sym. In this case a
+	warning is given to the user:
+    
+		"Overriding previous field request for all events."
+    
+	Alternativey, consider the order:
+    
+		-f comm,tid,time,sym -f trace:
+    
+	The first -f sets the fields for all events and the second -f
+	suppresses trace events. The user is given a warning message about
+	the override, and the result of the above is that only S/W and H/W
+	events are displayed with the given fields.
+    
+	For the 'wildcard' option if a user selected field is invalid for an
+	event type, a message is displayed to the user that the option is
+	ignored for that type. For example:
+    
+		$ perf script -f comm,tid,trace
+		'trace' not valid for hardware events. Ignoring.
+		'trace' not valid for software events. Ignoring.
+    
+	Alternatively, if the type is given an invalid field is specified it
+	is an error. For example:
+    
+        perf script -v -f sw:comm,tid,trace
+        'trace' not valid for software events.
+    
+	At this point usage is displayed, and perf-script exits.
+    
+	Finally, a user may not set fields to none for all event types.
+	i.e., -f "" is not allowed.
+
 -k::
 --vmlinux=<file>::
         vmlinux pathname
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0c54256..1455413 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -5,6 +5,8 @@ endif
 # The default target of this Makefile is...
 all:
 
+include config/utilities.mak
+
 ifneq ($(OUTPUT),)
 # check that the output directory actually exists
 OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
@@ -13,6 +15,12 @@ endif
 
 # Define V to have a more verbose compile.
 #
+# Define PYTHON to point to the python binary if the default
+# `python' is not correct; for example: PYTHON=python2
+#
+# Define PYTHON_CONFIG to point to the python-config binary if
+# the default `$(PYTHON)-config' is not correct.
+#
 # Define ASCIIDOC8 if you want to format documentation with AsciiDoc 8
 #
 # Define DOCBOOK_XSL_172 if you want to format man pages with DocBook XSL v1.72.
@@ -134,7 +142,7 @@ INSTALL = install
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
--include feature-tests.mak
+-include config/feature-tests.mak
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
@@ -169,12 +177,10 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	$(QUIET_GEN)( \
-		export CFLAGS="$(BASIC_CFLAGS)"; \
-		python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
-			--build-temp='$(OUTPUT)python/temp' \
-	)
-
+	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
+	  --quiet build_ext \
+	  --build-lib='$(OUTPUT)python' \
+	  --build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
 #
@@ -479,24 +485,74 @@ else
 	endif
 endif
 
-ifdef NO_LIBPYTHON
-	BASIC_CFLAGS += -DNO_LIBPYTHON
+disable-python = $(eval $(disable-python_code))
+define disable-python_code
+  BASIC_CFLAGS += -DNO_LIBPYTHON
+  $(if $(1),$(warning No $(1) was found))
+  $(warning Python support won't be built)
+endef
+
+override PYTHON := \
+  $(call get-executable-or-default,PYTHON,python)
+
+ifndef PYTHON
+  $(call disable-python,python interpreter)
+  python-clean :=
 else
-       PYTHON_EMBED_LDOPTS = $(shell python-config --ldflags 2>/dev/null)
-       PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
-       PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
-	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
-	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
-	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
-		msg := $(warning No Python.h found, install python-dev[el] to have python support in 'perf script' and to build the python bindings)
-		BASIC_CFLAGS += -DNO_LIBPYTHON
-	else
-               ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
-               EXTLIBS += $(PYTHON_EMBED_LIBADD)
-		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
-		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
-		LANG_BINDINGS += $(OUTPUT)python/perf.so
-	endif
+
+  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
+
+  python-clean := $(PYTHON_WORD) util/setup.py clean \
+    --build-lib='$(OUTPUT)python' \
+    --build-temp='$(OUTPUT)python/temp'
+
+  ifdef NO_LIBPYTHON
+    $(call disable-python)
+  else
+
+    override PYTHON_CONFIG := \
+      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+
+    ifndef PYTHON_CONFIG
+      $(call disable-python,python-config tool)
+    else
+
+      PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
+
+      PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+      PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+      PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+      PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+      FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+
+      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
+        $(call disable-python,Python.h (for Python 2.x))
+      else
+
+        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED)),y)
+          $(warning Python 3 is not yet supported; please set)
+          $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
+          $(warning If you also have Python 2 installed, then)
+          $(warning try something like:)
+          $(warning $(and ,))
+          $(warning $(and ,)  make PYTHON=python2)
+          $(warning $(and ,))
+          $(warning Otherwise, disable Python support entirely:)
+          $(warning $(and ,))
+          $(warning $(and ,)  make NO_LIBPYTHON=1)
+          $(warning $(and ,))
+          $(error   $(and ,))
+        else
+          ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
+          EXTLIBS += $(PYTHON_EMBED_LIBADD)
+          LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
+          LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
+          LANG_BINDINGS += $(OUTPUT)python/perf.so
+        endif
+
+      endif
+    endif
+  endif
 endif
 
 ifdef NO_DEMANGLE
@@ -837,8 +893,7 @@ clean:
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-	@python util/setup.py clean --build-lib='$(OUTPUT)python' \
-				   --build-temp='$(OUTPUT)python/temp'
+	$(python-clean)
 
 .PHONY: all install clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ac574ea..974f6d3 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -49,57 +49,169 @@ struct output_option {
 };
 
 /* default set to maintain compatibility with current format */
-static u64 output_fields[PERF_TYPE_MAX] = {
-	[PERF_TYPE_HARDWARE] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
-			       PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
-			       PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
-
-	[PERF_TYPE_SOFTWARE] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
-			       PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
-			       PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
-
-	[PERF_TYPE_TRACEPOINT] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
-				 PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
-				 PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
+static struct {
+	bool user_set;
+	bool wildcard_set;
+	u64 fields;
+	u64 invalid_fields;
+} output[PERF_TYPE_MAX] = {
+
+	[PERF_TYPE_HARDWARE] = {
+		.user_set = false,
+
+		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
+			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+		.invalid_fields = PERF_OUTPUT_TRACE,
+	},
+
+	[PERF_TYPE_SOFTWARE] = {
+		.user_set = false,
+
+		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
+			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+		.invalid_fields = PERF_OUTPUT_TRACE,
+	},
+
+	[PERF_TYPE_TRACEPOINT] = {
+		.user_set = false,
+
+		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
+				  PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
+				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
+	},
+
+	[PERF_TYPE_RAW] = {
+		.user_set = false,
+
+		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
+			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+		.invalid_fields = PERF_OUTPUT_TRACE,
+	},
 };
 
-static bool output_set_by_user;
+static bool output_set_by_user(void)
+{
+	int j;
+	for (j = 0; j < PERF_TYPE_MAX; ++j) {
+		if (output[j].user_set)
+			return true;
+	}
+	return false;
+}
+
+static const char *output_field2str(enum perf_output_field field)
+{
+	int i, imax = ARRAY_SIZE(all_output_options);
+	const char *str = "";
+
+	for (i = 0; i < imax; ++i) {
+		if (all_output_options[i].field == field) {
+			str = all_output_options[i].str;
+			break;
+		}
+	}
+	return str;
+}
 
-#define PRINT_FIELD(x)  (output_fields[attr->type] & PERF_OUTPUT_##x)
+#define PRINT_FIELD(x)  (output[attr->type].fields & PERF_OUTPUT_##x)
 
-static int perf_session__check_attr(struct perf_session *session,
-				    struct perf_event_attr *attr)
+static int perf_event_attr__check_stype(struct perf_event_attr *attr,
+				  u64 sample_type, const char *sample_msg,
+				  enum perf_output_field field)
 {
+	int type = attr->type;
+	const char *evname;
+
+	if (attr->sample_type & sample_type)
+		return 0;
+
+	if (output[type].user_set) {
+		evname = __event_name(attr->type, attr->config);
+		pr_err("Samples for '%s' event do not have %s attribute set. "
+		       "Cannot print '%s' field.\n",
+		       evname, sample_msg, output_field2str(field));
+		return -1;
+	}
+
+	/* user did not ask for it explicitly so remove from the default list */
+	output[type].fields &= ~field;
+	evname = __event_name(attr->type, attr->config);
+	pr_debug("Samples for '%s' event do not have %s attribute set. "
+		 "Skipping '%s' field.\n",
+		 evname, sample_msg, output_field2str(field));
+
+	return 0;
+}
+
+static int perf_evsel__check_attr(struct perf_evsel *evsel,
+				  struct perf_session *session)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+
 	if (PRINT_FIELD(TRACE) &&
 		!perf_session__has_traces(session, "record -R"))
 		return -EINVAL;
 
 	if (PRINT_FIELD(SYM)) {
-		if (!(session->sample_type & PERF_SAMPLE_IP)) {
-			pr_err("Samples do not contain IP data.\n");
+		if (perf_event_attr__check_stype(attr, PERF_SAMPLE_IP, "IP",
+					   PERF_OUTPUT_SYM))
 			return -EINVAL;
-		}
+
 		if (!no_callchain &&
-		    !(session->sample_type & PERF_SAMPLE_CALLCHAIN))
+		    !(attr->sample_type & PERF_SAMPLE_CALLCHAIN))
 			symbol_conf.use_callchain = false;
 	}
 
 	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
-		!(session->sample_type & PERF_SAMPLE_TID)) {
-		pr_err("Samples do not contain TID/PID data.\n");
+		perf_event_attr__check_stype(attr, PERF_SAMPLE_TID, "TID",
+				       PERF_OUTPUT_TID|PERF_OUTPUT_PID))
 		return -EINVAL;
-	}
 
 	if (PRINT_FIELD(TIME) &&
-		!(session->sample_type & PERF_SAMPLE_TIME)) {
-		pr_err("Samples do not contain timestamps.\n");
+		perf_event_attr__check_stype(attr, PERF_SAMPLE_TIME, "TIME",
+				       PERF_OUTPUT_TIME))
 		return -EINVAL;
-	}
 
 	if (PRINT_FIELD(CPU) &&
-		!(session->sample_type & PERF_SAMPLE_CPU)) {
-		pr_err("Samples do not contain cpu.\n");
+		perf_event_attr__check_stype(attr, PERF_SAMPLE_CPU, "CPU",
+				       PERF_OUTPUT_CPU))
 		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * verify all user requested events exist and the samples
+ * have the expected data
+ */
+static int perf_session__check_output_opt(struct perf_session *session)
+{
+	int j;
+	struct perf_evsel *evsel;
+
+	for (j = 0; j < PERF_TYPE_MAX; ++j) {
+		evsel = perf_session__find_first_evtype(session, j);
+
+		/*
+		 * even if fields is set to 0 (ie., show nothing) event must
+		 * exist if user explicitly includes it on the command line
+		 */
+		if (!evsel && output[j].user_set && !output[j].wildcard_set) {
+			pr_err("%s events do not exist. "
+			       "Remove corresponding -f option to proceed.\n",
+			       event_type(j));
+			return -1;
+		}
+
+		if (evsel && output[j].fields &&
+			perf_evsel__check_attr(evsel, session))
+			return -1;
 	}
 
 	return 0;
@@ -168,10 +280,7 @@ static void process_event(union perf_event *event __unused,
 {
 	struct perf_event_attr *attr = &evsel->attr;
 
-	if (output_fields[attr->type] == 0)
-		return;
-
-	if (perf_session__check_attr(session, attr) < 0)
+	if (output[attr->type].fields == 0)
 		return;
 
 	print_sample_start(sample, thread, attr);
@@ -451,6 +560,7 @@ static int parse_output_fields(const struct option *opt __used,
 {
 	char *tok;
 	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
+	int j;
 	int rc = 0;
 	char *str = strdup(arg);
 	int type = -1;
@@ -458,52 +568,99 @@ static int parse_output_fields(const struct option *opt __used,
 	if (!str)
 		return -ENOMEM;
 
-	tok = strtok(str, ":");
-	if (!tok) {
-		fprintf(stderr,
-			"Invalid field string - not prepended with type.");
-		return -EINVAL;
-	}
-
-	/* first word should state which event type user
-	 * is specifying the fields
+	/* first word can state for which event type the user is specifying
+	 * the fields. If no type exists, the specified fields apply to all
+	 * event types found in the file minus the invalid fields for a type.
 	 */
-	if (!strcmp(tok, "hw"))
-		type = PERF_TYPE_HARDWARE;
-	else if (!strcmp(tok, "sw"))
-		type = PERF_TYPE_SOFTWARE;
-	else if (!strcmp(tok, "trace"))
-		type = PERF_TYPE_TRACEPOINT;
-	else {
-		fprintf(stderr, "Invalid event type in field string.");
-		return -EINVAL;
+	tok = strchr(str, ':');
+	if (tok) {
+		*tok = '\0';
+		tok++;
+		if (!strcmp(str, "hw"))
+			type = PERF_TYPE_HARDWARE;
+		else if (!strcmp(str, "sw"))
+			type = PERF_TYPE_SOFTWARE;
+		else if (!strcmp(str, "trace"))
+			type = PERF_TYPE_TRACEPOINT;
+		else if (!strcmp(str, "raw"))
+			type = PERF_TYPE_RAW;
+		else {
+			fprintf(stderr, "Invalid event type in field string.\n");
+			return -EINVAL;
+		}
+
+		if (output[type].user_set)
+			pr_warning("Overriding previous field request for %s events.\n",
+				   event_type(type));
+
+		output[type].fields = 0;
+		output[type].user_set = true;
+		output[type].wildcard_set = false;
+
+	} else {
+		tok = str;
+		if (strlen(str) == 0) {
+			fprintf(stderr,
+				"Cannot set fields to 'none' for all event types.\n");
+			rc = -EINVAL;
+			goto out;
+		}
+
+		if (output_set_by_user())
+			pr_warning("Overriding previous field request for all events.\n");
+
+		for (j = 0; j < PERF_TYPE_MAX; ++j) {
+			output[j].fields = 0;
+			output[j].user_set = true;
+			output[j].wildcard_set = true;
+		}
 	}
 
-	output_fields[type] = 0;
-	while (1) {
-		tok = strtok(NULL, ",");
-		if (!tok)
-			break;
+	tok = strtok(tok, ",");
+	while (tok) {
 		for (i = 0; i < imax; ++i) {
-			if (strcmp(tok, all_output_options[i].str) == 0) {
-				output_fields[type] |= all_output_options[i].field;
+			if (strcmp(tok, all_output_options[i].str) == 0)
 				break;
-			}
 		}
 		if (i == imax) {
-			fprintf(stderr, "Invalid field requested.");
+			fprintf(stderr, "Invalid field requested.\n");
 			rc = -EINVAL;
-			break;
+			goto out;
 		}
-	}
 
-	if (output_fields[type] == 0) {
-		pr_debug("No fields requested for %s type. "
-			 "Events will not be displayed\n", event_type(type));
+		if (type == -1) {
+			/* add user option to all events types for
+			 * which it is valid
+			 */
+			for (j = 0; j < PERF_TYPE_MAX; ++j) {
+				if (output[j].invalid_fields & all_output_options[i].field) {
+					pr_warning("\'%s\' not valid for %s events. Ignoring.\n",
+						   all_output_options[i].str, event_type(j));
+				} else
+					output[j].fields |= all_output_options[i].field;
+			}
+		} else {
+			if (output[type].invalid_fields & all_output_options[i].field) {
+				fprintf(stderr, "\'%s\' not valid for %s events.\n",
+					 all_output_options[i].str, event_type(type));
+
+				rc = -EINVAL;
+				goto out;
+			}
+			output[type].fields |= all_output_options[i].field;
+		}
+
+		tok = strtok(NULL, ",");
 	}
 
-	output_set_by_user = true;
+	if (type >= 0) {
+		if (output[type].fields == 0) {
+			pr_debug("No fields requested for %s type. "
+				 "Events will not be displayed.\n", event_type(type));
+		}
+	}
 
+out:
 	free(str);
 	return rc;
 }
@@ -829,7 +986,7 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace. Fields: comm,tid,pid,time,cpu,event,trace,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,sym",
 		     parse_output_fields),
 
 	OPT_END()
@@ -1020,7 +1177,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		struct stat perf_stat;
 		int input;
 
-		if (output_set_by_user) {
+		if (output_set_by_user()) {
 			fprintf(stderr,
 				"custom fields not supported for generated scripts");
 			return -1;
@@ -1060,6 +1217,11 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		pr_debug("perf script started with script %s\n\n", script_name);
 	}
 
+
+	err = perf_session__check_output_opt(session);
+	if (err < 0)
+		goto out;
+
 	err = __cmd_script(session);
 
 	perf_session__delete(session);
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 03f0e45..a9f0671 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -6,24 +6,28 @@
  *
  * Sample output:
 
-   $ perf stat ~/hackbench 10
-   Time: 0.104
+   $ perf stat ./hackbench 10
 
-    Performance counter stats for '/home/mingo/hackbench':
+  Time: 0.118
 
-       1255.538611  task clock ticks     #      10.143 CPU utilization factor
-             54011  context switches     #       0.043 M/sec
-               385  CPU migrations       #       0.000 M/sec
-             17755  pagefaults           #       0.014 M/sec
-        3808323185  CPU cycles           #    3033.219 M/sec
-        1575111190  instructions         #    1254.530 M/sec
-          17367895  cache references     #      13.833 M/sec
-           7674421  cache misses         #       6.112 M/sec
+  Performance counter stats for './hackbench 10':
 
-    Wall-clock time elapsed:   123.786620 msecs
+       1708.761321 task-clock                #   11.037 CPUs utilized
+            41,190 context-switches          #    0.024 M/sec
+             6,735 CPU-migrations            #    0.004 M/sec
+            17,318 page-faults               #    0.010 M/sec
+     5,205,202,243 cycles                    #    3.046 GHz
+     3,856,436,920 stalled-cycles-frontend   #   74.09% frontend cycles idle
+     1,600,790,871 stalled-cycles-backend    #   30.75% backend  cycles idle
+     2,603,501,247 instructions              #    0.50  insns per cycle
+                                             #    1.48  stalled cycles per insn
+       484,357,498 branches                  #  283.455 M/sec
+         6,388,934 branch-misses             #    1.32% of all branches
+
+        0.154822978  seconds time elapsed
 
  *
- * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
+ * Copyright (C) 2008-2011, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
  *
  * Improvements and fixes by:
  *
@@ -46,6 +50,7 @@
 #include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/debug.h"
+#include "util/color.h"
 #include "util/header.h"
 #include "util/cpumap.h"
 #include "util/thread.h"
@@ -65,14 +70,107 @@ static struct perf_event_attr default_attrs[] = {
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
 
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BACKEND	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_REFERENCES	},
-  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CACHE_MISSES		},
 
 };
 
+/*
+ * Detailed stats (-d), covering the L1 and last level data caches:
+ */
+static struct perf_event_attr detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_LL			<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_LL			<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+};
+
+/*
+ * Very detailed stats (-d -d), covering the instruction cache and the TLB caches:
+ */
+static struct perf_event_attr very_detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1I		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_DTLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_ITLB		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+};
+
+/*
+ * Very, very detailed stats (-d -d -d), adding prefetch events:
+ */
+static struct perf_event_attr very_very_detailed_attrs[] = {
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+};
+
+
+
 struct perf_evlist		*evsel_list;
 
 static bool			system_wide			=  false;
@@ -86,6 +184,8 @@ static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
+static int			detailed_run			=  0;
+static bool			sync_run			=  false;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
 static const char		*cpu_list;
@@ -156,7 +256,15 @@ static double stddev_stats(struct stats *stats)
 
 struct stats			runtime_nsecs_stats[MAX_NR_CPUS];
 struct stats			runtime_cycles_stats[MAX_NR_CPUS];
+struct stats			runtime_stalled_cycles_front_stats[MAX_NR_CPUS];
+struct stats			runtime_stalled_cycles_back_stats[MAX_NR_CPUS];
 struct stats			runtime_branches_stats[MAX_NR_CPUS];
+struct stats			runtime_cacherefs_stats[MAX_NR_CPUS];
+struct stats			runtime_l1_dcache_stats[MAX_NR_CPUS];
+struct stats			runtime_l1_icache_stats[MAX_NR_CPUS];
+struct stats			runtime_ll_cache_stats[MAX_NR_CPUS];
+struct stats			runtime_itlb_cache_stats[MAX_NR_CPUS];
+struct stats			runtime_dtlb_cache_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
 
 static int create_perf_stat_counter(struct perf_evsel *evsel)
@@ -193,6 +301,37 @@ static inline int nsec_counter(struct perf_evsel *evsel)
 }
 
 /*
+ * Update various tracking values we maintain to print
+ * more semantic information such as miss/hit ratios,
+ * instruction rates, etc:
+ */
+static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
+{
+	if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
+		update_stats(&runtime_nsecs_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
+		update_stats(&runtime_cycles_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
+		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_BACKEND))
+		update_stats(&runtime_stalled_cycles_back_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
+		update_stats(&runtime_branches_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_CACHE_REFERENCES))
+		update_stats(&runtime_cacherefs_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_L1D))
+		update_stats(&runtime_l1_dcache_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_L1I))
+		update_stats(&runtime_l1_icache_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_LL))
+		update_stats(&runtime_ll_cache_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_DTLB))
+		update_stats(&runtime_dtlb_cache_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_ITLB))
+		update_stats(&runtime_itlb_cache_stats[0], count[0]);
+}
+
+/*
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
  */
@@ -217,12 +356,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
-	if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
-		update_stats(&runtime_nsecs_stats[0], count[0]);
-	if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
-		update_stats(&runtime_cycles_stats[0], count[0]);
-	if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
-		update_stats(&runtime_branches_stats[0], count[0]);
+	update_shadow_stats(counter, count);
 
 	return 0;
 }
@@ -242,12 +376,7 @@ static int read_counter(struct perf_evsel *counter)
 
 		count = counter->counts->cpu[cpu].values;
 
-		if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
-			update_stats(&runtime_nsecs_stats[cpu], count[0]);
-		if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
-			update_stats(&runtime_cycles_stats[cpu], count[0]);
-		if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
-			update_stats(&runtime_branches_stats[cpu], count[0]);
+		update_shadow_stats(counter, count);
 	}
 
 	return 0;
@@ -315,13 +444,18 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter) < 0) {
-			if (errno == -EPERM || errno == -EACCES) {
+			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT) {
+				if (verbose)
+					ui__warning("%s event is not supported by the kernel.\n",
+						    event_name(counter));
+				continue;
+			}
+
+			if (errno == EPERM || errno == EACCES) {
 				error("You may not have permission to collect %sstats.\n"
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
 				      system_wide ? "system-wide " : "");
-			} else if (errno == ENOENT) {
-				error("%s event is not supported. ", event_name(counter));
 			} else {
 				error("open_counter returned with %d (%s). "
 				      "/bin/dmesg may provide additional information.\n",
@@ -372,6 +506,16 @@ static int run_perf_stat(int argc __used, const char **argv)
 	return WEXITSTATUS(status);
 }
 
+static void print_noise_pct(double total, double avg)
+{
+	double pct = 0.0;
+
+	if (avg)
+		pct = 100.0*total/avg;
+
+	fprintf(stderr, "  ( +-%6.2f%% )", pct);
+}
+
 static void print_noise(struct perf_evsel *evsel, double avg)
 {
 	struct perf_stat *ps;
@@ -380,15 +524,14 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 		return;
 
 	ps = evsel->priv;
-	fprintf(stderr, "   ( +- %7.3f%% )",
-			100 * stddev_stats(&ps->res_stats[0]) / avg);
+	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
 }
 
 static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
 	char cpustr[16] = { '\0', };
-	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-24s";
+	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-25s";
 
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
@@ -404,8 +547,191 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 		return;
 
 	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
-		fprintf(stderr, " # %10.3f CPUs ",
-				avg / avg_stats(&walltime_nsecs_stats));
+		fprintf(stderr, " # %8.3f CPUs utilized          ", avg / avg_stats(&walltime_nsecs_stats));
+}
+
+static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_cycles_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 50.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 30.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " frontend cycles idle   ");
+}
+
+static void print_stalled_cycles_backend(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_cycles_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 75.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 50.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 20.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " backend  cycles idle   ");
+}
+
+static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_branches_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all branches        ");
+}
+
+static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_l1_dcache_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all L1-dcache hits  ");
+}
+
+static void print_l1_icache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_l1_icache_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all L1-icache hits  ");
+}
+
+static void print_dtlb_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_dtlb_cache_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all dTLB cache hits ");
+}
+
+static void print_itlb_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_itlb_cache_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all iTLB cache hits ");
+}
+
+static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_ll_cache_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all LL-cache hits   ");
 }
 
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
@@ -417,9 +743,9 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	if (csv_output)
 		fmt = "%s%.0f%s%s";
 	else if (big_num)
-		fmt = "%s%'18.0f%s%-24s";
+		fmt = "%s%'18.0f%s%-25s";
 	else
-		fmt = "%s%18.0f%s%-24s";
+		fmt = "%s%18.0f%s%-25s";
 
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
@@ -442,23 +768,83 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg / total;
 
-		fprintf(stderr, " # %10.3f IPC  ", ratio);
+		fprintf(stderr, " #   %5.2f  insns per cycle        ", ratio);
+
+		total = avg_stats(&runtime_stalled_cycles_front_stats[cpu]);
+		total = max(total, avg_stats(&runtime_stalled_cycles_back_stats[cpu]));
+
+		if (total && avg) {
+			ratio = total / avg;
+			fprintf(stderr, "\n                                             #   %5.2f  stalled cycles per insn", ratio);
+		}
+
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
 			runtime_branches_stats[cpu].n != 0) {
-		total = avg_stats(&runtime_branches_stats[cpu]);
+		print_branch_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_L1D |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_l1_dcache_stats[cpu].n != 0) {
+		print_l1_dcache_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_L1I |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_l1_icache_stats[cpu].n != 0) {
+		print_l1_icache_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_DTLB |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_dtlb_cache_stats[cpu].n != 0) {
+		print_dtlb_cache_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_ITLB |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_itlb_cache_stats[cpu].n != 0) {
+		print_itlb_cache_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_LL |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_ll_cache_stats[cpu].n != 0) {
+		print_ll_cache_misses(cpu, evsel, avg);
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_CACHE_MISSES) &&
+			runtime_cacherefs_stats[cpu].n != 0) {
+		total = avg_stats(&runtime_cacherefs_stats[cpu]);
 
 		if (total)
 			ratio = avg * 100 / total;
 
-		fprintf(stderr, " # %10.3f %%    ", ratio);
+		fprintf(stderr, " # %8.3f %% of all cache refs    ", ratio);
+
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES_FRONTEND)) {
+		print_stalled_cycles_frontend(cpu, evsel, avg);
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES_BACKEND)) {
+		print_stalled_cycles_backend(cpu, evsel, avg);
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_CPU_CYCLES)) {
+		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
+		if (total)
+			ratio = 1.0 * avg / total;
+
+		fprintf(stderr, " # %8.3f GHz                    ", ratio);
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
 		if (total)
 			ratio = 1000.0 * avg / total;
 
-		fprintf(stderr, " # %10.3f M/sec", ratio);
+		fprintf(stderr, " # %8.3f M/sec                  ", ratio);
+	} else {
+		fprintf(stderr, "                                   ");
 	}
 }
 
@@ -505,8 +891,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 		avg_enabled = avg_stats(&ps->res_stats[1]);
 		avg_running = avg_stats(&ps->res_stats[2]);
 
-		fprintf(stderr, "  (scaled from %.2f%%)",
-				100 * avg_running / avg_enabled);
+		fprintf(stderr, " [%5.2f%%]", 100 * avg_running / avg_enabled);
 	}
 	fprintf(stderr, "\n");
 }
@@ -548,10 +933,8 @@ static void print_counter(struct perf_evsel *counter)
 		if (!csv_output) {
 			print_noise(counter, 1.0);
 
-			if (run != ena) {
-				fprintf(stderr, "  (scaled from %.2f%%)",
-					100.0 * run / ena);
-			}
+			if (run != ena)
+				fprintf(stderr, "  (%.2f%%)", 100.0 * run / ena);
 		}
 		fputc('\n', stderr);
 	}
@@ -591,13 +974,14 @@ static void print_stat(int argc, const char **argv)
 	}
 
 	if (!csv_output) {
-		fprintf(stderr, "\n");
-		fprintf(stderr, " %18.9f  seconds time elapsed",
+		if (!null_run)
+			fprintf(stderr, "\n");
+		fprintf(stderr, " %17.9f seconds time elapsed",
 				avg_stats(&walltime_nsecs_stats)/1e9);
 		if (run_count > 1) {
-			fprintf(stderr, "   ( +- %7.3f%% )",
-				100*stddev_stats(&walltime_nsecs_stats) /
-				avg_stats(&walltime_nsecs_stats));
+			fprintf(stderr, "                                        ");
+			print_noise_pct(stddev_stats(&walltime_nsecs_stats),
+					avg_stats(&walltime_nsecs_stats));
 		}
 		fprintf(stderr, "\n\n");
 	}
@@ -659,6 +1043,10 @@ static const struct option options[] = {
 		    "repeat command and print average + stddev (max: 100)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
+	OPT_INCR('d', "detailed", &detailed_run,
+		    "detailed run - start a lot of events"),
+	OPT_BOOLEAN('S', "sync", &sync_run,
+		    "call sync() before starting a run"),
 	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
 			   "print large numbers with thousands\' separators",
 			   stat__set_big_num),
@@ -674,6 +1062,70 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+/*
+ * Add default attributes, if there were no attributes specified or
+ * if -d/--detailed, -d -d or -d -d -d is used:
+ */
+static int add_default_attributes(void)
+{
+	struct perf_evsel *pos;
+	size_t attr_nr = 0;
+	size_t c;
+
+	/* Set attrs if no event is selected and !null_run: */
+	if (null_run)
+		return 0;
+
+	if (!evsel_list->nr_entries) {
+		for (c = 0; c < ARRAY_SIZE(default_attrs); c++) {
+			pos = perf_evsel__new(default_attrs + c, c + attr_nr);
+			if (pos == NULL)
+				return -1;
+			perf_evlist__add(evsel_list, pos);
+		}
+		attr_nr += c;
+	}
+
+	/* Detailed events get appended to the event list: */
+
+	if (detailed_run <  1)
+		return 0;
+
+	/* Append detailed run extra attributes: */
+	for (c = 0; c < ARRAY_SIZE(detailed_attrs); c++) {
+		pos = perf_evsel__new(detailed_attrs + c, c + attr_nr);
+		if (pos == NULL)
+			return -1;
+		perf_evlist__add(evsel_list, pos);
+	}
+	attr_nr += c;
+
+	if (detailed_run < 2)
+		return 0;
+
+	/* Append very detailed run extra attributes: */
+	for (c = 0; c < ARRAY_SIZE(very_detailed_attrs); c++) {
+		pos = perf_evsel__new(very_detailed_attrs + c, c + attr_nr);
+		if (pos == NULL)
+			return -1;
+		perf_evlist__add(evsel_list, pos);
+	}
+
+	if (detailed_run < 3)
+		return 0;
+
+	/* Append very, very detailed run extra attributes: */
+	for (c = 0; c < ARRAY_SIZE(very_very_detailed_attrs); c++) {
+		pos = perf_evsel__new(very_very_detailed_attrs + c, c + attr_nr);
+		if (pos == NULL)
+			return -1;
+		perf_evlist__add(evsel_list, pos);
+	}
+
+
+	return 0;
+}
+
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
 	struct perf_evsel *pos;
@@ -719,17 +1171,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(stat_usage, options);
 	}
 
-	/* Set attrs and nr_counters if no event is selected and !null_run */
-	if (!null_run && !evsel_list->nr_entries) {
-		size_t c;
-
-		for (c = 0; c < ARRAY_SIZE(default_attrs); ++c) {
-			pos = perf_evsel__new(&default_attrs[c], c);
-			if (pos == NULL)
-				goto out;
-			perf_evlist__add(evsel_list, pos);
-		}
-	}
+	if (add_default_attributes())
+		goto out;
 
 	if (target_pid != -1)
 		target_tid = target_pid;
@@ -773,6 +1216,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
 			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
+
+		if (sync_run)
+			sync();
+
 		status = run_perf_stat(argc, argv);
 	}
 
diff --git a/tools/perf/feature-tests.mak b/tools/perf/config/feature-tests.mak
similarity index 86%
rename from tools/perf/feature-tests.mak
rename to tools/perf/config/feature-tests.mak
index b041ca6..6170fd2 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -79,9 +79,15 @@ endef
 endif
 
 ifndef NO_LIBPYTHON
+define SOURCE_PYTHON_VERSION
+#include <Python.h>
+#if PY_VERSION_HEX >= 0x03000000
+	#error
+#endif
+int main(void){}
+endef
 define SOURCE_PYTHON_EMBED
 #include <Python.h>
-
 int main(void)
 {
 	Py_Initialize();
@@ -120,11 +126,3 @@ int main(void)
 	return 0;
 }
 endef
-
-# try-cc
-# Usage: option = $(call try-cc, source-to-build, cc-options)
-try-cc = $(shell sh -c						  \
-	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
-	 echo "$(1)" |						  \
-	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
-	 rm -f "$$TMP"')
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
new file mode 100644
index 0000000..8046182
--- /dev/null
+++ b/tools/perf/config/utilities.mak
@@ -0,0 +1,188 @@
+# This allows us to work with the newline character:
+define newline
+
+
+endef
+newline := $(newline)
+
+# nl-escape
+#
+# Usage: escape = $(call nl-escape[,escape])
+#
+# This is used as the common way to specify
+# what should replace a newline when escaping
+# newlines; the default is a bizarre string.
+#
+nl-escape = $(or $(1),m822df3020w6a44id34bt574ctac44eb9f4n)
+
+# escape-nl
+#
+# Usage: escaped-text = $(call escape-nl,text[,escape])
+#
+# GNU make's $(shell ...) function converts to a
+# single space each newline character in the output
+# produced during the expansion; this may not be
+# desirable.
+#
+# The only solution is to change each newline into
+# something that won't be converted, so that the
+# information can be recovered later with
+# $(call unescape-nl...)
+#
+escape-nl = $(subst $(newline),$(call nl-escape,$(2)),$(1))
+
+# unescape-nl
+#
+# Usage: text = $(call unescape-nl,escaped-text[,escape])
+#
+# See escape-nl.
+#
+unescape-nl = $(subst $(call nl-escape,$(2)),$(newline),$(1))
+
+# shell-escape-nl
+#
+# Usage: $(shell some-command | $(call shell-escape-nl[,escape]))
+#
+# Use this to escape newlines from within a shell call;
+# the default escape is a bizarre string.
+#
+# NOTE: The escape is used directly as a string constant
+#       in an `awk' program that is delimited by shell
+#       single-quotes, so be wary of the characters
+#       that are chosen.
+#
+define shell-escape-nl
+awk 'NR==1 {t=$$0} NR>1 {t=t "$(nl-escape)" $$0} END {printf t}'
+endef
+
+# shell-unescape-nl
+#
+# Usage: $(shell some-command | $(call shell-unescape-nl[,escape]))
+#
+# Use this to unescape newlines from within a shell call;
+# the default escape is a bizarre string.
+#
+# NOTE: The escape is used directly as an extended regular
+#       expression constant in an `awk' program that is
+#       delimited by shell single-quotes, so be wary
+#       of the characters that are chosen.
+#
+# (The bash shell has a bug where `{gsub(...),...}' is
+#  misinterpreted as a brace expansion; this can be
+#  overcome by putting a space between `{' and `gsub').
+#
+define shell-unescape-nl
+awk 'NR==1 {t=$$0} NR>1 {t=t "\n" $$0} END { gsub(/$(nl-escape)/,"\n",t); printf t }'
+endef
+
+# escape-for-shell-sq
+#
+# Usage: embeddable-text = $(call escape-for-shell-sq,text)
+#
+# This function produces text that is suitable for
+# embedding in a shell string that is delimited by
+# single-quotes.
+#
+escape-for-shell-sq =  $(subst ','\'',$(1))
+
+# shell-sq
+#
+# Usage: single-quoted-and-escaped-text = $(call shell-sq,text)
+#
+shell-sq = '$(escape-for-shell-sq)'
+
+# shell-wordify
+#
+# Usage: wordified-text = $(call shell-wordify,text)
+#
+# For instance:
+#
+#  |define text
+#  |hello
+#  |world
+#  |endef
+#  |
+#  |target:
+#  |	echo $(call shell-wordify,$(text))
+#
+# At least GNU make gets confused by expanding a newline
+# within the context of a command line of a makefile rule
+# (this is in constrast to a `$(shell ...)' function call,
+# which can handle it just fine).
+#
+# This function avoids the problem by producing a string
+# that works as a shell word, regardless of whether or
+# not it contains a newline.
+#
+# If the text to be wordified contains a newline, then
+# an intrictate shell command substitution is constructed
+# to render the text as a single line; when the shell
+# processes the resulting escaped text, it transforms
+# it into the original unescaped text.
+#
+# If the text does not contain a newline, then this function
+# produces the same results as the `$(shell-sq)' function.
+#
+shell-wordify = $(if $(findstring $(newline),$(1)),$(_sw-esc-nl),$(shell-sq))
+define _sw-esc-nl
+"$$(echo $(call escape-nl,$(shell-sq),$(2)) | $(call shell-unescape-nl,$(2)))"
+endef
+
+# is-absolute
+#
+# Usage: bool-value = $(call is-absolute,path)
+#
+is-absolute = $(shell echo $(shell-sq) | grep ^/ -q && echo y)
+
+# lookup
+#
+# Usage: absolute-executable-path-or-empty = $(call lookup,path)
+#
+# (It's necessary to use `sh -c' because GNU make messes up by
+#  trying too hard and getting things wrong).
+#
+lookup = $(call unescape-nl,$(shell sh -c $(_l-sh)))
+_l-sh = $(call shell-sq,command -v $(shell-sq) | $(call shell-escape-nl,))
+
+# is-executable
+#
+# Usage: bool-value = $(call is-executable,path)
+#
+# (It's necessary to use `sh -c' because GNU make messes up by
+#  trying too hard and getting things wrong).
+#
+is-executable = $(call _is-executable-helper,$(shell-sq))
+_is-executable-helper = $(shell sh -c $(_is-executable-sh))
+_is-executable-sh = $(call shell-sq,test -f $(1) -a -x $(1) && echo y)
+
+# get-executable
+#
+# Usage: absolute-executable-path-or-empty = $(call get-executable,path)
+#
+# The goal is to get an absolute path for an executable;
+# the `command -v' is defined by POSIX, but it's not
+# necessarily very portable, so it's only used if
+# relative path resolution is requested, as determined
+# by the presence of a leading `/'.
+#
+get-executable = $(if $(1),$(if $(is-absolute),$(_ge-abspath),$(lookup)))
+_ge-abspath = $(if $(is-executable),$(1))
+
+# get-supplied-or-default-executable
+#
+# Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)
+#
+define get-executable-or-default
+$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
+endef
+_ge_attempt = $(or $(get-executable),$(_gea_warn),$(call _gea_err,$(2)))
+_gea_warn = $(warning The path '$(1)' is not executable.)
+_gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
+
+# try-cc
+# Usage: option = $(call try-cc, source-to-build, cc-options)
+try-cc = $(shell sh -c						  \
+	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
+	 echo "$(1)" |						  \
+	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
+	 rm -f "$$TMP"')
diff --git a/tools/perf/util/include/asm/alternative-asm.h b/tools/perf/util/include/asm/alternative-asm.h
new file mode 100644
index 0000000..6789d78
--- /dev/null
+++ b/tools/perf/util/include/asm/alternative-asm.h
@@ -0,0 +1,8 @@
+#ifndef _PERF_ASM_ALTERNATIVE_ASM_H
+#define _PERF_ASM_ALTERNATIVE_ASM_H
+
+/* Just disable it so we can build arch/x86/lib/memcpy_64.S for perf bench: */
+
+#define altinstruction_entry #
+
+#endif
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 952b4ae..41982c3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -31,34 +31,36 @@ char debugfs_path[MAXPATHLEN];
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
 static struct event_symbol event_symbols[] = {
-  { CHW(CPU_CYCLES),		"cpu-cycles",		"cycles"	},
-  { CHW(INSTRUCTIONS),		"instructions",		""		},
-  { CHW(CACHE_REFERENCES),	"cache-references",	""		},
-  { CHW(CACHE_MISSES),		"cache-misses",		""		},
-  { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	"branches"	},
-  { CHW(BRANCH_MISSES),		"branch-misses",	""		},
-  { CHW(BUS_CYCLES),		"bus-cycles",		""		},
-
-  { CSW(CPU_CLOCK),		"cpu-clock",		""		},
-  { CSW(TASK_CLOCK),		"task-clock",		""		},
-  { CSW(PAGE_FAULTS),		"page-faults",		"faults"	},
-  { CSW(PAGE_FAULTS_MIN),	"minor-faults",		""		},
-  { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
-  { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
-  { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
-  { CSW(ALIGNMENT_FAULTS),	"alignment-faults",	""		},
-  { CSW(EMULATION_FAULTS),	"emulation-faults",	""		},
+  { CHW(CPU_CYCLES),			"cpu-cycles",			"cycles"		},
+  { CHW(STALLED_CYCLES_FRONTEND),	"stalled-cycles-frontend",	"idle-cycles-frontend"	},
+  { CHW(STALLED_CYCLES_BACKEND),	"stalled-cycles-backend",	"idle-cycles-backend"	},
+  { CHW(INSTRUCTIONS),			"instructions",			""			},
+  { CHW(CACHE_REFERENCES),		"cache-references",		""			},
+  { CHW(CACHE_MISSES),			"cache-misses",			""			},
+  { CHW(BRANCH_INSTRUCTIONS),		"branch-instructions",		"branches"		},
+  { CHW(BRANCH_MISSES),			"branch-misses",		""			},
+  { CHW(BUS_CYCLES),			"bus-cycles",			""			},
+
+  { CSW(CPU_CLOCK),			"cpu-clock",			""			},
+  { CSW(TASK_CLOCK),			"task-clock",			""			},
+  { CSW(PAGE_FAULTS),			"page-faults",			"faults"		},
+  { CSW(PAGE_FAULTS_MIN),		"minor-faults",			""			},
+  { CSW(PAGE_FAULTS_MAJ),		"major-faults",			""			},
+  { CSW(CONTEXT_SWITCHES),		"context-switches",		"cs"			},
+  { CSW(CPU_MIGRATIONS),		"cpu-migrations",		"migrations"		},
+  { CSW(ALIGNMENT_FAULTS),		"alignment-faults",		""			},
+  { CSW(EMULATION_FAULTS),		"emulation-faults",		""			},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
 	((config & PERF_EVENT_##name##_MASK) >> PERF_EVENT_##name##_SHIFT)
 
-#define PERF_EVENT_RAW(config)	__PERF_EVENT_FIELD(config, RAW)
+#define PERF_EVENT_RAW(config)		__PERF_EVENT_FIELD(config, RAW)
 #define PERF_EVENT_CONFIG(config)	__PERF_EVENT_FIELD(config, CONFIG)
-#define PERF_EVENT_TYPE(config)	__PERF_EVENT_FIELD(config, TYPE)
+#define PERF_EVENT_TYPE(config)		__PERF_EVENT_FIELD(config, TYPE)
 #define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
 
-static const char *hw_event_names[] = {
+static const char *hw_event_names[PERF_COUNT_HW_MAX] = {
 	"cycles",
 	"instructions",
 	"cache-references",
@@ -66,11 +68,13 @@ static const char *hw_event_names[] = {
 	"branches",
 	"branch-misses",
 	"bus-cycles",
+	"stalled-cycles-frontend",
+	"stalled-cycles-backend",
 };
 
-static const char *sw_event_names[] = {
-	"cpu-clock-msecs",
-	"task-clock-msecs",
+static const char *sw_event_names[PERF_COUNT_SW_MAX] = {
+	"cpu-clock",
+	"task-clock",
 	"page-faults",
 	"context-switches",
 	"CPU-migrations",
@@ -307,7 +311,7 @@ const char *__event_name(int type, u64 config)
 
 	switch (type) {
 	case PERF_TYPE_HARDWARE:
-		if (config < PERF_COUNT_HW_MAX)
+		if (config < PERF_COUNT_HW_MAX && hw_event_names[config])
 			return hw_event_names[config];
 		return "unknown-hardware";
 
@@ -333,7 +337,7 @@ const char *__event_name(int type, u64 config)
 	}
 
 	case PERF_TYPE_SOFTWARE:
-		if (config < PERF_COUNT_SW_MAX)
+		if (config < PERF_COUNT_SW_MAX && sw_event_names[config])
 			return sw_event_names[config];
 		return "unknown-software";
 
@@ -648,13 +652,15 @@ static int check_events(const char *str, unsigned int i)
 	int n;
 
 	n = strlen(event_symbols[i].symbol);
-	if (!strncmp(str, event_symbols[i].symbol, n))
+	if (!strncasecmp(str, event_symbols[i].symbol, n))
 		return n;
 
 	n = strlen(event_symbols[i].alias);
-	if (n)
-		if (!strncmp(str, event_symbols[i].alias, n))
+	if (n) {
+		if (!strncasecmp(str, event_symbols[i].alias, n))
 			return n;
+	}
+
 	return 0;
 }
 
@@ -718,15 +724,22 @@ parse_numeric_event(const char **strp, struct perf_event_attr *attr)
 	return EVT_FAILED;
 }
 
-static enum event_result
+static int
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
 	int exclude = 0;
 	int eu = 0, ek = 0, eh = 0, precise = 0;
 
-	if (*str++ != ':')
+	if (!*str)
+		return 0;
+
+	if (*str == ',')
 		return 0;
+
+	if (*str++ != ':')
+		return -1;
+
 	while (*str) {
 		if (*str == 'u') {
 			if (!exclude)
@@ -747,14 +760,16 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 
 		++str;
 	}
-	if (str >= *strp + 2) {
-		*strp = str;
-		attr->exclude_user   = eu;
-		attr->exclude_kernel = ek;
-		attr->exclude_hv     = eh;
-		attr->precise_ip     = precise;
-		return 1;
-	}
+	if (str < *strp + 2)
+		return -1;
+
+	*strp = str;
+
+	attr->exclude_user   = eu;
+	attr->exclude_kernel = ek;
+	attr->exclude_hv     = eh;
+	attr->precise_ip     = precise;
+
 	return 0;
 }
 
@@ -797,7 +812,12 @@ parse_event_symbols(const struct option *opt, const char **str,
 	return EVT_FAILED;
 
 modifier:
-	parse_event_modifier(str, attr);
+	if (parse_event_modifier(str, attr) < 0) {
+		fprintf(stderr, "invalid event modifier: '%s'\n", *str);
+		fprintf(stderr, "Run 'perf list' for a list of valid events and modifiers\n");
+
+		return EVT_FAILED;
+	}
 
 	return ret;
 }
@@ -912,7 +932,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob)
 
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
-			printf("  %-42s [%s]\n", evt_path,
+			printf("  %-50s [%s]\n", evt_path,
 				event_type_descriptors[PERF_TYPE_TRACEPOINT]);
 		}
 		closedir(evt_dir);
@@ -977,7 +997,7 @@ void print_events_type(u8 type)
 		else
 			snprintf(name, sizeof(name), "%s", syms->symbol);
 
-		printf("  %-42s [%s]\n", name,
+		printf("  %-50s [%s]\n", name,
 			event_type_descriptors[type]);
 	}
 }
@@ -995,11 +1015,10 @@ int print_hwcache_events(const char *event_glob)
 			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
 				char *name = event_cache_name(type, op, i);
 
-				if (event_glob != NULL && 
-				    !strglobmatch(name, event_glob))
+				if (event_glob != NULL && !strglobmatch(name, event_glob))
 					continue;
 
-				printf("  %-42s [%s]\n", name,
+				printf("  %-50s [%s]\n", name,
 					event_type_descriptors[PERF_TYPE_HW_CACHE]);
 				++printed;
 			}
@@ -1009,14 +1028,16 @@ int print_hwcache_events(const char *event_glob)
 	return printed;
 }
 
+#define MAX_NAME_LEN 100
+
 /*
  * Print the help text for the event symbols:
  */
 void print_events(const char *event_glob)
 {
-	struct event_symbol *syms = event_symbols;
 	unsigned int i, type, prev_type = -1, printed = 0, ntypes_printed = 0;
-	char name[40];
+	struct event_symbol *syms = event_symbols;
+	char name[MAX_NAME_LEN];
 
 	printf("\n");
 	printf("List of pre-defined events (to be used in -e):\n");
@@ -1036,10 +1057,10 @@ void print_events(const char *event_glob)
 			continue;
 
 		if (strlen(syms->alias))
-			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
+			snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
 		else
-			strcpy(name, syms->symbol);
-		printf("  %-42s [%s]\n", name,
+			strncpy(name, syms->symbol, MAX_NAME_LEN);
+		printf("  %-50s [%s]\n", name,
 			event_type_descriptors[type]);
 
 		prev_type = type;
@@ -1056,12 +1077,12 @@ void print_events(const char *event_glob)
 		return;
 
 	printf("\n");
-	printf("  %-42s [%s]\n",
+	printf("  %-50s [%s]\n",
 		"rNNN (see 'perf list --help' on how to encode it)",
 	       event_type_descriptors[PERF_TYPE_RAW]);
 	printf("\n");
 
-	printf("  %-42s [%s]\n",
+	printf("  %-50s [%s]\n",
 			"mem:<addr>[:access]",
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 	printf("\n");
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index b7c85ce..3b9d0b8 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1471,6 +1471,38 @@ static int find_probe_point_by_func(struct probe_finder *pf)
 	return _param.retval;
 }
 
+struct pubname_callback_param {
+	char *function;
+	char *file;
+	Dwarf_Die *cu_die;
+	Dwarf_Die *sp_die;
+	int found;
+};
+
+static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
+{
+	struct pubname_callback_param *param = data;
+
+	if (dwarf_offdie(dbg, gl->die_offset, param->sp_die)) {
+		if (dwarf_tag(param->sp_die) != DW_TAG_subprogram)
+			return DWARF_CB_OK;
+
+		if (die_compare_name(param->sp_die, param->function)) {
+			if (!dwarf_offdie(dbg, gl->cu_offset, param->cu_die))
+				return DWARF_CB_OK;
+
+			if (param->file &&
+			    strtailcmp(param->file, dwarf_decl_file(param->sp_die)))
+				return DWARF_CB_OK;
+
+			param->found = 1;
+			return DWARF_CB_ABORT;
+		}
+	}
+
+	return DWARF_CB_OK;
+}
+
 /* Find probe points from debuginfo */
 static int find_probes(int fd, struct probe_finder *pf)
 {
@@ -1498,6 +1530,28 @@ static int find_probes(int fd, struct probe_finder *pf)
 
 	off = 0;
 	line_list__init(&pf->lcache);
+
+	/* Fastpath: lookup by function name from .debug_pubnames section */
+	if (pp->function) {
+		struct pubname_callback_param pubname_param = {
+			.function = pp->function,
+			.file	  = pp->file,
+			.cu_die	  = &pf->cu_die,
+			.sp_die	  = &pf->sp_die,
+			.found	  = 0,
+		};
+		struct dwarf_callback_param probe_param = {
+			.data = pf,
+		};
+
+		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
+		if (pubname_param.found) {
+			ret = probe_point_search_cb(&pf->sp_die, &probe_param);
+			if (ret)
+				goto found;
+		}
+	}
+
 	/* Loop on CUs (Compilation Unit) */
 	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
@@ -1525,6 +1579,8 @@ static int find_probes(int fd, struct probe_finder *pf)
 		}
 		off = noff;
 	}
+
+found:
 	line_list__free(&pf->lcache);
 	if (dwfl)
 		dwfl_end(dwfl);
@@ -1946,6 +2002,22 @@ int find_line_range(int fd, struct line_range *lr)
 		return -EBADF;
 	}
 
+	/* Fastpath: lookup by function name from .debug_pubnames section */
+	if (lr->function) {
+		struct pubname_callback_param pubname_param = {
+			.function = lr->function, .file = lr->file,
+			.cu_die = &lf.cu_die, .sp_die = &lf.sp_die, .found = 0};
+		struct dwarf_callback_param line_range_param = {
+			.data = (void *)&lf, .retval = 0};
+
+		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
+		if (pubname_param.found) {
+			line_range_search_cb(&lf.sp_die, &line_range_param);
+			if (lf.found)
+				goto found;
+		}
+	}
+
 	/* Loop on CUs (Compilation Unit) */
 	while (!lf.found && ret >= 0) {
 		if (dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) != 0)
@@ -1974,6 +2046,7 @@ int find_line_range(int fd, struct line_range *lr)
 		off = noff;
 	}
 
+found:
 	/* Store comp_dir */
 	if (lf.found) {
 		comp_dir = cu_get_comp_dir(&lf.cu_die);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index beaefc3..605730a 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -49,6 +49,7 @@ struct probe_finder {
 	Dwarf_Addr		addr;		/* Address */
 	const char		*fname;		/* Real file name */
 	Dwarf_Die		cu_die;		/* Current CU */
+	Dwarf_Die		sp_die;
 	struct list_head	lcache;		/* Line cache for lazy match */
 
 	/* For variable searching */
@@ -83,6 +84,7 @@ struct line_finder {
 	int			lno_s;		/* Start line number */
 	int			lno_e;		/* End line number */
 	Dwarf_Die		cu_die;		/* Current CU */
+	Dwarf_Die		sp_die;
 	int			found;
 };
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index f5e3845..8b0eff8 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -810,6 +810,9 @@ static struct {
 	{ "COUNT_HW_CACHE_RESULT_ACCESS", PERF_COUNT_HW_CACHE_RESULT_ACCESS },
 	{ "COUNT_HW_CACHE_RESULT_MISS",   PERF_COUNT_HW_CACHE_RESULT_MISS },
 
+	{ "COUNT_HW_STALLED_CYCLES_FRONTEND",	  PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
+	{ "COUNT_HW_STALLED_CYCLES_BACKEND",	  PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
+
 	{ "COUNT_SW_CPU_CLOCK",	       PERF_COUNT_SW_CPU_CLOCK },
 	{ "COUNT_SW_TASK_CLOCK",       PERF_COUNT_SW_TASK_CLOCK },
 	{ "COUNT_SW_PAGE_FAULTS",      PERF_COUNT_SW_PAGE_FAULTS },
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index caa2245..fff6674 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1156,6 +1156,18 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 	return ret;
 }
 
+struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
+					      unsigned int type)
+{
+	struct perf_evsel *pos;
+
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		if (pos->attr.type == type)
+			return pos;
+	}
+	return NULL;
+}
+
 void perf_session__print_symbols(union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_session *session)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 1ac481f..8daaa2d 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -162,6 +162,9 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					session->sample_id_all, sample);
 }
 
+struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
+					    unsigned int type);
+
 void perf_session__print_symbols(union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_session *session);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f06c10f..516876d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -31,13 +31,13 @@
 #define NT_GNU_BUILD_ID 3
 #endif
 
-static bool dso__build_id_equal(const struct dso *self, u8 *build_id);
+static bool dso__build_id_equal(const struct dso *dso, u8 *build_id);
 static int elf_read_build_id(Elf *elf, void *bf, size_t size);
 static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
-static int dso__load_kernel_sym(struct dso *self, struct map *map,
+static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter);
-static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
+static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 			symbol_filter_t filter);
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
@@ -49,27 +49,27 @@ struct symbol_conf symbol_conf = {
 	.symfs            = "",
 };
 
-int dso__name_len(const struct dso *self)
+int dso__name_len(const struct dso *dso)
 {
 	if (verbose)
-		return self->long_name_len;
+		return dso->long_name_len;
 
-	return self->short_name_len;
+	return dso->short_name_len;
 }
 
-bool dso__loaded(const struct dso *self, enum map_type type)
+bool dso__loaded(const struct dso *dso, enum map_type type)
 {
-	return self->loaded & (1 << type);
+	return dso->loaded & (1 << type);
 }
 
-bool dso__sorted_by_name(const struct dso *self, enum map_type type)
+bool dso__sorted_by_name(const struct dso *dso, enum map_type type)
 {
-	return self->sorted_by_name & (1 << type);
+	return dso->sorted_by_name & (1 << type);
 }
 
-static void dso__set_sorted_by_name(struct dso *self, enum map_type type)
+static void dso__set_sorted_by_name(struct dso *dso, enum map_type type)
 {
-	self->sorted_by_name |= (1 << type);
+	dso->sorted_by_name |= (1 << type);
 }
 
 bool symbol_type__is_a(char symbol_type, enum map_type map_type)
@@ -84,9 +84,9 @@ bool symbol_type__is_a(char symbol_type, enum map_type map_type)
 	}
 }
 
-static void symbols__fixup_end(struct rb_root *self)
+static void symbols__fixup_end(struct rb_root *symbols)
 {
-	struct rb_node *nd, *prevnd = rb_first(self);
+	struct rb_node *nd, *prevnd = rb_first(symbols);
 	struct symbol *curr, *prev;
 
 	if (prevnd == NULL)
@@ -107,10 +107,10 @@ static void symbols__fixup_end(struct rb_root *self)
 		curr->end = roundup(curr->start, 4096);
 }
 
-static void __map_groups__fixup_end(struct map_groups *self, enum map_type type)
+static void __map_groups__fixup_end(struct map_groups *mg, enum map_type type)
 {
 	struct map *prev, *curr;
-	struct rb_node *nd, *prevnd = rb_first(&self->maps[type]);
+	struct rb_node *nd, *prevnd = rb_first(&mg->maps[type]);
 
 	if (prevnd == NULL)
 		return;
@@ -130,128 +130,128 @@ static void __map_groups__fixup_end(struct map_groups *self, enum map_type type)
 	curr->end = ~0ULL;
 }
 
-static void map_groups__fixup_end(struct map_groups *self)
+static void map_groups__fixup_end(struct map_groups *mg)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		__map_groups__fixup_end(self, i);
+		__map_groups__fixup_end(mg, i);
 }
 
 static struct symbol *symbol__new(u64 start, u64 len, u8 binding,
 				  const char *name)
 {
 	size_t namelen = strlen(name) + 1;
-	struct symbol *self = calloc(1, (symbol_conf.priv_size +
-					 sizeof(*self) + namelen));
-	if (self == NULL)
+	struct symbol *sym = calloc(1, (symbol_conf.priv_size +
+					sizeof(*sym) + namelen));
+	if (sym == NULL)
 		return NULL;
 
 	if (symbol_conf.priv_size)
-		self = ((void *)self) + symbol_conf.priv_size;
-
-	self->start   = start;
-	self->end     = len ? start + len - 1 : start;
-	self->binding = binding;
-	self->namelen = namelen - 1;
+		sym = ((void *)sym) + symbol_conf.priv_size;
 
-	pr_debug4("%s: %s %#" PRIx64 "-%#" PRIx64 "\n", __func__, name, start, self->end);
+	sym->start   = start;
+	sym->end     = len ? start + len - 1 : start;
+	sym->binding = binding;
+	sym->namelen = namelen - 1;
 
-	memcpy(self->name, name, namelen);
+	pr_debug4("%s: %s %#" PRIx64 "-%#" PRIx64 "\n",
+		  __func__, name, start, sym->end);
+	memcpy(sym->name, name, namelen);
 
-	return self;
+	return sym;
 }
 
-void symbol__delete(struct symbol *self)
+void symbol__delete(struct symbol *sym)
 {
-	free(((void *)self) - symbol_conf.priv_size);
+	free(((void *)sym) - symbol_conf.priv_size);
 }
 
-static size_t symbol__fprintf(struct symbol *self, FILE *fp)
+static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
 {
 	return fprintf(fp, " %" PRIx64 "-%" PRIx64 " %c %s\n",
-		       self->start, self->end,
-		       self->binding == STB_GLOBAL ? 'g' :
-		       self->binding == STB_LOCAL  ? 'l' : 'w',
-		       self->name);
+		       sym->start, sym->end,
+		       sym->binding == STB_GLOBAL ? 'g' :
+		       sym->binding == STB_LOCAL  ? 'l' : 'w',
+		       sym->name);
 }
 
-void dso__set_long_name(struct dso *self, char *name)
+void dso__set_long_name(struct dso *dso, char *name)
 {
 	if (name == NULL)
 		return;
-	self->long_name = name;
-	self->long_name_len = strlen(name);
+	dso->long_name = name;
+	dso->long_name_len = strlen(name);
 }
 
-static void dso__set_short_name(struct dso *self, const char *name)
+static void dso__set_short_name(struct dso *dso, const char *name)
 {
 	if (name == NULL)
 		return;
-	self->short_name = name;
-	self->short_name_len = strlen(name);
+	dso->short_name = name;
+	dso->short_name_len = strlen(name);
 }
 
-static void dso__set_basename(struct dso *self)
+static void dso__set_basename(struct dso *dso)
 {
-	dso__set_short_name(self, basename(self->long_name));
+	dso__set_short_name(dso, basename(dso->long_name));
 }
 
 struct dso *dso__new(const char *name)
 {
-	struct dso *self = calloc(1, sizeof(*self) + strlen(name) + 1);
+	struct dso *dso = calloc(1, sizeof(*dso) + strlen(name) + 1);
 
-	if (self != NULL) {
+	if (dso != NULL) {
 		int i;
-		strcpy(self->name, name);
-		dso__set_long_name(self, self->name);
-		dso__set_short_name(self, self->name);
+		strcpy(dso->name, name);
+		dso__set_long_name(dso, dso->name);
+		dso__set_short_name(dso, dso->name);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
-			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
-		self->symtab_type = SYMTAB__NOT_FOUND;
-		self->loaded = 0;
-		self->sorted_by_name = 0;
-		self->has_build_id = 0;
-		self->kernel = DSO_TYPE_USER;
-		INIT_LIST_HEAD(&self->node);
+			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
+		dso->symtab_type = SYMTAB__NOT_FOUND;
+		dso->loaded = 0;
+		dso->sorted_by_name = 0;
+		dso->has_build_id = 0;
+		dso->kernel = DSO_TYPE_USER;
+		INIT_LIST_HEAD(&dso->node);
 	}
 
-	return self;
+	return dso;
 }
 
-static void symbols__delete(struct rb_root *self)
+static void symbols__delete(struct rb_root *symbols)
 {
 	struct symbol *pos;
-	struct rb_node *next = rb_first(self);
+	struct rb_node *next = rb_first(symbols);
 
 	while (next) {
 		pos = rb_entry(next, struct symbol, rb_node);
 		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, self);
+		rb_erase(&pos->rb_node, symbols);
 		symbol__delete(pos);
 	}
 }
 
-void dso__delete(struct dso *self)
+void dso__delete(struct dso *dso)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		symbols__delete(&self->symbols[i]);
-	if (self->sname_alloc)
-		free((char *)self->short_name);
-	if (self->lname_alloc)
-		free(self->long_name);
-	free(self);
+		symbols__delete(&dso->symbols[i]);
+	if (dso->sname_alloc)
+		free((char *)dso->short_name);
+	if (dso->lname_alloc)
+		free(dso->long_name);
+	free(dso);
 }
 
-void dso__set_build_id(struct dso *self, void *build_id)
+void dso__set_build_id(struct dso *dso, void *build_id)
 {
-	memcpy(self->build_id, build_id, sizeof(self->build_id));
-	self->has_build_id = 1;
+	memcpy(dso->build_id, build_id, sizeof(dso->build_id));
+	dso->has_build_id = 1;
 }
 
-static void symbols__insert(struct rb_root *self, struct symbol *sym)
+static void symbols__insert(struct rb_root *symbols, struct symbol *sym)
 {
-	struct rb_node **p = &self->rb_node;
+	struct rb_node **p = &symbols->rb_node;
 	struct rb_node *parent = NULL;
 	const u64 ip = sym->start;
 	struct symbol *s;
@@ -265,17 +265,17 @@ static void symbols__insert(struct rb_root *self, struct symbol *sym)
 			p = &(*p)->rb_right;
 	}
 	rb_link_node(&sym->rb_node, parent, p);
-	rb_insert_color(&sym->rb_node, self);
+	rb_insert_color(&sym->rb_node, symbols);
 }
 
-static struct symbol *symbols__find(struct rb_root *self, u64 ip)
+static struct symbol *symbols__find(struct rb_root *symbols, u64 ip)
 {
 	struct rb_node *n;
 
-	if (self == NULL)
+	if (symbols == NULL)
 		return NULL;
 
-	n = self->rb_node;
+	n = symbols->rb_node;
 
 	while (n) {
 		struct symbol *s = rb_entry(n, struct symbol, rb_node);
@@ -296,9 +296,9 @@ struct symbol_name_rb_node {
 	struct symbol	sym;
 };
 
-static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
+static void symbols__insert_by_name(struct rb_root *symbols, struct symbol *sym)
 {
-	struct rb_node **p = &self->rb_node;
+	struct rb_node **p = &symbols->rb_node;
 	struct rb_node *parent = NULL;
 	struct symbol_name_rb_node *symn, *s;
 
@@ -313,27 +313,29 @@ static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
 			p = &(*p)->rb_right;
 	}
 	rb_link_node(&symn->rb_node, parent, p);
-	rb_insert_color(&symn->rb_node, self);
+	rb_insert_color(&symn->rb_node, symbols);
 }
 
-static void symbols__sort_by_name(struct rb_root *self, struct rb_root *source)
+static void symbols__sort_by_name(struct rb_root *symbols,
+				  struct rb_root *source)
 {
 	struct rb_node *nd;
 
 	for (nd = rb_first(source); nd; nd = rb_next(nd)) {
 		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
-		symbols__insert_by_name(self, pos);
+		symbols__insert_by_name(symbols, pos);
 	}
 }
 
-static struct symbol *symbols__find_by_name(struct rb_root *self, const char *name)
+static struct symbol *symbols__find_by_name(struct rb_root *symbols,
+					    const char *name)
 {
 	struct rb_node *n;
 
-	if (self == NULL)
+	if (symbols == NULL)
 		return NULL;
 
-	n = self->rb_node;
+	n = symbols->rb_node;
 
 	while (n) {
 		struct symbol_name_rb_node *s;
@@ -353,29 +355,29 @@ static struct symbol *symbols__find_by_name(struct rb_root *self, const char *na
 	return NULL;
 }
 
-struct symbol *dso__find_symbol(struct dso *self,
+struct symbol *dso__find_symbol(struct dso *dso,
 				enum map_type type, u64 addr)
 {
-	return symbols__find(&self->symbols[type], addr);
+	return symbols__find(&dso->symbols[type], addr);
 }
 
-struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name)
 {
-	return symbols__find_by_name(&self->symbol_names[type], name);
+	return symbols__find_by_name(&dso->symbol_names[type], name);
 }
 
-void dso__sort_by_name(struct dso *self, enum map_type type)
+void dso__sort_by_name(struct dso *dso, enum map_type type)
 {
-	dso__set_sorted_by_name(self, type);
-	return symbols__sort_by_name(&self->symbol_names[type],
-				     &self->symbols[type]);
+	dso__set_sorted_by_name(dso, type);
+	return symbols__sort_by_name(&dso->symbol_names[type],
+				     &dso->symbols[type]);
 }
 
-int build_id__sprintf(const u8 *self, int len, char *bf)
+int build_id__sprintf(const u8 *build_id, int len, char *bf)
 {
 	char *bid = bf;
-	const u8 *raw = self;
+	const u8 *raw = build_id;
 	int i;
 
 	for (i = 0; i < len; ++i) {
@@ -384,24 +386,25 @@ int build_id__sprintf(const u8 *self, int len, char *bf)
 		bid += 2;
 	}
 
-	return raw - self;
+	return raw - build_id;
 }
 
-size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
+size_t dso__fprintf_buildid(struct dso *dso, FILE *fp)
 {
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
-	build_id__sprintf(self->build_id, sizeof(self->build_id), sbuild_id);
+	build_id__sprintf(dso->build_id, sizeof(dso->build_id), sbuild_id);
 	return fprintf(fp, "%s", sbuild_id);
 }
 
-size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *fp)
+size_t dso__fprintf_symbols_by_name(struct dso *dso,
+				    enum map_type type, FILE *fp)
 {
 	size_t ret = 0;
 	struct rb_node *nd;
 	struct symbol_name_rb_node *pos;
 
-	for (nd = rb_first(&self->symbol_names[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&dso->symbol_names[type]); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct symbol_name_rb_node, rb_node);
 		fprintf(fp, "%s\n", pos->sym.name);
 	}
@@ -409,18 +412,18 @@ size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *
 	return ret;
 }
 
-size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
+size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
 {
 	struct rb_node *nd;
-	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
+	size_t ret = fprintf(fp, "dso: %s (", dso->short_name);
 
-	if (self->short_name != self->long_name)
-		ret += fprintf(fp, "%s, ", self->long_name);
+	if (dso->short_name != dso->long_name)
+		ret += fprintf(fp, "%s, ", dso->long_name);
 	ret += fprintf(fp, "%s, %sloaded, ", map_type__name[type],
-		       self->loaded ? "" : "NOT ");
-	ret += dso__fprintf_buildid(self, fp);
+		       dso->loaded ? "" : "NOT ");
+	ret += dso__fprintf_buildid(dso, fp);
 	ret += fprintf(fp, ")\n");
-	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&dso->symbols[type]); nd; nd = rb_next(nd)) {
 		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
 		ret += symbol__fprintf(pos, fp);
 	}
@@ -543,10 +546,10 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
  * so that we can in the next step set the symbol ->end address and then
  * call kernel_maps__split_kallsyms.
  */
-static int dso__load_all_kallsyms(struct dso *self, const char *filename,
+static int dso__load_all_kallsyms(struct dso *dso, const char *filename,
 				  struct map *map)
 {
-	struct process_kallsyms_args args = { .map = map, .dso = self, };
+	struct process_kallsyms_args args = { .map = map, .dso = dso, };
 	return kallsyms__parse(filename, &args, map__process_kallsym_symbol);
 }
 
@@ -555,7 +558,7 @@ static int dso__load_all_kallsyms(struct dso *self, const char *filename,
  * kernel range is broken in several maps, named [kernel].N, as we don't have
  * the original ELF section names vmlinux have.
  */
-static int dso__split_kallsyms(struct dso *self, struct map *map,
+static int dso__split_kallsyms(struct dso *dso, struct map *map,
 			       symbol_filter_t filter)
 {
 	struct map_groups *kmaps = map__kmap(map)->kmaps;
@@ -563,7 +566,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 	struct map *curr_map = map;
 	struct symbol *pos;
 	int count = 0, moved = 0;	
-	struct rb_root *root = &self->symbols[map->type];
+	struct rb_root *root = &dso->symbols[map->type];
 	struct rb_node *next = rb_first(root);
 	int kernel_range = 0;
 
@@ -582,7 +585,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 
 			if (strcmp(curr_map->dso->short_name, module)) {
 				if (curr_map != map &&
-				    self->kernel == DSO_TYPE_GUEST_KERNEL &&
+				    dso->kernel == DSO_TYPE_GUEST_KERNEL &&
 				    machine__is_default_guest(machine)) {
 					/*
 					 * We assume all symbols of a module are
@@ -618,14 +621,14 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			pos->end   = curr_map->map_ip(curr_map, pos->end);
 		} else if (curr_map != map) {
 			char dso_name[PATH_MAX];
-			struct dso *dso;
+			struct dso *ndso;
 
 			if (count == 0) {
 				curr_map = map;
 				goto filter_symbol;
 			}
 
-			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
+			if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
 					kernel_range++);
@@ -634,15 +637,15 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 					"[kernel].%d",
 					kernel_range++);
 
-			dso = dso__new(dso_name);
-			if (dso == NULL)
+			ndso = dso__new(dso_name);
+			if (ndso == NULL)
 				return -1;
 
-			dso->kernel = self->kernel;
+			ndso->kernel = dso->kernel;
 
-			curr_map = map__new2(pos->start, dso, map->type);
+			curr_map = map__new2(pos->start, ndso, map->type);
 			if (curr_map == NULL) {
-				dso__delete(dso);
+				dso__delete(ndso);
 				return -1;
 			}
 
@@ -665,7 +668,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 	}
 
 	if (curr_map != map &&
-	    self->kernel == DSO_TYPE_GUEST_KERNEL &&
+	    dso->kernel == DSO_TYPE_GUEST_KERNEL &&
 	    machine__is_default_guest(kmaps->machine)) {
 		dso__set_loaded(curr_map->dso, curr_map->type);
 	}
@@ -673,21 +676,21 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 	return count + moved;
 }
 
-int dso__load_kallsyms(struct dso *self, const char *filename,
+int dso__load_kallsyms(struct dso *dso, const char *filename,
 		       struct map *map, symbol_filter_t filter)
 {
-	if (dso__load_all_kallsyms(self, filename, map) < 0)
+	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
-	if (self->kernel == DSO_TYPE_GUEST_KERNEL)
-		self->symtab_type = SYMTAB__GUEST_KALLSYMS;
+	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
+		dso->symtab_type = SYMTAB__GUEST_KALLSYMS;
 	else
-		self->symtab_type = SYMTAB__KALLSYMS;
+		dso->symtab_type = SYMTAB__KALLSYMS;
 
-	return dso__split_kallsyms(self, map, filter);
+	return dso__split_kallsyms(dso, map, filter);
 }
 
-static int dso__load_perf_map(struct dso *self, struct map *map,
+static int dso__load_perf_map(struct dso *dso, struct map *map,
 			      symbol_filter_t filter)
 {
 	char *line = NULL;
@@ -695,7 +698,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 	FILE *file;
 	int nr_syms = 0;
 
-	file = fopen(self->long_name, "r");
+	file = fopen(dso->long_name, "r");
 	if (file == NULL)
 		goto out_failure;
 
@@ -733,7 +736,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 		if (filter && filter(map, sym))
 			symbol__delete(sym);
 		else {
-			symbols__insert(&self->symbols[map->type], sym);
+			symbols__insert(&dso->symbols[map->type], sym);
 			nr_syms++;
 		}
 	}
@@ -752,7 +755,7 @@ out_failure:
 /**
  * elf_symtab__for_each_symbol - iterate thru all the symbols
  *
- * @self: struct elf_symtab instance to iterate
+ * @syms: struct elf_symtab instance to iterate
  * @idx: uint32_t idx
  * @sym: GElf_Sym iterator
  */
@@ -852,7 +855,7 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
  * And always look at the original dso, not at debuginfo packages, that
  * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
  */
-static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
+static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
 				       symbol_filter_t filter)
 {
 	uint32_t nr_rel_entries, idx;
@@ -871,7 +874,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 	char name[PATH_MAX];
 
 	snprintf(name, sizeof(name), "%s%s",
-		 symbol_conf.symfs, self->long_name);
+		 symbol_conf.symfs, dso->long_name);
 	fd = open(name, O_RDONLY);
 	if (fd < 0)
 		goto out;
@@ -947,7 +950,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (filter && filter(map, f))
 				symbol__delete(f);
 			else {
-				symbols__insert(&self->symbols[map->type], f);
+				symbols__insert(&dso->symbols[map->type], f);
 				++nr;
 			}
 		}
@@ -969,7 +972,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (filter && filter(map, f))
 				symbol__delete(f);
 			else {
-				symbols__insert(&self->symbols[map->type], f);
+				symbols__insert(&dso->symbols[map->type], f);
 				++nr;
 			}
 		}
@@ -985,29 +988,30 @@ out_close:
 		return nr;
 out:
 	pr_debug("%s: problems reading %s PLT info.\n",
-		 __func__, self->long_name);
+		 __func__, dso->long_name);
 	return 0;
 }
 
-static bool elf_sym__is_a(GElf_Sym *self, enum map_type type)
+static bool elf_sym__is_a(GElf_Sym *sym, enum map_type type)
 {
 	switch (type) {
 	case MAP__FUNCTION:
-		return elf_sym__is_function(self);
+		return elf_sym__is_function(sym);
 	case MAP__VARIABLE:
-		return elf_sym__is_object(self);
+		return elf_sym__is_object(sym);
 	default:
 		return false;
 	}
 }
 
-static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type)
+static bool elf_sec__is_a(GElf_Shdr *shdr, Elf_Data *secstrs,
+			  enum map_type type)
 {
 	switch (type) {
 	case MAP__FUNCTION:
-		return elf_sec__is_text(self, secstrs);
+		return elf_sec__is_text(shdr, secstrs);
 	case MAP__VARIABLE:
-		return elf_sec__is_data(self, secstrs);
+		return elf_sec__is_data(shdr, secstrs);
 	default:
 		return false;
 	}
@@ -1032,13 +1036,13 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
 	return -1;
 }
 
-static int dso__load_sym(struct dso *self, struct map *map, const char *name,
+static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
 			 int fd, symbol_filter_t filter, int kmodule,
 			 int want_symtab)
 {
-	struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
+	struct kmap *kmap = dso->kernel ? map__kmap(map) : NULL;
 	struct map *curr_map = map;
-	struct dso *curr_dso = self;
+	struct dso *curr_dso = dso;
 	Elf_Data *symstrs, *secstrs;
 	uint32_t nr_syms;
 	int err = -1;
@@ -1064,14 +1068,14 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	}
 
 	/* Always reject images with a mismatched build-id: */
-	if (self->has_build_id) {
+	if (dso->has_build_id) {
 		u8 build_id[BUILD_ID_SIZE];
 
 		if (elf_read_build_id(elf, build_id,
 				      BUILD_ID_SIZE) != BUILD_ID_SIZE)
 			goto out_elf_end;
 
-		if (!dso__build_id_equal(self, build_id))
+		if (!dso__build_id_equal(dso, build_id))
 			goto out_elf_end;
 	}
 
@@ -1112,13 +1116,14 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	if (self->kernel == DSO_TYPE_USER) {
-		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+	if (dso->kernel == DSO_TYPE_USER) {
+		dso->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
-	} else self->adjust_symbols = 0;
-
+	} else {
+		dso->adjust_symbols = 0;
+	}
 	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
 		const char *elf_name = elf_sym__name(&sym, symstrs);
@@ -1168,22 +1173,22 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		    (sym.st_value & 1))
 			--sym.st_value;
 
-		if (self->kernel != DSO_TYPE_USER || kmodule) {
+		if (dso->kernel != DSO_TYPE_USER || kmodule) {
 			char dso_name[PATH_MAX];
 
 			if (strcmp(section_name,
 				   (curr_dso->short_name +
-				    self->short_name_len)) == 0)
+				    dso->short_name_len)) == 0)
 				goto new_symbol;
 
 			if (strcmp(section_name, ".text") == 0) {
 				curr_map = map;
-				curr_dso = self;
+				curr_dso = dso;
 				goto new_symbol;
 			}
 
 			snprintf(dso_name, sizeof(dso_name),
-				 "%s%s", self->short_name, section_name);
+				 "%s%s", dso->short_name, section_name);
 
 			curr_map = map_groups__find_by_name(kmap->kmaps, map->type, dso_name);
 			if (curr_map == NULL) {
@@ -1195,9 +1200,9 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				curr_dso = dso__new(dso_name);
 				if (curr_dso == NULL)
 					goto out_elf_end;
-				curr_dso->kernel = self->kernel;
-				curr_dso->long_name = self->long_name;
-				curr_dso->long_name_len = self->long_name_len;
+				curr_dso->kernel = dso->kernel;
+				curr_dso->long_name = dso->long_name;
+				curr_dso->long_name_len = dso->long_name_len;
 				curr_map = map__new2(start, curr_dso,
 						     map->type);
 				if (curr_map == NULL) {
@@ -1206,9 +1211,9 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				}
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
-				curr_dso->symtab_type = self->symtab_type;
+				curr_dso->symtab_type = dso->symtab_type;
 				map_groups__insert(kmap->kmaps, curr_map);
-				dsos__add(&self->node, curr_dso);
+				dsos__add(&dso->node, curr_dso);
 				dso__set_loaded(curr_dso, map->type);
 			} else
 				curr_dso = curr_map->dso;
@@ -1250,7 +1255,7 @@ new_symbol:
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
 	if (nr > 0) {
-		symbols__fixup_end(&self->symbols[map->type]);
+		symbols__fixup_end(&dso->symbols[map->type]);
 		if (kmap) {
 			/*
 			 * We need to fixup this here too because we create new
@@ -1266,9 +1271,9 @@ out_close:
 	return err;
 }
 
-static bool dso__build_id_equal(const struct dso *self, u8 *build_id)
+static bool dso__build_id_equal(const struct dso *dso, u8 *build_id)
 {
-	return memcmp(self->build_id, build_id, sizeof(self->build_id)) == 0;
+	return memcmp(dso->build_id, build_id, sizeof(dso->build_id)) == 0;
 }
 
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
@@ -1429,7 +1434,7 @@ out:
 	return err;
 }
 
-char dso__symtab_origin(const struct dso *self)
+char dso__symtab_origin(const struct dso *dso)
 {
 	static const char origin[] = {
 		[SYMTAB__KALLSYMS]	      = 'k',
@@ -1444,12 +1449,12 @@ char dso__symtab_origin(const struct dso *self)
 		[SYMTAB__GUEST_KMODULE]	      =  'G',
 	};
 
-	if (self == NULL || self->symtab_type == SYMTAB__NOT_FOUND)
+	if (dso == NULL || dso->symtab_type == SYMTAB__NOT_FOUND)
 		return '!';
-	return origin[self->symtab_type];
+	return origin[dso->symtab_type];
 }
 
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
+int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 {
 	int size = PATH_MAX;
 	char *name;
@@ -1459,12 +1464,12 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	const char *root_dir;
 	int want_symtab;
 
-	dso__set_loaded(self, map->type);
+	dso__set_loaded(dso, map->type);
 
-	if (self->kernel == DSO_TYPE_KERNEL)
-		return dso__load_kernel_sym(self, map, filter);
-	else if (self->kernel == DSO_TYPE_GUEST_KERNEL)
-		return dso__load_guest_kernel_sym(self, map, filter);
+	if (dso->kernel == DSO_TYPE_KERNEL)
+		return dso__load_kernel_sym(dso, map, filter);
+	else if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
+		return dso__load_guest_kernel_sym(dso, map, filter);
 
 	if (map->groups && map->groups->machine)
 		machine = map->groups->machine;
@@ -1475,11 +1480,11 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	if (!name)
 		return -1;
 
-	self->adjust_symbols = 0;
+	dso->adjust_symbols = 0;
 
-	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
-		ret = dso__load_perf_map(self, map, filter);
-		self->symtab_type = ret > 0 ? SYMTAB__JAVA_JIT :
+	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
+		ret = dso__load_perf_map(dso, map, filter);
+		dso->symtab_type = ret > 0 ? SYMTAB__JAVA_JIT :
 					      SYMTAB__NOT_FOUND;
 		return ret;
 	}
@@ -1490,33 +1495,33 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	 */
 	want_symtab = 1;
 restart:
-	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE;
-	     self->symtab_type != SYMTAB__NOT_FOUND;
-	     self->symtab_type++) {
-		switch (self->symtab_type) {
+	for (dso->symtab_type = SYMTAB__BUILD_ID_CACHE;
+	     dso->symtab_type != SYMTAB__NOT_FOUND;
+	     dso->symtab_type++) {
+		switch (dso->symtab_type) {
 		case SYMTAB__BUILD_ID_CACHE:
 			/* skip the locally configured cache if a symfs is given */
 			if (symbol_conf.symfs[0] ||
-			    (dso__build_id_filename(self, name, size) == NULL)) {
+			    (dso__build_id_filename(dso, name, size) == NULL)) {
 				continue;
 			}
 			break;
 		case SYMTAB__FEDORA_DEBUGINFO:
 			snprintf(name, size, "%s/usr/lib/debug%s.debug",
-				 symbol_conf.symfs, self->long_name);
+				 symbol_conf.symfs, dso->long_name);
 			break;
 		case SYMTAB__UBUNTU_DEBUGINFO:
 			snprintf(name, size, "%s/usr/lib/debug%s",
-				 symbol_conf.symfs, self->long_name);
+				 symbol_conf.symfs, dso->long_name);
 			break;
 		case SYMTAB__BUILDID_DEBUGINFO: {
 			char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 
-			if (!self->has_build_id)
+			if (!dso->has_build_id)
 				continue;
 
-			build_id__sprintf(self->build_id,
-					  sizeof(self->build_id),
+			build_id__sprintf(dso->build_id,
+					  sizeof(dso->build_id),
 					  build_id_hex);
 			snprintf(name, size,
 				 "%s/usr/lib/debug/.build-id/%.2s/%s.debug",
@@ -1525,7 +1530,7 @@ restart:
 			break;
 		case SYMTAB__SYSTEM_PATH_DSO:
 			snprintf(name, size, "%s%s",
-			     symbol_conf.symfs, self->long_name);
+			     symbol_conf.symfs, dso->long_name);
 			break;
 		case SYMTAB__GUEST_KMODULE:
 			if (map->groups && machine)
@@ -1533,12 +1538,12 @@ restart:
 			else
 				root_dir = "";
 			snprintf(name, size, "%s%s%s", symbol_conf.symfs,
-				 root_dir, self->long_name);
+				 root_dir, dso->long_name);
 			break;
 
 		case SYMTAB__SYSTEM_PATH_KMODULE:
 			snprintf(name, size, "%s%s", symbol_conf.symfs,
-				 self->long_name);
+				 dso->long_name);
 			break;
 		default:;
 		}
@@ -1548,7 +1553,7 @@ restart:
 		if (fd < 0)
 			continue;
 
-		ret = dso__load_sym(self, map, name, fd, filter, 0,
+		ret = dso__load_sym(dso, map, name, fd, filter, 0,
 				    want_symtab);
 		close(fd);
 
@@ -1560,7 +1565,8 @@ restart:
 			continue;
 
 		if (ret > 0) {
-			int nr_plt = dso__synthesize_plt_symbols(self, map, filter);
+			int nr_plt = dso__synthesize_plt_symbols(dso, map,
+								 filter);
 			if (nr_plt > 0)
 				ret += nr_plt;
 			break;
@@ -1577,17 +1583,17 @@ restart:
 	}
 
 	free(name);
-	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
+	if (ret < 0 && strstr(dso->name, " (deleted)") != NULL)
 		return 0;
 	return ret;
 }
 
-struct map *map_groups__find_by_name(struct map_groups *self,
+struct map *map_groups__find_by_name(struct map_groups *mg,
 				     enum map_type type, const char *name)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&mg->maps[type]); nd; nd = rb_next(nd)) {
 		struct map *map = rb_entry(nd, struct map, rb_node);
 
 		if (map->dso && strcmp(map->dso->short_name, name) == 0)
@@ -1597,28 +1603,28 @@ struct map *map_groups__find_by_name(struct map_groups *self,
 	return NULL;
 }
 
-static int dso__kernel_module_get_build_id(struct dso *self,
-				const char *root_dir)
+static int dso__kernel_module_get_build_id(struct dso *dso,
+					   const char *root_dir)
 {
 	char filename[PATH_MAX];
 	/*
 	 * kernel module short names are of the form "[module]" and
 	 * we need just "module" here.
 	 */
-	const char *name = self->short_name + 1;
+	const char *name = dso->short_name + 1;
 
 	snprintf(filename, sizeof(filename),
 		 "%s/sys/module/%.*s/notes/.note.gnu.build-id",
 		 root_dir, (int)strlen(name) - 1, name);
 
-	if (sysfs__read_build_id(filename, self->build_id,
-				 sizeof(self->build_id)) == 0)
-		self->has_build_id = true;
+	if (sysfs__read_build_id(filename, dso->build_id,
+				 sizeof(dso->build_id)) == 0)
+		dso->has_build_id = true;
 
 	return 0;
 }
 
-static int map_groups__set_modules_path_dir(struct map_groups *self,
+static int map_groups__set_modules_path_dir(struct map_groups *mg,
 				const char *dir_name)
 {
 	struct dirent *dent;
@@ -1646,7 +1652,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dir_name, dent->d_name);
-			ret = map_groups__set_modules_path_dir(self, path);
+			ret = map_groups__set_modules_path_dir(mg, path);
 			if (ret < 0)
 				goto out;
 		} else {
@@ -1661,7 +1667,8 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 				 (int)(dot - dent->d_name), dent->d_name);
 
 			strxfrchar(dso_name, '-', '_');
-			map = map_groups__find_by_name(self, MAP__FUNCTION, dso_name);
+			map = map_groups__find_by_name(mg, MAP__FUNCTION,
+						       dso_name);
 			if (map == NULL)
 				continue;
 
@@ -1711,20 +1718,20 @@ static char *get_kernel_version(const char *root_dir)
 	return strdup(name);
 }
 
-static int machine__set_modules_path(struct machine *self)
+static int machine__set_modules_path(struct machine *machine)
 {
 	char *version;
 	char modules_path[PATH_MAX];
 
-	version = get_kernel_version(self->root_dir);
+	version = get_kernel_version(machine->root_dir);
 	if (!version)
 		return -1;
 
 	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
-		 self->root_dir, version);
+		 machine->root_dir, version);
 	free(version);
 
-	return map_groups__set_modules_path_dir(&self->kmaps, modules_path);
+	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path);
 }
 
 /*
@@ -1734,23 +1741,23 @@ static int machine__set_modules_path(struct machine *self)
  */
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 {
-	struct map *self = calloc(1, (sizeof(*self) +
-				      (dso->kernel ? sizeof(struct kmap) : 0)));
-	if (self != NULL) {
+	struct map *map = calloc(1, (sizeof(*map) +
+				     (dso->kernel ? sizeof(struct kmap) : 0)));
+	if (map != NULL) {
 		/*
 		 * ->end will be filled after we load all the symbols
 		 */
-		map__init(self, type, start, 0, 0, dso);
+		map__init(map, type, start, 0, 0, dso);
 	}
 
-	return self;
+	return map;
 }
 
-struct map *machine__new_module(struct machine *self, u64 start,
+struct map *machine__new_module(struct machine *machine, u64 start,
 				const char *filename)
 {
 	struct map *map;
-	struct dso *dso = __dsos__findnew(&self->kernel_dsos, filename);
+	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, filename);
 
 	if (dso == NULL)
 		return NULL;
@@ -1759,15 +1766,15 @@ struct map *machine__new_module(struct machine *self, u64 start,
 	if (map == NULL)
 		return NULL;
 
-	if (machine__is_host(self))
+	if (machine__is_host(machine))
 		dso->symtab_type = SYMTAB__SYSTEM_PATH_KMODULE;
 	else
 		dso->symtab_type = SYMTAB__GUEST_KMODULE;
-	map_groups__insert(&self->kmaps, map);
+	map_groups__insert(&machine->kmaps, map);
 	return map;
 }
 
-static int machine__create_modules(struct machine *self)
+static int machine__create_modules(struct machine *machine)
 {
 	char *line = NULL;
 	size_t n;
@@ -1776,10 +1783,10 @@ static int machine__create_modules(struct machine *self)
 	const char *modules;
 	char path[PATH_MAX];
 
-	if (machine__is_default_guest(self))
+	if (machine__is_default_guest(machine))
 		modules = symbol_conf.default_guest_modules;
 	else {
-		sprintf(path, "%s/proc/modules", self->root_dir);
+		sprintf(path, "%s/proc/modules", machine->root_dir);
 		modules = path;
 	}
 
@@ -1815,16 +1822,16 @@ static int machine__create_modules(struct machine *self)
 		*sep = '\0';
 
 		snprintf(name, sizeof(name), "[%s]", line);
-		map = machine__new_module(self, start, name);
+		map = machine__new_module(machine, start, name);
 		if (map == NULL)
 			goto out_delete_line;
-		dso__kernel_module_get_build_id(map->dso, self->root_dir);
+		dso__kernel_module_get_build_id(map->dso, machine->root_dir);
 	}
 
 	free(line);
 	fclose(file);
 
-	return machine__set_modules_path(self);
+	return machine__set_modules_path(machine);
 
 out_delete_line:
 	free(line);
@@ -1832,7 +1839,7 @@ out_failure:
 	return -1;
 }
 
-int dso__load_vmlinux(struct dso *self, struct map *map,
+int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1, fd;
@@ -1844,9 +1851,9 @@ int dso__load_vmlinux(struct dso *self, struct map *map,
 	if (fd < 0)
 		return -1;
 
-	dso__set_long_name(self, (char *)vmlinux);
-	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, symfs_vmlinux, fd, filter, 0, 0);
+	dso__set_long_name(dso, (char *)vmlinux);
+	dso__set_loaded(dso, map->type);
+	err = dso__load_sym(dso, map, symfs_vmlinux, fd, filter, 0, 0);
 	close(fd);
 
 	if (err > 0)
@@ -1855,7 +1862,7 @@ int dso__load_vmlinux(struct dso *self, struct map *map,
 	return err;
 }
 
-int dso__load_vmlinux_path(struct dso *self, struct map *map,
+int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 			   symbol_filter_t filter)
 {
 	int i, err = 0;
@@ -1864,20 +1871,20 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
 		 vmlinux_path__nr_entries + 1);
 
-	filename = dso__build_id_filename(self, NULL, 0);
+	filename = dso__build_id_filename(dso, NULL, 0);
 	if (filename != NULL) {
-		err = dso__load_vmlinux(self, map, filename, filter);
+		err = dso__load_vmlinux(dso, map, filename, filter);
 		if (err > 0) {
-			dso__set_long_name(self, filename);
+			dso__set_long_name(dso, filename);
 			goto out;
 		}
 		free(filename);
 	}
 
 	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-		err = dso__load_vmlinux(self, map, vmlinux_path[i], filter);
+		err = dso__load_vmlinux(dso, map, vmlinux_path[i], filter);
 		if (err > 0) {
-			dso__set_long_name(self, strdup(vmlinux_path[i]));
+			dso__set_long_name(dso, strdup(vmlinux_path[i]));
 			break;
 		}
 	}
@@ -1885,7 +1892,7 @@ out:
 	return err;
 }
 
-static int dso__load_kernel_sym(struct dso *self, struct map *map,
+static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter)
 {
 	int err;
@@ -1912,10 +1919,10 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	}
 
 	if (symbol_conf.vmlinux_name != NULL) {
-		err = dso__load_vmlinux(self, map,
+		err = dso__load_vmlinux(dso, map,
 					symbol_conf.vmlinux_name, filter);
 		if (err > 0) {
-			dso__set_long_name(self,
+			dso__set_long_name(dso,
 					   strdup(symbol_conf.vmlinux_name));
 			goto out_fixup;
 		}
@@ -1923,7 +1930,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	}
 
 	if (vmlinux_path != NULL) {
-		err = dso__load_vmlinux_path(self, map, filter);
+		err = dso__load_vmlinux_path(dso, map, filter);
 		if (err > 0)
 			goto out_fixup;
 	}
@@ -1937,13 +1944,13 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	 * we have a build-id, so check if it is the same as the running kernel,
 	 * using it if it is.
 	 */
-	if (self->has_build_id) {
+	if (dso->has_build_id) {
 		u8 kallsyms_build_id[BUILD_ID_SIZE];
 		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
 		if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
 					 sizeof(kallsyms_build_id)) == 0) {
-			if (dso__build_id_equal(self, kallsyms_build_id)) {
+			if (dso__build_id_equal(dso, kallsyms_build_id)) {
 				kallsyms_filename = "/proc/kallsyms";
 				goto do_kallsyms;
 			}
@@ -1952,7 +1959,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 		 * Now look if we have it on the build-id cache in
 		 * $HOME/.debug/[kernel.kallsyms].
 		 */
-		build_id__sprintf(self->build_id, sizeof(self->build_id),
+		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
 				  sbuild_id);
 
 		if (asprintf(&kallsyms_allocated_filename,
@@ -1979,7 +1986,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	}
 
 do_kallsyms:
-	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
+	err = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
 	if (err > 0)
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	free(kallsyms_allocated_filename);
@@ -1987,7 +1994,7 @@ do_kallsyms:
 	if (err > 0) {
 out_fixup:
 		if (kallsyms_filename != NULL)
-			dso__set_long_name(self, strdup("[kernel.kallsyms]"));
+			dso__set_long_name(dso, strdup("[kernel.kallsyms]"));
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
@@ -1995,8 +2002,8 @@ out_fixup:
 	return err;
 }
 
-static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
-				symbol_filter_t filter)
+static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
+				      symbol_filter_t filter)
 {
 	int err;
 	const char *kallsyms_filename = NULL;
@@ -2016,7 +2023,7 @@ static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
 		 * Or use file guest_kallsyms inputted by user on commandline
 		 */
 		if (symbol_conf.default_guest_vmlinux_name != NULL) {
-			err = dso__load_vmlinux(self, map,
+			err = dso__load_vmlinux(dso, map,
 				symbol_conf.default_guest_vmlinux_name, filter);
 			goto out_try_fixup;
 		}
@@ -2029,7 +2036,7 @@ static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
 		kallsyms_filename = path;
 	}
 
-	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
+	err = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
 	if (err > 0)
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 
@@ -2037,7 +2044,7 @@ out_try_fixup:
 	if (err > 0) {
 		if (kallsyms_filename != NULL) {
 			machine__mmap_name(machine, path, sizeof(path));
-			dso__set_long_name(self, strdup(path));
+			dso__set_long_name(dso, strdup(path));
 		}
 		map__fixup_start(map);
 		map__fixup_end(map);
@@ -2090,12 +2097,12 @@ size_t __dsos__fprintf(struct list_head *head, FILE *fp)
 	return ret;
 }
 
-size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp)
+size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp)
 {
 	struct rb_node *nd;
 	size_t ret = 0;
 
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
 		ret += __dsos__fprintf(&pos->user_dsos, fp);
@@ -2119,18 +2126,20 @@ static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
 	return ret;
 }
 
-size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits)
+size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
+				     bool with_hits)
 {
-	return __dsos__fprintf_buildid(&self->kernel_dsos, fp, with_hits) +
-	       __dsos__fprintf_buildid(&self->user_dsos, fp, with_hits);
+	return __dsos__fprintf_buildid(&machine->kernel_dsos, fp, with_hits) +
+	       __dsos__fprintf_buildid(&machine->user_dsos, fp, with_hits);
 }
 
-size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits)
+size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
+				      FILE *fp, bool with_hits)
 {
 	struct rb_node *nd;
 	size_t ret = 0;
 
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret += machine__fprintf_dsos_buildid(pos, fp, with_hits);
 	}
@@ -2139,59 +2148,59 @@ size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_
 
 struct dso *dso__new_kernel(const char *name)
 {
-	struct dso *self = dso__new(name ?: "[kernel.kallsyms]");
+	struct dso *dso = dso__new(name ?: "[kernel.kallsyms]");
 
-	if (self != NULL) {
-		dso__set_short_name(self, "[kernel]");
-		self->kernel = DSO_TYPE_KERNEL;
+	if (dso != NULL) {
+		dso__set_short_name(dso, "[kernel]");
+		dso->kernel = DSO_TYPE_KERNEL;
 	}
 
-	return self;
+	return dso;
 }
 
 static struct dso *dso__new_guest_kernel(struct machine *machine,
 					const char *name)
 {
 	char bf[PATH_MAX];
-	struct dso *self = dso__new(name ?: machine__mmap_name(machine, bf, sizeof(bf)));
-
-	if (self != NULL) {
-		dso__set_short_name(self, "[guest.kernel]");
-		self->kernel = DSO_TYPE_GUEST_KERNEL;
+	struct dso *dso = dso__new(name ?: machine__mmap_name(machine, bf,
+							      sizeof(bf)));
+	if (dso != NULL) {
+		dso__set_short_name(dso, "[guest.kernel]");
+		dso->kernel = DSO_TYPE_GUEST_KERNEL;
 	}
 
-	return self;
+	return dso;
 }
 
-void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine)
+void dso__read_running_kernel_build_id(struct dso *dso, struct machine *machine)
 {
 	char path[PATH_MAX];
 
 	if (machine__is_default_guest(machine))
 		return;
 	sprintf(path, "%s/sys/kernel/notes", machine->root_dir);
-	if (sysfs__read_build_id(path, self->build_id,
-				 sizeof(self->build_id)) == 0)
-		self->has_build_id = true;
+	if (sysfs__read_build_id(path, dso->build_id,
+				 sizeof(dso->build_id)) == 0)
+		dso->has_build_id = true;
 }
 
-static struct dso *machine__create_kernel(struct machine *self)
+static struct dso *machine__create_kernel(struct machine *machine)
 {
 	const char *vmlinux_name = NULL;
 	struct dso *kernel;
 
-	if (machine__is_host(self)) {
+	if (machine__is_host(machine)) {
 		vmlinux_name = symbol_conf.vmlinux_name;
 		kernel = dso__new_kernel(vmlinux_name);
 	} else {
-		if (machine__is_default_guest(self))
+		if (machine__is_default_guest(machine))
 			vmlinux_name = symbol_conf.default_guest_vmlinux_name;
-		kernel = dso__new_guest_kernel(self, vmlinux_name);
+		kernel = dso__new_guest_kernel(machine, vmlinux_name);
 	}
 
 	if (kernel != NULL) {
-		dso__read_running_kernel_build_id(kernel, self);
-		dsos__add(&self->kernel_dsos, kernel);
+		dso__read_running_kernel_build_id(kernel, machine);
+		dsos__add(&machine->kernel_dsos, kernel);
 	}
 	return kernel;
 }
@@ -2236,41 +2245,43 @@ static u64 machine__get_kernel_start_addr(struct machine *machine)
 	return args.start;
 }
 
-int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
+int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel)
 {
 	enum map_type type;
-	u64 start = machine__get_kernel_start_addr(self);
+	u64 start = machine__get_kernel_start_addr(machine);
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
 
-		self->vmlinux_maps[type] = map__new2(start, kernel, type);
-		if (self->vmlinux_maps[type] == NULL)
+		machine->vmlinux_maps[type] = map__new2(start, kernel, type);
+		if (machine->vmlinux_maps[type] == NULL)
 			return -1;
 
-		self->vmlinux_maps[type]->map_ip =
-			self->vmlinux_maps[type]->unmap_ip = identity__map_ip;
-
-		kmap = map__kmap(self->vmlinux_maps[type]);
-		kmap->kmaps = &self->kmaps;
-		map_groups__insert(&self->kmaps, self->vmlinux_maps[type]);
+		machine->vmlinux_maps[type]->map_ip =
+			machine->vmlinux_maps[type]->unmap_ip =
+				identity__map_ip;
+		kmap = map__kmap(machine->vmlinux_maps[type]);
+		kmap->kmaps = &machine->kmaps;
+		map_groups__insert(&machine->kmaps,
+				   machine->vmlinux_maps[type]);
 	}
 
 	return 0;
 }
 
-void machine__destroy_kernel_maps(struct machine *self)
+void machine__destroy_kernel_maps(struct machine *machine)
 {
 	enum map_type type;
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
 
-		if (self->vmlinux_maps[type] == NULL)
+		if (machine->vmlinux_maps[type] == NULL)
 			continue;
 
-		kmap = map__kmap(self->vmlinux_maps[type]);
-		map_groups__remove(&self->kmaps, self->vmlinux_maps[type]);
+		kmap = map__kmap(machine->vmlinux_maps[type]);
+		map_groups__remove(&machine->kmaps,
+				   machine->vmlinux_maps[type]);
 		if (kmap->ref_reloc_sym) {
 			/*
 			 * ref_reloc_sym is shared among all maps, so free just
@@ -2284,25 +2295,25 @@ void machine__destroy_kernel_maps(struct machine *self)
 			kmap->ref_reloc_sym = NULL;
 		}
 
-		map__delete(self->vmlinux_maps[type]);
-		self->vmlinux_maps[type] = NULL;
+		map__delete(machine->vmlinux_maps[type]);
+		machine->vmlinux_maps[type] = NULL;
 	}
 }
 
-int machine__create_kernel_maps(struct machine *self)
+int machine__create_kernel_maps(struct machine *machine)
 {
-	struct dso *kernel = machine__create_kernel(self);
+	struct dso *kernel = machine__create_kernel(machine);
 
 	if (kernel == NULL ||
-	    __machine__create_kernel_maps(self, kernel) < 0)
+	    __machine__create_kernel_maps(machine, kernel) < 0)
 		return -1;
 
-	if (symbol_conf.use_modules && machine__create_modules(self) < 0)
+	if (symbol_conf.use_modules && machine__create_modules(machine) < 0)
 		pr_debug("Problems creating module maps, continuing anyway...\n");
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
-	map_groups__fixup_end(&self->kmaps);
+	map_groups__fixup_end(&machine->kmaps);
 	return 0;
 }
 
@@ -2366,11 +2377,11 @@ out_fail:
 	return -1;
 }
 
-size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp)
+size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp)
 {
 	int i;
 	size_t printed = 0;
-	struct dso *kdso = self->vmlinux_maps[MAP__FUNCTION]->dso;
+	struct dso *kdso = machine->vmlinux_maps[MAP__FUNCTION]->dso;
 
 	if (kdso->has_build_id) {
 		char filename[PATH_MAX];
@@ -2467,9 +2478,9 @@ void symbol__exit(void)
 	symbol_conf.initialized = false;
 }
 
-int machines__create_kernel_maps(struct rb_root *self, pid_t pid)
+int machines__create_kernel_maps(struct rb_root *machines, pid_t pid)
 {
-	struct machine *machine = machines__findnew(self, pid);
+	struct machine *machine = machines__findnew(machines, pid);
 
 	if (machine == NULL)
 		return -1;
@@ -2520,7 +2531,7 @@ char *strxfrchar(char *s, char from, char to)
 	return s;
 }
 
-int machines__create_guest_kernel_maps(struct rb_root *self)
+int machines__create_guest_kernel_maps(struct rb_root *machines)
 {
 	int ret = 0;
 	struct dirent **namelist = NULL;
@@ -2531,7 +2542,7 @@ int machines__create_guest_kernel_maps(struct rb_root *self)
 	if (symbol_conf.default_guest_vmlinux_name ||
 	    symbol_conf.default_guest_modules ||
 	    symbol_conf.default_guest_kallsyms) {
-		machines__create_kernel_maps(self, DEFAULT_GUEST_KERNEL_ID);
+		machines__create_kernel_maps(machines, DEFAULT_GUEST_KERNEL_ID);
 	}
 
 	if (symbol_conf.guestmount) {
@@ -2552,7 +2563,7 @@ int machines__create_guest_kernel_maps(struct rb_root *self)
 				pr_debug("Can't access file %s\n", path);
 				goto failure;
 			}
-			machines__create_kernel_maps(self, pid);
+			machines__create_kernel_maps(machines, pid);
 		}
 failure:
 		free(namelist);
@@ -2561,23 +2572,23 @@ failure:
 	return ret;
 }
 
-void machines__destroy_guest_kernel_maps(struct rb_root *self)
+void machines__destroy_guest_kernel_maps(struct rb_root *machines)
 {
-	struct rb_node *next = rb_first(self);
+	struct rb_node *next = rb_first(machines);
 
 	while (next) {
 		struct machine *pos = rb_entry(next, struct machine, rb_node);
 
 		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, self);
+		rb_erase(&pos->rb_node, machines);
 		machine__delete(pos);
 	}
 }
 
-int machine__load_kallsyms(struct machine *self, const char *filename,
+int machine__load_kallsyms(struct machine *machine, const char *filename,
 			   enum map_type type, symbol_filter_t filter)
 {
-	struct map *map = self->vmlinux_maps[type];
+	struct map *map = machine->vmlinux_maps[type];
 	int ret = dso__load_kallsyms(map->dso, filename, map, filter);
 
 	if (ret > 0) {
@@ -2587,16 +2598,16 @@ int machine__load_kallsyms(struct machine *self, const char *filename,
 		 * kernel, with modules between them, fixup the end of all
 		 * sections.
 		 */
-		__map_groups__fixup_end(&self->kmaps, type);
+		__map_groups__fixup_end(&machine->kmaps, type);
 	}
 
 	return ret;
 }
 
-int machine__load_vmlinux_path(struct machine *self, enum map_type type,
+int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 			       symbol_filter_t filter)
 {
-	struct map *map = self->vmlinux_maps[type];
+	struct map *map = machine->vmlinux_maps[type];
 	int ret = dso__load_vmlinux_path(map->dso, map, filter);
 
 	if (ret > 0) {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 713b0b4..242de01 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -62,7 +62,7 @@ struct symbol {
 	char		name[0];
 };
 
-void symbol__delete(struct symbol *self);
+void symbol__delete(struct symbol *sym);
 
 struct strlist;
 
@@ -96,9 +96,9 @@ struct symbol_conf {
 
 extern struct symbol_conf symbol_conf;
 
-static inline void *symbol__priv(struct symbol *self)
+static inline void *symbol__priv(struct symbol *sym)
 {
-	return ((void *)self) - symbol_conf.priv_size;
+	return ((void *)sym) - symbol_conf.priv_size;
 }
 
 struct ref_reloc_sym {
@@ -155,43 +155,45 @@ struct dso {
 
 struct dso *dso__new(const char *name);
 struct dso *dso__new_kernel(const char *name);
-void dso__delete(struct dso *self);
+void dso__delete(struct dso *dso);
 
-int dso__name_len(const struct dso *self);
+int dso__name_len(const struct dso *dso);
 
-bool dso__loaded(const struct dso *self, enum map_type type);
-bool dso__sorted_by_name(const struct dso *self, enum map_type type);
+bool dso__loaded(const struct dso *dso, enum map_type type);
+bool dso__sorted_by_name(const struct dso *dso, enum map_type type);
 
-static inline void dso__set_loaded(struct dso *self, enum map_type type)
+static inline void dso__set_loaded(struct dso *dso, enum map_type type)
 {
-	self->loaded |= (1 << type);
+	dso->loaded |= (1 << type);
 }
 
-void dso__sort_by_name(struct dso *self, enum map_type type);
+void dso__sort_by_name(struct dso *dso, enum map_type type);
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
-int dso__load_vmlinux(struct dso *self, struct map *map,
+int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter);
+int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, symbol_filter_t filter);
-int dso__load_vmlinux_path(struct dso *self, struct map *map,
+int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 			   symbol_filter_t filter);
-int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
+int dso__load_kallsyms(struct dso *dso, const char *filename, struct map *map,
 		       symbol_filter_t filter);
-int machine__load_kallsyms(struct machine *self, const char *filename,
+int machine__load_kallsyms(struct machine *machine, const char *filename,
 			   enum map_type type, symbol_filter_t filter);
-int machine__load_vmlinux_path(struct machine *self, enum map_type type,
+int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 			       symbol_filter_t filter);
 
 size_t __dsos__fprintf(struct list_head *head, FILE *fp);
 
-size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits);
-size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
-size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
-
-size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
-size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *fp);
-size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
+size_t machine__fprintf_dsos_buildid(struct machine *machine,
+				     FILE *fp, bool with_hits);
+size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp);
+size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
+				      FILE *fp, bool with_hits);
+size_t dso__fprintf_buildid(struct dso *dso, FILE *fp);
+size_t dso__fprintf_symbols_by_name(struct dso *dso,
+				    enum map_type type, FILE *fp);
+size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp);
 
 enum symtab_type {
 	SYMTAB__KALLSYMS = 0,
@@ -207,34 +209,36 @@ enum symtab_type {
 	SYMTAB__NOT_FOUND,
 };
 
-char dso__symtab_origin(const struct dso *self);
-void dso__set_long_name(struct dso *self, char *name);
-void dso__set_build_id(struct dso *self, void *build_id);
-void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine);
-struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
-struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+char dso__symtab_origin(const struct dso *dso);
+void dso__set_long_name(struct dso *dso, char *name);
+void dso__set_build_id(struct dso *dso, void *build_id);
+void dso__read_running_kernel_build_id(struct dso *dso,
+				       struct machine *machine);
+struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
+				u64 addr);
+struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
-int build_id__sprintf(const u8 *self, int len, char *bf);
+int build_id__sprintf(const u8 *build_id, int len, char *bf);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start, u64 end));
 
-void machine__destroy_kernel_maps(struct machine *self);
-int __machine__create_kernel_maps(struct machine *self, struct dso *kernel);
-int machine__create_kernel_maps(struct machine *self);
+void machine__destroy_kernel_maps(struct machine *machine);
+int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel);
+int machine__create_kernel_maps(struct machine *machine);
 
-int machines__create_kernel_maps(struct rb_root *self, pid_t pid);
-int machines__create_guest_kernel_maps(struct rb_root *self);
-void machines__destroy_guest_kernel_maps(struct rb_root *self);
+int machines__create_kernel_maps(struct rb_root *machines, pid_t pid);
+int machines__create_guest_kernel_maps(struct rb_root *machines);
+void machines__destroy_guest_kernel_maps(struct rb_root *machines);
 
 int symbol__init(void);
 void symbol__exit(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
-size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp);
+size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
 #endif /* __PERF_SYMBOL */
