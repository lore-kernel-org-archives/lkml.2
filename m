Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1GVNiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:38:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56389 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab1GVNiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:38:08 -0400
Date: Fri, 22 Jul 2011 15:36:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf/core changes for v3.1
Message-ID: <20110722133650.GA32658@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
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
Anton Blanchard (1):
      perf report/annotate/script: Add option to specify a CPU range

Arnaldo Carvalho de Melo (3):
      perf evlist: Remove dependency on debug routines
      perf python: Use exception to propagate errors
      perf evlist: Don't die if sample_{id_all|type} is invalid

Avi Kivity (3):
      perf: Add context field to perf_event
      x86, perf: Add constraints for architectural PMU
      perf: export perf_event_refresh() to modules

Cyrill Gorcunov (3):
      perf, x86: Add hw_watchdog_set_attr() in a sake of nmi-watchdog on P4
      perf, x86: P4 PMU - Introduce event alias feature
      x86, perf: P4 PMU - Fix typos in comments and style cleanup

Daniel Kalmar (2):
      MIPS: Add new unwind_stack variant
      MIPS: oprofile: Add callgraph support

David Ahern (6):
      perf stat: clarify unsupported events from uncounted events
      perf script: "sym" field really means show IP data
      perf script: Make printing of dso a separate field option
      perf script: Add printing of sample address
      perf tools: Fix endian conversion reading event attr from file header
      perf script: Fix display of IP address for non-callchain path

Eric B Munson (3):
      events: Add note to update_event_times comment about holding ctx->lock
      events: Move lockless timer calculation into helper function
      events: Ensure that timers are updated without requiring read() call

Frederic Weisbecker (14):
      perf python: Fix argument name list of read_on_cpu()
      perf python: Cleanup useless double NULL termination in method arg names
      perf: Split up buffer handling from core code
      perf tools: Make sort operations static
      perf tools: Remove sort print helpers declarations
      perf tools: Don't display ignored entries on stdio ui
      perf tools: Allow sort dimensions to be registered more than once
      perf tools: Only display parent field if explictly sorted
      x86: Save stack pointer in perf live regs savings
      x86: Fetch stack from regs when possible in dump_trace()
      x86,64: Simplify save_regs()
      x86,64: Separate arg1 from rbp handling in SAVE_REGS_IRQ
      x86: Remove useless unwinder backlink from irq regs saving
      x86: Don't use frame pointer to save old stack on irq entry

Jiri Olsa (9):
      tracing, function_graph: Remove dependency of abstime and duration fields on latency
      tracing, function_graph: Merge overhead and duration display functions
      tracing, function: Fix trace header to follow context-info option
      tracing, function_graph: Remove lock-depth from latency trace
      tracing, function_graph: Add context-info support for function_graph tracer
      perf tools: Add missing 'node' alias to the hw_cache[] array
      perf tools: De-opt the parse_events function
      perf tools: Add automated tests for events parsing
      perf tools: Make test use the preset debugfs path

Lin Ming (1):
      perf: Remove perf_event_attr::type check

Martin Schwidefsky (3):
      ftrace/recordmcount: mcount address adjustment
      ftrace/x86: mcount offset calculation
      ftrace/s390: mcount offset calculation

Masami Hiramatsu (15):
      x86: Swap save_stack_trace_regs parameters
      stack_trace: Add weak save_stack_trace_regs()
      tracing/kprobes: Fix kprobe-tracer to support stack trace
      tracing/kprobes: Rename probe_* to trace_probe_*
      tracing/kprobes: Merge trace probe enable/disable functions
      kprobes: Return -ENOENT if probe point doesn't exist
      tracing/kprobes: Support module init function probing
      tracing/kprobe: Update symbol reference when loading module
      perf probe: Rename DIE_FIND_CB_FOUND to DIE_FIND_CB_END
      perf probe: Move strtailcmp to string.c
      perf probe: Remove redundant dwarf functions
      perf-probe: Move dwarf library routines to dwarf-aux.{c, h}
      perf probe: Introduce debuginfo to encapsulate dwarf information
      perf probe: Add probed module in front of function
      perf probe: Support adding probes on offline kernel modules

Michal Marek (1):
      ftrace/kbuild: Add recordmcount files to force full build

Paul McQuade (2):
      ftrace: Fixed an include coding style issue
      async: Fixed an include coding style issue

Peter Huewe (1):
      tracing: Convert to kstrtoul_from_user

Peter Zijlstra (17):
      perf: Optimize ctx_sched_out()
      perf: Clean up 'ctx' reference counting
      perf: Optimize event scheduling locking
      perf: Remove task_ctx_sched_in()
      perf: Simplify and fix __perf_install_in_context()
      perf: Change and simplify ctx::is_active semantics
      perf: Collect the schedule-in rules in one function
      perf: Change close() semantics for group events
      perf: De-schedule a task context when removing the last event
      perf, core: Fix initial task_ctx/event installation
      irq_work, ppc: Fix up arch hooks
      irq_work, alpha: Fix up arch hooks
      perf: Remove the nmi parameter from the swevent and overflow interface
      perf: Remove the perf_output_begin(.sample) argument
      perf, intel: Try alternative OFFCORE encodings
      perf, arch: Add generic NODE cache events
      perf, powerpc: Fix build borkage

Richard Kennedy (1):
      perf: Remove 64-bit alignment padding from perf_event_context

Robert Richter (2):
      oprofile, x86: Fix nmi-unsafe callgraph support
      x86, perf: Make copy_from_user_nmi() a library function

Sam Liao (1):
      perf tools: Add inverted call graph report support.

Sonny Rao (1):
      perf: Robustify proc and debugfs file recording

Stephane Eranian (3):
      perf_events: Update Intel extra regs shared constraints management
      perf_events: Fix validation of events using an extra reg
      perf_events: Add Intel Sandy Bridge offcore_response low-level support

Steven Rostedt (24):
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
      tracing: Add disable_on_free option
      tracing: Fix bug when reading system filters on module removal
      tracing: Have "enable" file use refcounts like the "filter" file
      ftrace: Fix regression of :mod:module function enabling
      tracing, x86/irq: Do not trace arch_local_{*,irq_*}() functions
      tracing: Still trace filtered irq functions when irq trace is disabled
      ftrace: Do not disable interrupts for modules in mcount update
      ftrace: Fix warning when CONFIG_FUNCTION_TRACER is not defined
      ftrace: Balance records when updating the hash
      ftrace: Update filter when tracing enabled in set_ftrace_filter()
      ftrace: Fix dynamic selftest failure on some archs
      tracing: Have dynamic size event stack traces
      ftrace: Fix regression where ftrace breaks when modules are loaded

Vaibhav Nagarnaik (4):
      tracing: Schedule a delayed work to call wakeup()
      tracing: Use NUMA allocation for per-cpu ring buffer pages
      tracing: Add a proc file to stop tracing and free buffer
      ring-buffer: Set __GFP_NORETRY flag for ring buffer allocating process

Vince Weaver (1):
      perf_events: Fix perf buffer watermark setting

Will Deacon (1):
      perf: Remove the nmi parameter from the oprofile_perf backend

Zhengyu He (1):
      perf stat: Add noise output for csv mode


 Documentation/trace/kprobetrace.txt        |    9 +-
 Makefile                                   |    1 +
 arch/alpha/kernel/perf_event.c             |    2 +-
 arch/alpha/kernel/time.c                   |    2 +-
 arch/arm/kernel/perf_event_v6.c            |   30 +-
 arch/arm/kernel/perf_event_v7.c            |   30 +-
 arch/arm/kernel/perf_event_xscale.c        |   18 +-
 arch/arm/kernel/ptrace.c                   |    5 +-
 arch/arm/kernel/swp_emulate.c              |    2 +-
 arch/arm/mm/fault.c                        |    6 +-
 arch/mips/include/asm/stacktrace.h         |    4 +
 arch/mips/kernel/perf_event.c              |    2 +-
 arch/mips/kernel/perf_event_mipsxx.c       |   28 +
 arch/mips/kernel/process.c                 |   19 +-
 arch/mips/kernel/traps.c                   |    8 +-
 arch/mips/kernel/unaligned.c               |    5 +-
 arch/mips/math-emu/cp1emu.c                |    3 +-
 arch/mips/mm/fault.c                       |    8 +-
 arch/mips/oprofile/Makefile                |    2 +-
 arch/mips/oprofile/backtrace.c             |  175 ++++++
 arch/mips/oprofile/common.c                |    1 +
 arch/mips/oprofile/op_impl.h               |    2 +
 arch/powerpc/include/asm/emulated_ops.h    |    4 +-
 arch/powerpc/include/asm/hw_breakpoint.h   |    2 +-
 arch/powerpc/kernel/e500-pmu.c             |    5 +
 arch/powerpc/kernel/mpc7450-pmu.c          |    5 +
 arch/powerpc/kernel/perf_event.c           |    6 +-
 arch/powerpc/kernel/perf_event_fsl_emb.c   |    6 +-
 arch/powerpc/kernel/power4-pmu.c           |    5 +
 arch/powerpc/kernel/power5+-pmu.c          |    5 +
 arch/powerpc/kernel/power5-pmu.c           |    5 +
 arch/powerpc/kernel/power6-pmu.c           |    5 +
 arch/powerpc/kernel/power7-pmu.c           |    5 +
 arch/powerpc/kernel/ppc970-pmu.c           |    5 +
 arch/powerpc/kernel/ptrace.c               |    4 +-
 arch/powerpc/kernel/time.c                 |    2 +-
 arch/powerpc/mm/fault.c                    |    6 +-
 arch/s390/mm/fault.c                       |    6 +-
 arch/sh/kernel/cpu/sh4/perf_event.c        |   15 +
 arch/sh/kernel/cpu/sh4a/perf_event.c       |   15 +
 arch/sh/kernel/ptrace_32.c                 |    5 +-
 arch/sh/kernel/traps_32.c                  |    2 +-
 arch/sh/kernel/traps_64.c                  |    8 +-
 arch/sh/math-emu/math.c                    |    2 +-
 arch/sh/mm/fault_32.c                      |    6 +-
 arch/sh/mm/tlbflush_64.c                   |    6 +-
 arch/sparc/kernel/perf_event.c             |   44 ++-
 arch/sparc/kernel/unaligned_32.c           |    4 +-
 arch/sparc/kernel/unaligned_64.c           |   12 +-
 arch/sparc/kernel/visemul.c                |    2 +-
 arch/sparc/math-emu/math_32.c              |    2 +-
 arch/sparc/math-emu/math_64.c              |    2 +-
 arch/sparc/mm/fault_32.c                   |    8 +-
 arch/sparc/mm/fault_64.c                   |    8 +-
 arch/x86/include/asm/irqflags.h            |   11 +-
 arch/x86/include/asm/perf_event.h          |    5 +
 arch/x86/include/asm/perf_event_p4.h       |   33 +
 arch/x86/include/asm/uaccess.h             |    3 +
 arch/x86/kernel/cpu/perf_event.c           |  168 ++++--
 arch/x86/kernel/cpu/perf_event_amd.c       |   14 +
 arch/x86/kernel/cpu/perf_event_intel.c     |  385 ++++++++----
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |    4 +-
 arch/x86/kernel/cpu/perf_event_p4.c        |  119 ++++-
 arch/x86/kernel/dumpstack_64.c             |   37 +-
 arch/x86/kernel/entry_64.S                 |   69 +--
 arch/x86/kernel/kgdb.c                     |    4 +-
 arch/x86/kernel/ptrace.c                   |    5 +-
 arch/x86/kernel/stacktrace.c               |    2 +-
 arch/x86/lib/Makefile                      |    2 +-
 arch/x86/lib/usercopy.c                    |   43 ++
 arch/x86/mm/fault.c                        |    6 +-
 arch/x86/mm/kmemcheck/error.c              |    2 +-
 arch/x86/oprofile/backtrace.c              |   21 +-
 drivers/oprofile/oprofile_perf.c           |    4 +-
 include/linux/ftrace.h                     |    7 +-
 include/linux/ftrace_event.h               |    5 +
 include/linux/hw_breakpoint.h              |   10 +-
 include/linux/perf_event.h                 |   81 +--
 include/linux/ring_buffer.h                |    2 +-
 include/linux/stacktrace.h                 |    4 +-
 kernel/async.c                             |   12 +-
 kernel/events/Makefile                     |    2 +-
 kernel/events/core.c                       |  938 ++++++++--------------------
 kernel/events/hw_breakpoint.c              |   10 +-
 kernel/events/internal.h                   |   96 +++
 kernel/events/ring_buffer.c                |  380 +++++++++++
 kernel/kprobes.c                           |   33 +-
 kernel/sched.c                             |    2 +-
 kernel/stacktrace.c                        |   12 +-
 kernel/trace/ftrace.c                      |  157 ++++--
 kernel/trace/ring_buffer.c                 |   66 ++-
 kernel/trace/ring_buffer_benchmark.c       |    2 +-
 kernel/trace/trace.c                       |  326 ++++++----
 kernel/trace/trace.h                       |   61 ++-
 kernel/trace/trace_entries.h               |    3 +-
 kernel/trace/trace_events.c                |  139 +++--
 kernel/trace/trace_events_filter.c         |    6 +
 kernel/trace/trace_functions.c             |    3 +-
 kernel/trace/trace_functions_graph.c       |  225 ++++----
 kernel/trace/trace_irqsoff.c               |    4 +-
 kernel/trace/trace_kprobe.c                |  324 +++++++---
 kernel/trace/trace_output.c                |   11 +-
 kernel/trace/trace_sched_wakeup.c          |    4 +-
 kernel/trace/trace_stack.c                 |   13 +-
 kernel/watchdog.c                          |    8 +-
 samples/hw_breakpoint/data_breakpoint.c    |    4 +-
 tools/perf/Documentation/perf-annotate.txt |    6 +
 tools/perf/Documentation/perf-probe.txt    |    6 +-
 tools/perf/Documentation/perf-report.txt   |   21 +-
 tools/perf/Documentation/perf-script.txt   |   18 +-
 tools/perf/Makefile                        |    2 +
 tools/perf/builtin-annotate.c              |   15 +
 tools/perf/builtin-probe.c                 |    3 +-
 tools/perf/builtin-record.c                |    2 +-
 tools/perf/builtin-report.c                |   57 ++-
 tools/perf/builtin-script.c                |  121 ++++-
 tools/perf/builtin-stat.c                  |   20 +-
 tools/perf/builtin-test.c                  |  249 ++++++++-
 tools/perf/builtin-top.c                   |    2 +-
 tools/perf/util/callchain.h                |    6 +
 tools/perf/util/dwarf-aux.c                |  663 ++++++++++++++++++++
 tools/perf/util/dwarf-aux.h                |  100 +++
 tools/perf/util/evsel.c                    |    1 +
 tools/perf/util/evsel.h                    |    1 +
 tools/perf/util/header.c                   |    5 +-
 tools/perf/util/hist.c                     |    6 +-
 tools/perf/util/parse-events.c             |   39 +-
 tools/perf/util/parse-events.h             |    6 +-
 tools/perf/util/probe-event.c              |  165 ++++--
 tools/perf/util/probe-event.h              |    1 +
 tools/perf/util/probe-finder.c             |  752 +++-------------------
 tools/perf/util/probe-finder.h             |   43 +-
 tools/perf/util/python.c                   |   17 +-
 tools/perf/util/session.c                  |  132 +++-
 tools/perf/util/session.h                  |    9 +-
 tools/perf/util/sort.c                     |  223 +++----
 tools/perf/util/sort.h                     |   14 -
 tools/perf/util/string.c                   |   19 +
 tools/perf/util/trace-event-info.c         |  120 +---
 tools/perf/util/util.h                     |    1 +
 140 files changed, 4650 insertions(+), 2661 deletions(-)
 create mode 100644 arch/mips/oprofile/backtrace.c
 create mode 100644 arch/x86/lib/usercopy.c
 create mode 100644 kernel/events/internal.h
 create mode 100644 kernel/events/ring_buffer.c
 create mode 100644 tools/perf/util/dwarf-aux.c
 create mode 100644 tools/perf/util/dwarf-aux.h

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index c83bd6b..d0d0bb9 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -22,14 +22,15 @@ current_tracer. Instead of that, add probe points via
 
 Synopsis of kprobe_events
 -------------------------
-  p[:[GRP/]EVENT] SYMBOL[+offs]|MEMADDR [FETCHARGS]	: Set a probe
-  r[:[GRP/]EVENT] SYMBOL[+0] [FETCHARGS]		: Set a return probe
+  p[:[GRP/]EVENT] [MOD:]SYM[+offs]|MEMADDR [FETCHARGS]	: Set a probe
+  r[:[GRP/]EVENT] [MOD:]SYM[+0] [FETCHARGS]		: Set a return probe
   -:[GRP/]EVENT						: Clear a probe
 
  GRP		: Group name. If omitted, use "kprobes" for it.
  EVENT		: Event name. If omitted, the event name is generated
-		  based on SYMBOL+offs or MEMADDR.
- SYMBOL[+offs]	: Symbol+offset where the probe is inserted.
+		  based on SYM+offs or MEMADDR.
+ MOD		: Module name which has given SYM.
+ SYM[+offs]	: Symbol+offset where the probe is inserted.
  MEMADDR	: Address where the probe is inserted.
 
  FETCHARGS	: Arguments. Each probe can have up to 128 args.
diff --git a/Makefile b/Makefile
index 6a5bdad..d018956 100644
--- a/Makefile
+++ b/Makefile
@@ -1290,6 +1290,7 @@ help:
 	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
+	@echo  '  make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections'
 	@echo  '  make W=n   [targets] Enable extra gcc checks, n=1,2,3 where'
 	@echo  '		1: warnings which may be relevant and do not occur too often'
 	@echo  '		2: warnings which occur quite often but may still be relevant'
diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index 90561c4..8e47709 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -847,7 +847,7 @@ static void alpha_perf_event_irq_handler(unsigned long la_ptr,
 	data.period = event->hw.last_period;
 
 	if (alpha_perf_event_set_period(event, hwc, idx)) {
-		if (perf_event_overflow(event, 1, &data, regs)) {
+		if (perf_event_overflow(event, &data, regs)) {
 			/* Interrupts coming too quickly; "throttle" the
 			 * counter, i.e., disable it for a little while.
 			 */
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 818e74e..f20d1b5 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -91,7 +91,7 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 #define test_irq_work_pending()      __get_cpu_var(irq_work_pending)
 #define clear_irq_work_pending()     __get_cpu_var(irq_work_pending) = 0
 
-void set_irq_work_pending(void)
+void arch_irq_work_raise(void)
 {
 	set_irq_work_pending_flag();
 }
diff --git a/arch/arm/kernel/perf_event_v6.c b/arch/arm/kernel/perf_event_v6.c
index f1e8dd9..dd7f3b9 100644
--- a/arch/arm/kernel/perf_event_v6.c
+++ b/arch/arm/kernel/perf_event_v6.c
@@ -173,6 +173,20 @@ static const unsigned armv6_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 enum armv6mpcore_perf_types {
@@ -310,6 +324,20 @@ static const unsigned armv6mpcore_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]    = CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]  = CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]    = CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]  = CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]    = CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]  = CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]    = CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 static inline unsigned long
@@ -479,7 +507,7 @@ armv6pmu_handle_irq(int irq_num,
 		if (!armpmu_event_set_period(event, hwc, idx))
 			continue;
 
-		if (perf_event_overflow(event, 0, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			armpmu->disable(hwc, idx);
 	}
 
diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 4960686..e20ca9c 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -255,6 +255,20 @@ static const unsigned armv7_a8_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 /*
@@ -371,6 +385,20 @@ static const unsigned armv7_a9_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 /*
@@ -787,7 +815,7 @@ static irqreturn_t armv7pmu_handle_irq(int irq_num, void *dev)
 		if (!armpmu_event_set_period(event, hwc, idx))
 			continue;
 
-		if (perf_event_overflow(event, 0, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			armpmu->disable(hwc, idx);
 	}
 
diff --git a/arch/arm/kernel/perf_event_xscale.c b/arch/arm/kernel/perf_event_xscale.c
index 39affbe..3c43974 100644
--- a/arch/arm/kernel/perf_event_xscale.c
+++ b/arch/arm/kernel/perf_event_xscale.c
@@ -144,6 +144,20 @@ static const unsigned xscale_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 #define	XSCALE_PMU_ENABLE	0x001
@@ -251,7 +265,7 @@ xscale1pmu_handle_irq(int irq_num, void *dev)
 		if (!armpmu_event_set_period(event, hwc, idx))
 			continue;
 
-		if (perf_event_overflow(event, 0, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			armpmu->disable(hwc, idx);
 	}
 
@@ -583,7 +597,7 @@ xscale2pmu_handle_irq(int irq_num, void *dev)
 		if (!armpmu_event_set_period(event, hwc, idx))
 			continue;
 
-		if (perf_event_overflow(event, 0, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			armpmu->disable(hwc, idx);
 	}
 
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 9726006..5c19961 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -396,7 +396,7 @@ static long ptrace_hbp_idx_to_num(int idx)
 /*
  * Handle hitting a HW-breakpoint.
  */
-static void ptrace_hbptriggered(struct perf_event *bp, int unused,
+static void ptrace_hbptriggered(struct perf_event *bp,
 				     struct perf_sample_data *data,
 				     struct pt_regs *regs)
 {
@@ -479,7 +479,8 @@ static struct perf_event *ptrace_hbp_create(struct task_struct *tsk, int type)
 	attr.bp_type	= type;
 	attr.disabled	= 1;
 
-	return register_user_hw_breakpoint(&attr, ptrace_hbptriggered, tsk);
+	return register_user_hw_breakpoint(&attr, ptrace_hbptriggered, NULL,
+					   tsk);
 }
 
 static int ptrace_gethbpregs(struct task_struct *tsk, long num,
diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
index 40ee7e5..5f452f8 100644
--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -183,7 +183,7 @@ static int swp_handler(struct pt_regs *regs, unsigned int instr)
 	unsigned int address, destreg, data, type;
 	unsigned int res = 0;
 
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, regs->ARM_pc);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, regs->ARM_pc);
 
 	if (current->pid != previous_pid) {
 		pr_debug("\"%s\" (%ld) uses deprecated SWP{B} instruction\n",
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index bc0e1d8..9ea4f7d 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -318,11 +318,11 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	fault = __do_page_fault(mm, addr, fsr, tsk);
 	up_read(&mm->mmap_sem);
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, addr);
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 	if (fault & VM_FAULT_MAJOR)
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0, regs, addr);
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, addr);
 	else if (fault & VM_FAULT_MINOR)
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0, regs, addr);
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, addr);
 
 	/*
 	 * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
diff --git a/arch/mips/include/asm/stacktrace.h b/arch/mips/include/asm/stacktrace.h
index 0bf8281..780ee2c 100644
--- a/arch/mips/include/asm/stacktrace.h
+++ b/arch/mips/include/asm/stacktrace.h
@@ -7,6 +7,10 @@
 extern int raw_show_trace;
 extern unsigned long unwind_stack(struct task_struct *task, unsigned long *sp,
 				  unsigned long pc, unsigned long *ra);
+extern unsigned long unwind_stack_by_address(unsigned long stack_page,
+					     unsigned long *sp,
+					     unsigned long pc,
+					     unsigned long *ra);
 #else
 #define raw_show_trace 1
 static inline unsigned long unwind_stack(struct task_struct *task,
diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index a824485..d0deaab 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -527,7 +527,7 @@ handle_associated_event(struct cpu_hw_events *cpuc,
 	if (!mipspmu_event_set_period(event, hwc, idx))
 		return;
 
-	if (perf_event_overflow(event, 0, data, regs))
+	if (perf_event_overflow(event, data, regs))
 		mipspmu->disable_event(idx);
 }
 
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 75266ff..e5ad09a 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -377,6 +377,20 @@ static const struct mips_perf_event mipsxxcore_cache_map
 		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
 };
 
 /* 74K core has completely different cache event map. */
@@ -480,6 +494,20 @@ static const struct mips_perf_event mipsxx74Kcore_cache_map
 		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
 };
 
 #ifdef CONFIG_MIPS_MT_SMP
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index d2112d3..c28fbe6 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -373,18 +373,18 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 
 
 #ifdef CONFIG_KALLSYMS
-/* used by show_backtrace() */
-unsigned long unwind_stack(struct task_struct *task, unsigned long *sp,
-			   unsigned long pc, unsigned long *ra)
+/* generic stack unwinding function */
+unsigned long notrace unwind_stack_by_address(unsigned long stack_page,
+					      unsigned long *sp,
+					      unsigned long pc,
+					      unsigned long *ra)
 {
-	unsigned long stack_page;
 	struct mips_frame_info info;
 	unsigned long size, ofs;
 	int leaf;
 	extern void ret_from_irq(void);
 	extern void ret_from_exception(void);
 
-	stack_page = (unsigned long)task_stack_page(task);
 	if (!stack_page)
 		return 0;
 
@@ -443,6 +443,15 @@ unsigned long unwind_stack(struct task_struct *task, unsigned long *sp,
 	*ra = 0;
 	return __kernel_text_address(pc) ? pc : 0;
 }
+EXPORT_SYMBOL(unwind_stack_by_address);
+
+/* used by show_backtrace() */
+unsigned long unwind_stack(struct task_struct *task, unsigned long *sp,
+			   unsigned long pc, unsigned long *ra)
+{
+	unsigned long stack_page = (unsigned long)task_stack_page(task);
+	return unwind_stack_by_address(stack_page, sp, pc, ra);
+}
 #endif
 
 /*
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index e9b3af2..b7517e3 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -578,12 +578,12 @@ static int simulate_llsc(struct pt_regs *regs, unsigned int opcode)
 {
 	if ((opcode & OPCODE) == LL) {
 		perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS,
-				1, 0, regs, 0);
+				1, regs, 0);
 		return simulate_ll(regs, opcode);
 	}
 	if ((opcode & OPCODE) == SC) {
 		perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS,
-				1, 0, regs, 0);
+				1, regs, 0);
 		return simulate_sc(regs, opcode);
 	}
 
@@ -602,7 +602,7 @@ static int simulate_rdhwr(struct pt_regs *regs, unsigned int opcode)
 		int rd = (opcode & RD) >> 11;
 		int rt = (opcode & RT) >> 16;
 		perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS,
-				1, 0, regs, 0);
+				1, regs, 0);
 		switch (rd) {
 		case 0:		/* CPU number */
 			regs->regs[rt] = smp_processor_id();
@@ -640,7 +640,7 @@ static int simulate_sync(struct pt_regs *regs, unsigned int opcode)
 {
 	if ((opcode & OPCODE) == SPEC0 && (opcode & FUNC) == SYNC) {
 		perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS,
-				1, 0, regs, 0);
+				1, regs, 0);
 		return 0;
 	}
 
diff --git a/arch/mips/kernel/unaligned.c b/arch/mips/kernel/unaligned.c
index cfea1ad..eb319b5 100644
--- a/arch/mips/kernel/unaligned.c
+++ b/arch/mips/kernel/unaligned.c
@@ -111,8 +111,7 @@ static void emulate_load_store_insn(struct pt_regs *regs,
 	unsigned long value;
 	unsigned int res;
 
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS,
-		      1, 0, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, 0);
 
 	/*
 	 * This load never faults.
@@ -517,7 +516,7 @@ asmlinkage void do_ade(struct pt_regs *regs)
 	mm_segment_t seg;
 
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS,
-			1, 0, regs, regs->cp0_badvaddr);
+			1, regs, regs->cp0_badvaddr);
 	/*
 	 * Did we catch a fault trying to load an instruction?
 	 * Or are we running in MIPS16 mode?
diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index d32cb05..dbf2f93 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -272,8 +272,7 @@ static int cop1Emulate(struct pt_regs *xcp, struct mips_fpu_struct *ctx,
 	}
 
       emul:
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS,
-			1, 0, xcp, 0);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, xcp, 0);
 	MIPS_FPU_EMU_INC_STATS(emulated);
 	switch (MIPSInst_OPCODE(ir)) {
 	case ldc1_op:{
diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index 137ee76..937cf33 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -145,7 +145,7 @@ good_area:
 	 * the fault.
 	 */
 	fault = handle_mm_fault(mm, vma, address, write ? FAULT_FLAG_WRITE : 0);
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -154,12 +154,10 @@ good_area:
 		BUG();
 	}
 	if (fault & VM_FAULT_MAJOR) {
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
-				1, 0, regs, address);
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
 		tsk->maj_flt++;
 	} else {
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
-				1, 0, regs, address);
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
 		tsk->min_flt++;
 	}
 
diff --git a/arch/mips/oprofile/Makefile b/arch/mips/oprofile/Makefile
index 4b9d704..29f2f13 100644
--- a/arch/mips/oprofile/Makefile
+++ b/arch/mips/oprofile/Makefile
@@ -8,7 +8,7 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		oprofilefs.o oprofile_stats.o \
 		timer_int.o )
 
-oprofile-y				:= $(DRIVER_OBJS) common.o
+oprofile-y				:= $(DRIVER_OBJS) common.o backtrace.o
 
 oprofile-$(CONFIG_CPU_MIPS32)		+= op_model_mipsxx.o
 oprofile-$(CONFIG_CPU_MIPS64)		+= op_model_mipsxx.o
diff --git a/arch/mips/oprofile/backtrace.c b/arch/mips/oprofile/backtrace.c
new file mode 100644
index 0000000..6854ed5
--- /dev/null
+++ b/arch/mips/oprofile/backtrace.c
@@ -0,0 +1,175 @@
+#include <linux/oprofile.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+#include <asm/ptrace.h>
+#include <asm/stacktrace.h>
+#include <linux/stacktrace.h>
+#include <linux/kernel.h>
+#include <asm/sections.h>
+#include <asm/inst.h>
+
+struct stackframe {
+	unsigned long sp;
+	unsigned long pc;
+	unsigned long ra;
+};
+
+static inline int get_mem(unsigned long addr, unsigned long *result)
+{
+	unsigned long *address = (unsigned long *) addr;
+	if (!access_ok(VERIFY_READ, addr, sizeof(unsigned long)))
+		return -1;
+	if (__copy_from_user_inatomic(result, address, sizeof(unsigned long)))
+		return -3;
+	return 0;
+}
+
+/*
+ * These two instruction helpers were taken from process.c
+ */
+static inline int is_ra_save_ins(union mips_instruction *ip)
+{
+	/* sw / sd $ra, offset($sp) */
+	return (ip->i_format.opcode == sw_op || ip->i_format.opcode == sd_op)
+		&& ip->i_format.rs == 29 && ip->i_format.rt == 31;
+}
+
+static inline int is_sp_move_ins(union mips_instruction *ip)
+{
+	/* addiu/daddiu sp,sp,-imm */
+	if (ip->i_format.rs != 29 || ip->i_format.rt != 29)
+		return 0;
+	if (ip->i_format.opcode == addiu_op || ip->i_format.opcode == daddiu_op)
+		return 1;
+	return 0;
+}
+
+/*
+ * Looks for specific instructions that mark the end of a function.
+ * This usually means we ran into the code area of the previous function.
+ */
+static inline int is_end_of_function_marker(union mips_instruction *ip)
+{
+	/* jr ra */
+	if (ip->r_format.func == jr_op && ip->r_format.rs == 31)
+		return 1;
+	/* lui gp */
+	if (ip->i_format.opcode == lui_op && ip->i_format.rt == 28)
+		return 1;
+	return 0;
+}
+
+/*
+ * TODO for userspace stack unwinding:
+ * - handle cases where the stack is adjusted inside a function
+ *     (generally doesn't happen)
+ * - find optimal value for max_instr_check
+ * - try to find a way to handle leaf functions
+ */
+
+static inline int unwind_user_frame(struct stackframe *old_frame,
+				    const unsigned int max_instr_check)
+{
+	struct stackframe new_frame = *old_frame;
+	off_t ra_offset = 0;
+	size_t stack_size = 0;
+	unsigned long addr;
+
+	if (old_frame->pc == 0 || old_frame->sp == 0 || old_frame->ra == 0)
+		return -9;
+
+	for (addr = new_frame.pc; (addr + max_instr_check > new_frame.pc)
+		&& (!ra_offset || !stack_size); --addr) {
+		union mips_instruction ip;
+
+		if (get_mem(addr, (unsigned long *) &ip))
+			return -11;
+
+		if (is_sp_move_ins(&ip)) {
+			int stack_adjustment = ip.i_format.simmediate;
+			if (stack_adjustment > 0)
+				/* This marks the end of the previous function,
+				   which means we overran. */
+				break;
+			stack_size = (unsigned) stack_adjustment;
+		} else if (is_ra_save_ins(&ip)) {
+			int ra_slot = ip.i_format.simmediate;
+			if (ra_slot < 0)
+				/* This shouldn't happen. */
+				break;
+			ra_offset = ra_slot;
+		} else if (is_end_of_function_marker(&ip))
+			break;
+	}
+
+	if (!ra_offset || !stack_size)
+		return -1;
+
+	if (ra_offset) {
+		new_frame.ra = old_frame->sp + ra_offset;
+		if (get_mem(new_frame.ra, &(new_frame.ra)))
+			return -13;
+	}
+
+	if (stack_size) {
+		new_frame.sp = old_frame->sp + stack_size;
+		if (get_mem(new_frame.sp, &(new_frame.sp)))
+			return -14;
+	}
+
+	if (new_frame.sp > old_frame->sp)
+		return -2;
+
+	new_frame.pc = old_frame->ra;
+	*old_frame = new_frame;
+
+	return 0;
+}
+
+static inline void do_user_backtrace(unsigned long low_addr,
+				     struct stackframe *frame,
+				     unsigned int depth)
+{
+	const unsigned int max_instr_check = 512;
+	const unsigned long high_addr = low_addr + THREAD_SIZE;
+
+	while (depth-- && !unwind_user_frame(frame, max_instr_check)) {
+		oprofile_add_trace(frame->ra);
+		if (frame->sp < low_addr || frame->sp > high_addr)
+			break;
+	}
+}
+
+#ifndef CONFIG_KALLSYMS
+static inline void do_kernel_backtrace(unsigned long low_addr,
+				       struct stackframe *frame,
+				       unsigned int depth) { }
+#else
+static inline void do_kernel_backtrace(unsigned long low_addr,
+				       struct stackframe *frame,
+				       unsigned int depth)
+{
+	while (depth-- && frame->pc) {
+		frame->pc = unwind_stack_by_address(low_addr,
+						    &(frame->sp),
+						    frame->pc,
+						    &(frame->ra));
+		oprofile_add_trace(frame->ra);
+	}
+}
+#endif
+
+void notrace op_mips_backtrace(struct pt_regs *const regs, unsigned int depth)
+{
+	struct stackframe frame = { .sp = regs->regs[29],
+				    .pc = regs->cp0_epc,
+				    .ra = regs->regs[31] };
+	const int userspace = user_mode(regs);
+	const unsigned long low_addr = ALIGN(frame.sp, THREAD_SIZE);
+
+	if (userspace)
+		do_user_backtrace(low_addr, &frame, depth);
+	else
+		do_kernel_backtrace(low_addr, &frame, depth);
+}
diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
index f9eb1ab..d1f2d4c 100644
--- a/arch/mips/oprofile/common.c
+++ b/arch/mips/oprofile/common.c
@@ -115,6 +115,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	ops->start		= op_mips_start;
 	ops->stop		= op_mips_stop;
 	ops->cpu_type		= lmodel->cpu_type;
+	ops->backtrace		= op_mips_backtrace;
 
 	printk(KERN_INFO "oprofile: using %s performance monitoring.\n",
 	       lmodel->cpu_type);
diff --git a/arch/mips/oprofile/op_impl.h b/arch/mips/oprofile/op_impl.h
index f04b54f..7c2da27 100644
--- a/arch/mips/oprofile/op_impl.h
+++ b/arch/mips/oprofile/op_impl.h
@@ -36,4 +36,6 @@ struct op_mips_model {
 	unsigned char num_counters;
 };
 
+void op_mips_backtrace(struct pt_regs * const regs, unsigned int depth);
+
 #endif
diff --git a/arch/powerpc/include/asm/emulated_ops.h b/arch/powerpc/include/asm/emulated_ops.h
index 4592167..2cc41c7 100644
--- a/arch/powerpc/include/asm/emulated_ops.h
+++ b/arch/powerpc/include/asm/emulated_ops.h
@@ -78,14 +78,14 @@ extern void ppc_warn_emulated_print(const char *type);
 #define PPC_WARN_EMULATED(type, regs)					\
 	do {								\
 		perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS,		\
-			1, 0, regs, 0);					\
+			1, regs, 0);					\
 		__PPC_WARN_EMULATED(type);				\
 	} while (0)
 
 #define PPC_WARN_ALIGNMENT(type, regs)					\
 	do {								\
 		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS,		\
-			1, 0, regs, regs->dar);				\
+			1, regs, regs->dar);				\
 		__PPC_WARN_EMULATED(type);				\
 	} while (0)
 
diff --git a/arch/powerpc/include/asm/hw_breakpoint.h b/arch/powerpc/include/asm/hw_breakpoint.h
index 1c33ec1..80fd4d2 100644
--- a/arch/powerpc/include/asm/hw_breakpoint.h
+++ b/arch/powerpc/include/asm/hw_breakpoint.h
@@ -57,7 +57,7 @@ void hw_breakpoint_pmu_read(struct perf_event *bp);
 extern void flush_ptrace_hw_breakpoint(struct task_struct *tsk);
 
 extern struct pmu perf_ops_bp;
-extern void ptrace_triggered(struct perf_event *bp, int nmi,
+extern void ptrace_triggered(struct perf_event *bp,
 			struct perf_sample_data *data, struct pt_regs *regs);
 static inline void hw_breakpoint_disable(void)
 {
diff --git a/arch/powerpc/kernel/e500-pmu.c b/arch/powerpc/kernel/e500-pmu.c
index b150b51..cb2e294 100644
--- a/arch/powerpc/kernel/e500-pmu.c
+++ b/arch/powerpc/kernel/e500-pmu.c
@@ -75,6 +75,11 @@ static int e500_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1 	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 static int num_events = 128;
diff --git a/arch/powerpc/kernel/mpc7450-pmu.c b/arch/powerpc/kernel/mpc7450-pmu.c
index 2cc5e030..845a584 100644
--- a/arch/powerpc/kernel/mpc7450-pmu.c
+++ b/arch/powerpc/kernel/mpc7450-pmu.c
@@ -388,6 +388,11 @@ static int mpc7450_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 struct power_pmu mpc7450_pmu = {
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 822f630..14967de 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1207,7 +1207,7 @@ struct pmu power_pmu = {
  * here so there is no possibility of being interrupted.
  */
 static void record_and_restart(struct perf_event *event, unsigned long val,
-			       struct pt_regs *regs, int nmi)
+			       struct pt_regs *regs)
 {
 	u64 period = event->hw.sample_period;
 	s64 prev, delta, left;
@@ -1258,7 +1258,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 		if (event->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
 
-		if (perf_event_overflow(event, nmi, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			power_pmu_stop(event, 0);
 	}
 }
@@ -1346,7 +1346,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
 		if ((int)val < 0) {
 			/* event has overflowed */
 			found = 1;
-			record_and_restart(event, val, regs, nmi);
+			record_and_restart(event, val, regs);
 		}
 	}
 
diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index b0dc8f7..0a6d2a9 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -568,7 +568,7 @@ static struct pmu fsl_emb_pmu = {
  * here so there is no possibility of being interrupted.
  */
 static void record_and_restart(struct perf_event *event, unsigned long val,
-			       struct pt_regs *regs, int nmi)
+			       struct pt_regs *regs)
 {
 	u64 period = event->hw.sample_period;
 	s64 prev, delta, left;
@@ -616,7 +616,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 		perf_sample_data_init(&data, 0);
 		data.period = event->hw.last_period;
 
-		if (perf_event_overflow(event, nmi, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			fsl_emb_pmu_stop(event, 0);
 	}
 }
@@ -644,7 +644,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
 			if (event) {
 				/* event has overflowed */
 				found = 1;
-				record_and_restart(event, val, regs, nmi);
+				record_and_restart(event, val, regs);
 			} else {
 				/*
 				 * Disabled counter is negative,
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index ead8b3c..e9dbc2d 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -587,6 +587,11 @@ static int power4_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 static struct power_pmu power4_pmu = {
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index eca0ac5..f58a2bd 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -653,6 +653,11 @@ static int power5p_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1		},
 		[C(OP_PREFETCH)] = {	-1,		-1		},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
 };
 
 static struct power_pmu power5p_pmu = {
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index d5ff0f6..b1acab6 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -595,6 +595,11 @@ static int power5_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1		},
 		[C(OP_PREFETCH)] = {	-1,		-1		},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
 };
 
 static struct power_pmu power5_pmu = {
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index 3160392..b24a3a2 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -516,6 +516,11 @@ static int power6_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1		},
 		[C(OP_PREFETCH)] = {	-1,		-1		},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
 };
 
 static struct power_pmu power6_pmu = {
diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 593740f..6d9dccb 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -342,6 +342,11 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 static struct power_pmu power7_pmu = {
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index 9a6e093..b121de9 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -467,6 +467,11 @@ static int ppc970_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 static struct power_pmu ppc970_pmu = {
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index cb22024..05b7dd2 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -882,7 +882,7 @@ void user_disable_single_step(struct task_struct *task)
 }
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-void ptrace_triggered(struct perf_event *bp, int nmi,
+void ptrace_triggered(struct perf_event *bp,
 		      struct perf_sample_data *data, struct pt_regs *regs)
 {
 	struct perf_event_attr attr;
@@ -973,7 +973,7 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 								&attr.bp_type);
 
 	thread->ptrace_bps[0] = bp = register_user_hw_breakpoint(&attr,
-							ptrace_triggered, task);
+					       ptrace_triggered, NULL, task);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
 		ptrace_put_breakpoints(task);
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index f33acfd..03b29a6 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -544,7 +544,7 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 
 #endif /* 32 vs 64 bit */
 
-void set_irq_work_pending(void)
+void arch_irq_work_raise(void)
 {
 	preempt_disable();
 	set_irq_work_pending_flag();
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index ad35f66..5efe8c9 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -174,7 +174,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 		die("Weird page fault", regs, SIGSEGV);
 	}
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
@@ -320,7 +320,7 @@ good_area:
 	}
 	if (ret & VM_FAULT_MAJOR) {
 		current->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
 				     regs, address);
 #ifdef CONFIG_PPC_SMLPAR
 		if (firmware_has_feature(FW_FEATURE_CMO)) {
@@ -331,7 +331,7 @@ good_area:
 #endif
 	} else {
 		current->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
 				     regs, address);
 	}
 	up_read(&mm->mmap_sem);
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index fe103e8..095f782 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -299,7 +299,7 @@ static inline int do_exception(struct pt_regs *regs, int access,
 		goto out;
 
 	address = trans_exc_code & __FAIL_ADDR_MASK;
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 	flags = FAULT_FLAG_ALLOW_RETRY;
 	if (access == VM_WRITE || (trans_exc_code & store_indication) == 0x400)
 		flags |= FAULT_FLAG_WRITE;
@@ -345,11 +345,11 @@ retry:
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
 		if (fault & VM_FAULT_MAJOR) {
 			tsk->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
 				      regs, address);
 		} else {
 			tsk->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
 				      regs, address);
 		}
 		if (fault & VM_FAULT_RETRY) {
diff --git a/arch/sh/kernel/cpu/sh4/perf_event.c b/arch/sh/kernel/cpu/sh4/perf_event.c
index 748955d..fa4f724 100644
--- a/arch/sh/kernel/cpu/sh4/perf_event.c
+++ b/arch/sh/kernel/cpu/sh4/perf_event.c
@@ -180,6 +180,21 @@ static const int sh7750_cache_events
 			[ C(RESULT_MISS)   ] = -1,
 		},
 	},
+
+	[ C(NODE) ] = {
+		[ C(OP_READ) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+		[ C(OP_WRITE) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+		[ C(OP_PREFETCH) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+	},
 };
 
 static int sh7750_event_map(int event)
diff --git a/arch/sh/kernel/cpu/sh4a/perf_event.c b/arch/sh/kernel/cpu/sh4a/perf_event.c
index 17e6beb..84a2c39 100644
--- a/arch/sh/kernel/cpu/sh4a/perf_event.c
+++ b/arch/sh/kernel/cpu/sh4a/perf_event.c
@@ -205,6 +205,21 @@ static const int sh4a_cache_events
 			[ C(RESULT_MISS)   ] = -1,
 		},
 	},
+
+	[ C(NODE) ] = {
+		[ C(OP_READ) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+		[ C(OP_WRITE) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+		[ C(OP_PREFETCH) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+	},
 };
 
 static int sh4a_event_map(int event)
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 3d7b209..92b3c27 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -63,7 +63,7 @@ static inline int put_stack_long(struct task_struct *task, int offset,
 	return 0;
 }
 
-void ptrace_triggered(struct perf_event *bp, int nmi,
+void ptrace_triggered(struct perf_event *bp,
 		      struct perf_sample_data *data, struct pt_regs *regs)
 {
 	struct perf_event_attr attr;
@@ -91,7 +91,8 @@ static int set_single_step(struct task_struct *tsk, unsigned long addr)
 		attr.bp_len = HW_BREAKPOINT_LEN_2;
 		attr.bp_type = HW_BREAKPOINT_R;
 
-		bp = register_user_hw_breakpoint(&attr, ptrace_triggered, tsk);
+		bp = register_user_hw_breakpoint(&attr, ptrace_triggered,
+						 NULL, tsk);
 		if (IS_ERR(bp))
 			return PTR_ERR(bp);
 
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index b51a171..d9006f8 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -393,7 +393,7 @@ int handle_unaligned_access(insn_size_t instruction, struct pt_regs *regs,
 	 */
 	if (!expected) {
 		unaligned_fixups_notify(current, instruction, regs);
-		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, 0,
+		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1,
 			      regs, address);
 	}
 
diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index 6713ca9..67110be 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -434,7 +434,7 @@ static int misaligned_load(struct pt_regs *regs,
 		return error;
 	}
 
-	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, address);
 
 	destreg = (opcode >> 4) & 0x3f;
 	if (user_mode(regs)) {
@@ -512,7 +512,7 @@ static int misaligned_store(struct pt_regs *regs,
 		return error;
 	}
 
-	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, address);
 
 	srcreg = (opcode >> 4) & 0x3f;
 	if (user_mode(regs)) {
@@ -588,7 +588,7 @@ static int misaligned_fpu_load(struct pt_regs *regs,
 		return error;
 	}
 
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, address);
 
 	destreg = (opcode >> 4) & 0x3f;
 	if (user_mode(regs)) {
@@ -665,7 +665,7 @@ static int misaligned_fpu_store(struct pt_regs *regs,
 		return error;
 	}
 
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, address);
 
 	srcreg = (opcode >> 4) & 0x3f;
 	if (user_mode(regs)) {
diff --git a/arch/sh/math-emu/math.c b/arch/sh/math-emu/math.c
index f76a509..9771952 100644
--- a/arch/sh/math-emu/math.c
+++ b/arch/sh/math-emu/math.c
@@ -620,7 +620,7 @@ int do_fpu_inst(unsigned short inst, struct pt_regs *regs)
 	struct task_struct *tsk = current;
 	struct sh_fpu_soft_struct *fpu = &(tsk->thread.xstate->softfpu);
 
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, 0);
 
 	if (!(task_thread_info(tsk)->status & TS_USEDFPU)) {
 		/* initialize once. */
diff --git a/arch/sh/mm/fault_32.c b/arch/sh/mm/fault_32.c
index d4c34d7..7bebd04 100644
--- a/arch/sh/mm/fault_32.c
+++ b/arch/sh/mm/fault_32.c
@@ -160,7 +160,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	if ((regs->sr & SR_IMASK) != SR_IMASK)
 		local_irq_enable();
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 	/*
 	 * If we're in an interrupt, have no user context or are running
@@ -210,11 +210,11 @@ good_area:
 	}
 	if (fault & VM_FAULT_MAJOR) {
 		tsk->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
 				     regs, address);
 	} else {
 		tsk->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
 				     regs, address);
 	}
 
diff --git a/arch/sh/mm/tlbflush_64.c b/arch/sh/mm/tlbflush_64.c
index 7f5810f..e3430e0 100644
--- a/arch/sh/mm/tlbflush_64.c
+++ b/arch/sh/mm/tlbflush_64.c
@@ -116,7 +116,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long writeaccess,
 	/* Not an IO address, so reenable interrupts */
 	local_irq_enable();
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 	/*
 	 * If we're in an interrupt or have no user
@@ -200,11 +200,11 @@ good_area:
 
 	if (fault & VM_FAULT_MAJOR) {
 		tsk->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
 				     regs, address);
 	} else {
 		tsk->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
 				     regs, address);
 	}
 
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 2cb0e1c..62a0343 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -246,6 +246,20 @@ static const cache_map_t ultra3_cache_map = {
 		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = { CACHE_OP_UNSUPPORTED },
+		[C(RESULT_MISS)  ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+},
 };
 
 static const struct sparc_pmu ultra3_pmu = {
@@ -361,6 +375,20 @@ static const cache_map_t niagara1_cache_map = {
 		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = { CACHE_OP_UNSUPPORTED },
+		[C(RESULT_MISS)  ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+},
 };
 
 static const struct sparc_pmu niagara1_pmu = {
@@ -473,6 +501,20 @@ static const cache_map_t niagara2_cache_map = {
 		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = { CACHE_OP_UNSUPPORTED },
+		[C(RESULT_MISS)  ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+},
 };
 
 static const struct sparc_pmu niagara2_pmu = {
@@ -1277,7 +1319,7 @@ static int __kprobes perf_event_nmi_handler(struct notifier_block *self,
 		if (!sparc_perf_event_set_period(event, hwc, idx))
 			continue;
 
-		if (perf_event_overflow(event, 1, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			sparc_pmu_stop(event, 0);
 	}
 
diff --git a/arch/sparc/kernel/unaligned_32.c b/arch/sparc/kernel/unaligned_32.c
index 4491f4c..7efbb2f 100644
--- a/arch/sparc/kernel/unaligned_32.c
+++ b/arch/sparc/kernel/unaligned_32.c
@@ -247,7 +247,7 @@ asmlinkage void kernel_unaligned_trap(struct pt_regs *regs, unsigned int insn)
 		unsigned long addr = compute_effective_address(regs, insn);
 		int err;
 
-		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, 0, regs, addr);
+		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
 		switch (dir) {
 		case load:
 			err = do_int_load(fetch_reg_addr(((insn>>25)&0x1f),
@@ -338,7 +338,7 @@ asmlinkage void user_unaligned_trap(struct pt_regs *regs, unsigned int insn)
 		}
 
 		addr = compute_effective_address(regs, insn);
-		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, 0, regs, addr);
+		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
 		switch(dir) {
 		case load:
 			err = do_int_load(fetch_reg_addr(((insn>>25)&0x1f),
diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned_64.c
index b2b019e..35cff16 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -317,7 +317,7 @@ asmlinkage void kernel_unaligned_trap(struct pt_regs *regs, unsigned int insn)
 
 		addr = compute_effective_address(regs, insn,
 						 ((insn >> 25) & 0x1f));
-		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, 0, regs, addr);
+		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
 		switch (asi) {
 		case ASI_NL:
 		case ASI_AIUPL:
@@ -384,7 +384,7 @@ int handle_popc(u32 insn, struct pt_regs *regs)
 	int ret, i, rd = ((insn >> 25) & 0x1f);
 	int from_kernel = (regs->tstate & TSTATE_PRIV) != 0;
 	                        
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, 0);
 	if (insn & 0x2000) {
 		maybe_flush_windows(0, 0, rd, from_kernel);
 		value = sign_extend_imm13(insn);
@@ -431,7 +431,7 @@ int handle_ldf_stq(u32 insn, struct pt_regs *regs)
 	int asi = decode_asi(insn, regs);
 	int flag = (freg < 32) ? FPRS_DL : FPRS_DU;
 
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, 0);
 
 	save_and_clear_fpu();
 	current_thread_info()->xfsr[0] &= ~0x1c000;
@@ -554,7 +554,7 @@ void handle_ld_nf(u32 insn, struct pt_regs *regs)
 	int from_kernel = (regs->tstate & TSTATE_PRIV) != 0;
 	unsigned long *reg;
 	                        
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, 0);
 
 	maybe_flush_windows(0, 0, rd, from_kernel);
 	reg = fetch_reg_addr(rd, regs);
@@ -586,7 +586,7 @@ void handle_lddfmna(struct pt_regs *regs, unsigned long sfar, unsigned long sfsr
 
 	if (tstate & TSTATE_PRIV)
 		die_if_kernel("lddfmna from kernel", regs);
-	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, 0, regs, sfar);
+	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, sfar);
 	if (test_thread_flag(TIF_32BIT))
 		pc = (u32)pc;
 	if (get_user(insn, (u32 __user *) pc) != -EFAULT) {
@@ -647,7 +647,7 @@ void handle_stdfmna(struct pt_regs *regs, unsigned long sfar, unsigned long sfsr
 
 	if (tstate & TSTATE_PRIV)
 		die_if_kernel("stdfmna from kernel", regs);
-	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, 0, regs, sfar);
+	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, sfar);
 	if (test_thread_flag(TIF_32BIT))
 		pc = (u32)pc;
 	if (get_user(insn, (u32 __user *) pc) != -EFAULT) {
diff --git a/arch/sparc/kernel/visemul.c b/arch/sparc/kernel/visemul.c
index 3635771..32b626c 100644
--- a/arch/sparc/kernel/visemul.c
+++ b/arch/sparc/kernel/visemul.c
@@ -802,7 +802,7 @@ int vis_emul(struct pt_regs *regs, unsigned int insn)
 
 	BUG_ON(regs->tstate & TSTATE_PRIV);
 
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, 0);
 
 	if (test_thread_flag(TIF_32BIT))
 		pc = (u32)pc;
diff --git a/arch/sparc/math-emu/math_32.c b/arch/sparc/math-emu/math_32.c
index a3fccde..aa4d55b 100644
--- a/arch/sparc/math-emu/math_32.c
+++ b/arch/sparc/math-emu/math_32.c
@@ -164,7 +164,7 @@ int do_mathemu(struct pt_regs *regs, struct task_struct *fpt)
 	int retcode = 0;                               /* assume all succeed */
 	unsigned long insn;
 
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, 0);
 
 #ifdef DEBUG_MATHEMU
 	printk("In do_mathemu()... pc is %08lx\n", regs->pc);
diff --git a/arch/sparc/math-emu/math_64.c b/arch/sparc/math-emu/math_64.c
index 56d2c44..e575bd2 100644
--- a/arch/sparc/math-emu/math_64.c
+++ b/arch/sparc/math-emu/math_64.c
@@ -184,7 +184,7 @@ int do_mathemu(struct pt_regs *regs, struct fpustate *f)
 
 	if (tstate & TSTATE_PRIV)
 		die_if_kernel("unfinished/unimplemented FPop from kernel", regs);
-	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, 0);
 	if (test_thread_flag(TIF_32BIT))
 		pc = (u32)pc;
 	if (get_user(insn, (u32 __user *) pc) != -EFAULT) {
diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
index 7543ddb..aa1c1b1 100644
--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -251,7 +251,7 @@ asmlinkage void do_sparc_fault(struct pt_regs *regs, int text_fault, int write,
         if (in_atomic() || !mm)
                 goto no_context;
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 	down_read(&mm->mmap_sem);
 
@@ -301,12 +301,10 @@ good_area:
 	}
 	if (fault & VM_FAULT_MAJOR) {
 		current->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
-			      regs, address);
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
 	} else {
 		current->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
-			      regs, address);
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
 	}
 	up_read(&mm->mmap_sem);
 	return;
diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index f92ce56..504c062 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -325,7 +325,7 @@ asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
 	if (in_atomic() || !mm)
 		goto intr_or_no_mm;
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 	if (!down_read_trylock(&mm->mmap_sem)) {
 		if ((regs->tstate & TSTATE_PRIV) &&
@@ -433,12 +433,10 @@ good_area:
 	}
 	if (fault & VM_FAULT_MAJOR) {
 		current->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
-			      regs, address);
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
 	} else {
 		current->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
-			      regs, address);
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
 	}
 	up_read(&mm->mmap_sem);
 
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 5745ce8..bba3cf8 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -60,23 +60,24 @@ static inline void native_halt(void)
 #include <asm/paravirt.h>
 #else
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	return native_save_fl();
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	native_restore_fl(flags);
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	native_irq_disable();
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	native_irq_enable();
 }
@@ -102,7 +103,7 @@ static inline void halt(void)
 /*
  * For spinlocks, etc:
  */
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags = arch_local_save_flags();
 	arch_local_irq_disable();
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index d9d4dae..094fb30 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -152,6 +152,11 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 	(regs)->bp = caller_frame_pointer();			\
 	(regs)->cs = __KERNEL_CS;				\
 	regs->flags = 0;					\
+	asm volatile(						\
+		_ASM_MOV "%%"_ASM_SP ", %0\n"			\
+		: "=m" ((regs)->sp)				\
+		:: "memory"					\
+	);							\
 }
 
 #else
diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 56fd9e3..4f7e67e 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -102,6 +102,14 @@
 #define P4_CONFIG_HT			(1ULL << P4_CONFIG_HT_SHIFT)
 
 /*
+ * If an event has alias it should be marked
+ * with a special bit. (Don't forget to check
+ * P4_PEBS_CONFIG_MASK and related bits on
+ * modification.)
+ */
+#define P4_CONFIG_ALIASABLE		(1 << 9)
+
+/*
  * The bits we allow to pass for RAW events
  */
 #define P4_CONFIG_MASK_ESCR		\
@@ -123,6 +131,31 @@
 	(p4_config_pack_escr(P4_CONFIG_MASK_ESCR))	| \
 	(p4_config_pack_cccr(P4_CONFIG_MASK_CCCR))
 
+/*
+ * In case of event aliasing we need to preserve some
+ * caller bits, otherwise the mapping won't be complete.
+ */
+#define P4_CONFIG_EVENT_ALIAS_MASK			  \
+	(p4_config_pack_escr(P4_CONFIG_MASK_ESCR)	| \
+	 p4_config_pack_cccr(P4_CCCR_EDGE		| \
+			     P4_CCCR_THRESHOLD_MASK	| \
+			     P4_CCCR_COMPLEMENT		| \
+			     P4_CCCR_COMPARE))
+
+#define  P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS		  \
+	((P4_CONFIG_HT)					| \
+	 p4_config_pack_escr(P4_ESCR_T0_OS		| \
+			     P4_ESCR_T0_USR		| \
+			     P4_ESCR_T1_OS		| \
+			     P4_ESCR_T1_USR)		| \
+	 p4_config_pack_cccr(P4_CCCR_OVF		| \
+			     P4_CCCR_CASCADE		| \
+			     P4_CCCR_FORCE_OVF		| \
+			     P4_CCCR_THREAD_ANY		| \
+			     P4_CCCR_OVF_PMI_T0		| \
+			     P4_CCCR_OVF_PMI_T1		| \
+			     P4_CONFIG_ALIASABLE))
+
 static inline bool p4_is_event_cascaded(u64 config)
 {
 	u32 cccr = p4_config_unpack_cccr(config);
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 99ddd14..36361bf 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -555,6 +555,9 @@ struct __large_struct { unsigned long buf[100]; };
 
 #endif /* CONFIG_X86_WP_WORKS_OK */
 
+extern unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3a0338b..4ee3abf 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -22,7 +22,6 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
-#include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
 
@@ -45,38 +44,27 @@ do {								\
 #endif
 
 /*
- * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
+ *          |   NHM/WSM    |      SNB     |
+ * register -------------------------------
+ *          |  HT  | no HT |  HT  | no HT |
+ *-----------------------------------------
+ * offcore  | core | core  | cpu  | core  |
+ * lbr_sel  | core | core  | cpu  | core  |
+ * ld_lat   | cpu  | core  | cpu  | core  |
+ *-----------------------------------------
+ *
+ * Given that there is a small number of shared regs,
+ * we can pre-allocate their slot in the per-cpu
+ * per-core reg tables.
  */
-static unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
-{
-	unsigned long offset, addr = (unsigned long)from;
-	unsigned long size, len = 0;
-	struct page *page;
-	void *map;
-	int ret;
-
-	do {
-		ret = __get_user_pages_fast(addr, 1, 0, &page);
-		if (!ret)
-			break;
-
-		offset = addr & (PAGE_SIZE - 1);
-		size = min(PAGE_SIZE - offset, n - len);
-
-		map = kmap_atomic(page);
-		memcpy(to, map+offset, size);
-		kunmap_atomic(map);
-		put_page(page);
+enum extra_reg_type {
+	EXTRA_REG_NONE  = -1,	/* not used */
 
-		len  += size;
-		to   += size;
-		addr += size;
+	EXTRA_REG_RSP_0 = 0,	/* offcore_response_0 */
+	EXTRA_REG_RSP_1 = 1,	/* offcore_response_1 */
 
-	} while (len < n);
-
-	return len;
-}
+	EXTRA_REG_MAX		/* number of entries needed */
+};
 
 struct event_constraint {
 	union {
@@ -132,11 +120,10 @@ struct cpu_hw_events {
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 
 	/*
-	 * Intel percore register state.
-	 * Coordinate shared resources between HT threads.
+	 * manage shared (per-core, per-cpu) registers
+	 * used on Intel NHM/WSM/SNB
 	 */
-	int				percore_used; /* Used by this CPU? */
-	struct intel_percore		*per_core;
+	struct intel_shared_regs	*shared_regs;
 
 	/*
 	 * AMD specific bits
@@ -187,26 +174,45 @@ struct cpu_hw_events {
 	for ((e) = (c); (e)->weight; (e)++)
 
 /*
+ * Per register state.
+ */
+struct er_account {
+	raw_spinlock_t		lock;	/* per-core: protect structure */
+	u64			config;	/* extra MSR config */
+	u64			reg;	/* extra MSR number */
+	atomic_t		ref;	/* reference count */
+};
+
+/*
  * Extra registers for specific events.
+ *
  * Some events need large masks and require external MSRs.
- * Define a mapping to these extra registers.
+ * Those extra MSRs end up being shared for all events on
+ * a PMU and sometimes between PMU of sibling HT threads.
+ * In either case, the kernel needs to handle conflicting
+ * accesses to those extra, shared, regs. The data structure
+ * to manage those registers is stored in cpu_hw_event.
  */
 struct extra_reg {
 	unsigned int		event;
 	unsigned int		msr;
 	u64			config_mask;
 	u64			valid_mask;
+	int			idx;  /* per_xxx->regs[] reg index */
 };
 
-#define EVENT_EXTRA_REG(e, ms, m, vm) {	\
+#define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
 	.event = (e),		\
 	.msr = (ms),		\
 	.config_mask = (m),	\
 	.valid_mask = (vm),	\
+	.idx = EXTRA_REG_##i	\
 	}
-#define INTEL_EVENT_EXTRA_REG(event, msr, vm)	\
-	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm)
-#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0)
+
+#define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
+
+#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
 
 union perf_capabilities {
 	struct {
@@ -252,7 +258,6 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
-	struct event_constraint *percore_constraints;
 	void		(*quirks)(void);
 	int		perfctr_second_write;
 
@@ -286,8 +291,12 @@ struct x86_pmu {
 	 * Extra registers for events
 	 */
 	struct extra_reg *extra_regs;
+	unsigned int er_flags;
 };
 
+#define ERF_NO_HT_SHARING	1
+#define ERF_HAS_RSP_1		2
+
 static struct x86_pmu x86_pmu __read_mostly;
 
 static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
@@ -393,10 +402,10 @@ static inline unsigned int x86_pmu_event_addr(int index)
  */
 static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 {
+	struct hw_perf_event_extra *reg;
 	struct extra_reg *er;
 
-	event->hw.extra_reg = 0;
-	event->hw.extra_config = 0;
+	reg = &event->hw.extra_reg;
 
 	if (!x86_pmu.extra_regs)
 		return 0;
@@ -406,8 +415,10 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
-		event->hw.extra_reg = er->msr;
-		event->hw.extra_config = event->attr.config1;
+
+		reg->idx = er->idx;
+		reg->config = event->attr.config1;
+		reg->reg = er->msr;
 		break;
 	}
 	return 0;
@@ -706,6 +717,9 @@ static int __x86_pmu_event_init(struct perf_event *event)
 	event->hw.last_cpu = -1;
 	event->hw.last_tag = ~0ULL;
 
+	/* mark unused */
+	event->hw.extra_reg.idx = EXTRA_REG_NONE;
+
 	return x86_pmu.hw_config(event);
 }
 
@@ -747,8 +761,8 @@ static void x86_pmu_disable(struct pmu *pmu)
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 					  u64 enable_mask)
 {
-	if (hwc->extra_reg)
-		wrmsrl(hwc->extra_reg, hwc->extra_config);
+	if (hwc->extra_reg.reg)
+		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
 	wrmsrl(hwc->config_base, hwc->config | enable_mask);
 }
 
@@ -1332,7 +1346,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_event_set_period(event))
 			continue;
 
-		if (perf_event_overflow(event, 1, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			x86_pmu_stop(event, 0);
 	}
 
@@ -1637,6 +1651,40 @@ static int x86_pmu_commit_txn(struct pmu *pmu)
 	perf_pmu_enable(pmu);
 	return 0;
 }
+/*
+ * a fake_cpuc is used to validate event groups. Due to
+ * the extra reg logic, we need to also allocate a fake
+ * per_core and per_cpu structure. Otherwise, group events
+ * using extra reg may conflict without the kernel being
+ * able to catch this when the last event gets added to
+ * the group.
+ */
+static void free_fake_cpuc(struct cpu_hw_events *cpuc)
+{
+	kfree(cpuc->shared_regs);
+	kfree(cpuc);
+}
+
+static struct cpu_hw_events *allocate_fake_cpuc(void)
+{
+	struct cpu_hw_events *cpuc;
+	int cpu = raw_smp_processor_id();
+
+	cpuc = kzalloc(sizeof(*cpuc), GFP_KERNEL);
+	if (!cpuc)
+		return ERR_PTR(-ENOMEM);
+
+	/* only needed, if we have extra_regs */
+	if (x86_pmu.extra_regs) {
+		cpuc->shared_regs = allocate_shared_regs(cpu);
+		if (!cpuc->shared_regs)
+			goto error;
+	}
+	return cpuc;
+error:
+	free_fake_cpuc(cpuc);
+	return ERR_PTR(-ENOMEM);
+}
 
 /*
  * validate that we can schedule this event
@@ -1647,9 +1695,9 @@ static int validate_event(struct perf_event *event)
 	struct event_constraint *c;
 	int ret = 0;
 
-	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
-	if (!fake_cpuc)
-		return -ENOMEM;
+	fake_cpuc = allocate_fake_cpuc();
+	if (IS_ERR(fake_cpuc))
+		return PTR_ERR(fake_cpuc);
 
 	c = x86_pmu.get_event_constraints(fake_cpuc, event);
 
@@ -1659,7 +1707,7 @@ static int validate_event(struct perf_event *event)
 	if (x86_pmu.put_event_constraints)
 		x86_pmu.put_event_constraints(fake_cpuc, event);
 
-	kfree(fake_cpuc);
+	free_fake_cpuc(fake_cpuc);
 
 	return ret;
 }
@@ -1679,36 +1727,32 @@ static int validate_group(struct perf_event *event)
 {
 	struct perf_event *leader = event->group_leader;
 	struct cpu_hw_events *fake_cpuc;
-	int ret, n;
-
-	ret = -ENOMEM;
-	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
-	if (!fake_cpuc)
-		goto out;
+	int ret = -ENOSPC, n;
 
+	fake_cpuc = allocate_fake_cpuc();
+	if (IS_ERR(fake_cpuc))
+		return PTR_ERR(fake_cpuc);
 	/*
 	 * the event is not yet connected with its
 	 * siblings therefore we must first collect
 	 * existing siblings, then add the new event
 	 * before we can simulate the scheduling
 	 */
-	ret = -ENOSPC;
 	n = collect_events(fake_cpuc, leader, true);
 	if (n < 0)
-		goto out_free;
+		goto out;
 
 	fake_cpuc->n_events = n;
 	n = collect_events(fake_cpuc, event, false);
 	if (n < 0)
-		goto out_free;
+		goto out;
 
 	fake_cpuc->n_events = n;
 
 	ret = x86_pmu.schedule_events(fake_cpuc, n, NULL);
 
-out_free:
-	kfree(fake_cpuc);
 out:
+	free_fake_cpuc(fake_cpuc);
 	return ret;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index fe29c1d..941caa2 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -89,6 +89,20 @@ static __initconst const u64 amd_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0xb8e9, /* CPU Request to Memory, l+r */
+		[ C(RESULT_MISS)   ] = 0x98e9, /* CPU Request to Memory, r   */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
 };
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 41178c8..45fbb8f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1,25 +1,15 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
-#define MAX_EXTRA_REGS 2
-
-/*
- * Per register state.
- */
-struct er_account {
-	int			ref;		/* reference count */
-	unsigned int		extra_reg;	/* extra MSR number */
-	u64			extra_config;	/* extra MSR config */
-};
-
 /*
- * Per core state
- * This used to coordinate shared registers for HT threads.
+ * Per core/cpu state
+ *
+ * Used to coordinate shared registers between HT threads or
+ * among events on a single PMU.
  */
-struct intel_percore {
-	raw_spinlock_t		lock;		/* protect structure */
-	struct er_account	regs[MAX_EXTRA_REGS];
-	int			refcnt;		/* number of threads */
-	unsigned		core_id;
+struct intel_shared_regs {
+	struct er_account       regs[EXTRA_REG_MAX];
+	int                     refcnt;		/* per-core: #HT threads */
+	unsigned                core_id;	/* per-core: core id */
 };
 
 /*
@@ -88,16 +78,10 @@ static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
 
 static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
 {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
 	EVENT_EXTRA_END
 };
 
-static struct event_constraint intel_nehalem_percore_constraints[] __read_mostly =
-{
-	INTEL_EVENT_CONSTRAINT(0xb7, 0),
-	EVENT_CONSTRAINT_END
-};
-
 static struct event_constraint intel_westmere_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
@@ -116,8 +100,6 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
 	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
-	INTEL_EVENT_CONSTRAINT(0xb7, 0x1), /* OFF_CORE_RESPONSE_0 */
-	INTEL_EVENT_CONSTRAINT(0xbb, 0x8), /* OFF_CORE_RESPONSE_1 */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
 	EVENT_CONSTRAINT_END
@@ -125,15 +107,13 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 
 static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
-	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff),
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
 	EVENT_EXTRA_END
 };
 
-static struct event_constraint intel_westmere_percore_constraints[] __read_mostly =
+static struct event_constraint intel_v1_event_constraints[] __read_mostly =
 {
-	INTEL_EVENT_CONSTRAINT(0xb7, 0),
-	INTEL_EVENT_CONSTRAINT(0xbb, 0),
 	EVENT_CONSTRAINT_END
 };
 
@@ -145,6 +125,12 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
+	EVENT_EXTRA_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -245,6 +231,21 @@ static __initconst const u64 snb_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+
 };
 
 static __initconst const u64 westmere_hw_cache_event_ids
@@ -346,6 +347,20 @@ static __initconst const u64 westmere_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+ },
 };
 
 /*
@@ -398,7 +413,21 @@ static __initconst const u64 nehalem_hw_cache_extra_regs
 		[ C(RESULT_ACCESS) ] = NHM_DMND_PREFETCH|NHM_L3_ACCESS,
 		[ C(RESULT_MISS)   ] = NHM_DMND_PREFETCH|NHM_L3_MISS,
 	},
- }
+ },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = NHM_DMND_READ|NHM_ALL_DRAM,
+		[ C(RESULT_MISS)   ] = NHM_DMND_READ|NHM_REMOTE_DRAM,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = NHM_DMND_WRITE|NHM_ALL_DRAM,
+		[ C(RESULT_MISS)   ] = NHM_DMND_WRITE|NHM_REMOTE_DRAM,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = NHM_DMND_PREFETCH|NHM_ALL_DRAM,
+		[ C(RESULT_MISS)   ] = NHM_DMND_PREFETCH|NHM_REMOTE_DRAM,
+	},
+ },
 };
 
 static __initconst const u64 nehalem_hw_cache_event_ids
@@ -500,6 +529,20 @@ static __initconst const u64 nehalem_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+ },
 };
 
 static __initconst const u64 core2_hw_cache_event_ids
@@ -1003,7 +1046,7 @@ again:
 
 		data.period = event->hw.last_period;
 
-		if (perf_event_overflow(event, 1, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			x86_pmu_stop(event, 0);
 	}
 
@@ -1037,65 +1080,121 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
+static bool intel_try_alt_er(struct perf_event *event, int orig_idx)
+{
+	if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
+		return false;
+
+	if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
+		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
+		event->hw.config |= 0x01bb;
+		event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
+		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
+	} else if (event->hw.extra_reg.idx == EXTRA_REG_RSP_1) {
+		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
+		event->hw.config |= 0x01b7;
+		event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
+		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
+	}
+
+	if (event->hw.extra_reg.idx == orig_idx)
+		return false;
+
+	return true;
+}
+
+/*
+ * manage allocation of shared extra msr for certain events
+ *
+ * sharing can be:
+ * per-cpu: to be shared between the various events on a single PMU
+ * per-core: per-cpu + shared by HT threads
+ */
 static struct event_constraint *
-intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+__intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
+				   struct perf_event *event)
 {
-	struct hw_perf_event *hwc = &event->hw;
-	unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
-	struct event_constraint *c;
-	struct intel_percore *pc;
+	struct event_constraint *c = &emptyconstraint;
+	struct hw_perf_event_extra *reg = &event->hw.extra_reg;
 	struct er_account *era;
-	int i;
-	int free_slot;
-	int found;
+	unsigned long flags;
+	int orig_idx = reg->idx;
 
-	if (!x86_pmu.percore_constraints || hwc->extra_alloc)
-		return NULL;
+	/* already allocated shared msr */
+	if (reg->alloc)
+		return &unconstrained;
 
-	for (c = x86_pmu.percore_constraints; c->cmask; c++) {
-		if (e != c->code)
-			continue;
+again:
+	era = &cpuc->shared_regs->regs[reg->idx];
+	/*
+	 * we use spin_lock_irqsave() to avoid lockdep issues when
+	 * passing a fake cpuc
+	 */
+	raw_spin_lock_irqsave(&era->lock, flags);
+
+	if (!atomic_read(&era->ref) || era->config == reg->config) {
+
+		/* lock in msr value */
+		era->config = reg->config;
+		era->reg = reg->reg;
+
+		/* one more user */
+		atomic_inc(&era->ref);
+
+		/* no need to reallocate during incremental event scheduling */
+		reg->alloc = 1;
 
 		/*
-		 * Allocate resource per core.
+		 * All events using extra_reg are unconstrained.
+		 * Avoids calling x86_get_event_constraints()
+		 *
+		 * Must revisit if extra_reg controlling events
+		 * ever have constraints. Worst case we go through
+		 * the regular event constraint table.
 		 */
-		pc = cpuc->per_core;
-		if (!pc)
-			break;
-		c = &emptyconstraint;
-		raw_spin_lock(&pc->lock);
-		free_slot = -1;
-		found = 0;
-		for (i = 0; i < MAX_EXTRA_REGS; i++) {
-			era = &pc->regs[i];
-			if (era->ref > 0 && hwc->extra_reg == era->extra_reg) {
-				/* Allow sharing same config */
-				if (hwc->extra_config == era->extra_config) {
-					era->ref++;
-					cpuc->percore_used = 1;
-					hwc->extra_alloc = 1;
-					c = NULL;
-				}
-				/* else conflict */
-				found = 1;
-				break;
-			} else if (era->ref == 0 && free_slot == -1)
-				free_slot = i;
-		}
-		if (!found && free_slot != -1) {
-			era = &pc->regs[free_slot];
-			era->ref = 1;
-			era->extra_reg = hwc->extra_reg;
-			era->extra_config = hwc->extra_config;
-			cpuc->percore_used = 1;
-			hwc->extra_alloc = 1;
-			c = NULL;
-		}
-		raw_spin_unlock(&pc->lock);
-		return c;
+		c = &unconstrained;
+	} else if (intel_try_alt_er(event, orig_idx)) {
+		raw_spin_unlock(&era->lock);
+		goto again;
 	}
+	raw_spin_unlock_irqrestore(&era->lock, flags);
 
-	return NULL;
+	return c;
+}
+
+static void
+__intel_shared_reg_put_constraints(struct cpu_hw_events *cpuc,
+				   struct hw_perf_event_extra *reg)
+{
+	struct er_account *era;
+
+	/*
+	 * only put constraint if extra reg was actually
+	 * allocated. Also takes care of event which do
+	 * not use an extra shared reg
+	 */
+	if (!reg->alloc)
+		return;
+
+	era = &cpuc->shared_regs->regs[reg->idx];
+
+	/* one fewer user */
+	atomic_dec(&era->ref);
+
+	/* allocate again next time */
+	reg->alloc = 0;
+}
+
+static struct event_constraint *
+intel_shared_regs_constraints(struct cpu_hw_events *cpuc,
+			      struct perf_event *event)
+{
+	struct event_constraint *c = NULL;
+
+	if (event->hw.extra_reg.idx != EXTRA_REG_NONE)
+		c = __intel_shared_reg_get_constraints(cpuc, event);
+
+	return c;
 }
 
 static struct event_constraint *
@@ -1111,49 +1210,28 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
 	if (c)
 		return c;
 
-	c = intel_percore_constraints(cpuc, event);
+	c = intel_shared_regs_constraints(cpuc, event);
 	if (c)
 		return c;
 
 	return x86_get_event_constraints(cpuc, event);
 }
 
-static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
+static void
+intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
-	struct extra_reg *er;
-	struct intel_percore *pc;
-	struct er_account *era;
-	struct hw_perf_event *hwc = &event->hw;
-	int i, allref;
+	struct hw_perf_event_extra *reg;
 
-	if (!cpuc->percore_used)
-		return;
-
-	for (er = x86_pmu.extra_regs; er->msr; er++) {
-		if (er->event != (hwc->config & er->config_mask))
-			continue;
+	reg = &event->hw.extra_reg;
+	if (reg->idx != EXTRA_REG_NONE)
+		__intel_shared_reg_put_constraints(cpuc, reg);
+}
 
-		pc = cpuc->per_core;
-		raw_spin_lock(&pc->lock);
-		for (i = 0; i < MAX_EXTRA_REGS; i++) {
-			era = &pc->regs[i];
-			if (era->ref > 0 &&
-			    era->extra_config == hwc->extra_config &&
-			    era->extra_reg == er->msr) {
-				era->ref--;
-				hwc->extra_alloc = 0;
-				break;
-			}
-		}
-		allref = 0;
-		for (i = 0; i < MAX_EXTRA_REGS; i++)
-			allref += pc->regs[i].ref;
-		if (allref == 0)
-			cpuc->percore_used = 0;
-		raw_spin_unlock(&pc->lock);
-		break;
-	}
+static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
+					struct perf_event *event)
+{
+	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
 static int intel_pmu_hw_config(struct perf_event *event)
@@ -1231,20 +1309,36 @@ static __initconst const struct x86_pmu core_pmu = {
 	.event_constraints	= intel_core_event_constraints,
 };
 
+static struct intel_shared_regs *allocate_shared_regs(int cpu)
+{
+	struct intel_shared_regs *regs;
+	int i;
+
+	regs = kzalloc_node(sizeof(struct intel_shared_regs),
+			    GFP_KERNEL, cpu_to_node(cpu));
+	if (regs) {
+		/*
+		 * initialize the locks to keep lockdep happy
+		 */
+		for (i = 0; i < EXTRA_REG_MAX; i++)
+			raw_spin_lock_init(&regs->regs[i].lock);
+
+		regs->core_id = -1;
+	}
+	return regs;
+}
+
 static int intel_pmu_cpu_prepare(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 
-	if (!cpu_has_ht_siblings())
+	if (!x86_pmu.extra_regs)
 		return NOTIFY_OK;
 
-	cpuc->per_core = kzalloc_node(sizeof(struct intel_percore),
-				      GFP_KERNEL, cpu_to_node(cpu));
-	if (!cpuc->per_core)
+	cpuc->shared_regs = allocate_shared_regs(cpu);
+	if (!cpuc->shared_regs)
 		return NOTIFY_BAD;
 
-	raw_spin_lock_init(&cpuc->per_core->lock);
-	cpuc->per_core->core_id = -1;
 	return NOTIFY_OK;
 }
 
@@ -1260,32 +1354,34 @@ static void intel_pmu_cpu_starting(int cpu)
 	 */
 	intel_pmu_lbr_reset();
 
-	if (!cpu_has_ht_siblings())
+	if (!cpuc->shared_regs || (x86_pmu.er_flags & ERF_NO_HT_SHARING))
 		return;
 
 	for_each_cpu(i, topology_thread_cpumask(cpu)) {
-		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
+		struct intel_shared_regs *pc;
 
+		pc = per_cpu(cpu_hw_events, i).shared_regs;
 		if (pc && pc->core_id == core_id) {
-			kfree(cpuc->per_core);
-			cpuc->per_core = pc;
+			kfree(cpuc->shared_regs);
+			cpuc->shared_regs = pc;
 			break;
 		}
 	}
 
-	cpuc->per_core->core_id = core_id;
-	cpuc->per_core->refcnt++;
+	cpuc->shared_regs->core_id = core_id;
+	cpuc->shared_regs->refcnt++;
 }
 
 static void intel_pmu_cpu_dying(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
-	struct intel_percore *pc = cpuc->per_core;
+	struct intel_shared_regs *pc;
 
+	pc = cpuc->shared_regs;
 	if (pc) {
 		if (pc->core_id == -1 || --pc->refcnt == 0)
 			kfree(pc);
-		cpuc->per_core = NULL;
+		cpuc->shared_regs = NULL;
 	}
 
 	fini_debug_store_on_cpu(cpu);
@@ -1436,7 +1532,6 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
 		x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;
-		x86_pmu.percore_constraints = intel_nehalem_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
@@ -1481,10 +1576,10 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
-		x86_pmu.percore_constraints = intel_westmere_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 
 		/* UOPS_ISSUED.STALLED_CYCLES */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
@@ -1502,6 +1597,10 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
@@ -1512,11 +1611,19 @@ static __init int intel_pmu_init(void)
 		break;
 
 	default:
-		/*
-		 * default constraints for v2 and up
-		 */
-		x86_pmu.event_constraints = intel_gen_event_constraints;
-		pr_cont("generic architected perfmon, ");
+		switch (x86_pmu.version) {
+		case 1:
+			x86_pmu.event_constraints = intel_v1_event_constraints;
+			pr_cont("generic architected perfmon v1, ");
+			break;
+		default:
+			/*
+			 * default constraints for v2 and up
+			 */
+			x86_pmu.event_constraints = intel_gen_event_constraints;
+			pr_cont("generic architected perfmon, ");
+			break;
+		}
 	}
 	return 0;
 }
@@ -1528,4 +1635,8 @@ static int intel_pmu_init(void)
 	return 0;
 }
 
+static struct intel_shared_regs *allocate_shared_regs(int cpu)
+{
+	return NULL;
+}
 #endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index bab491b..1b1ef3a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -340,7 +340,7 @@ static int intel_pmu_drain_bts_buffer(void)
 	 */
 	perf_prepare_sample(&header, &data, event, &regs);
 
-	if (perf_output_begin(&handle, event, header.size * (top - at), 1, 1))
+	if (perf_output_begin(&handle, event, header.size * (top - at)))
 		return 1;
 
 	for (; at < top; at++) {
@@ -616,7 +616,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
-	if (perf_event_overflow(event, 1, &data, &regs))
+	if (perf_event_overflow(event, &data, &regs))
 		x86_pmu_stop(event, 0);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index ead584f..7809d2bc 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -554,13 +554,102 @@ static __initconst const u64 p4_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
 };
 
+/*
+ * Because of Netburst being quite restricted in how many
+ * identical events may run simultaneously, we introduce event aliases,
+ * ie the different events which have the same functionality but
+ * utilize non-intersected resources (ESCR/CCCR/counter registers).
+ *
+ * This allow us to relax restrictions a bit and run two or more
+ * identical events together.
+ *
+ * Never set any custom internal bits such as P4_CONFIG_HT,
+ * P4_CONFIG_ALIASABLE or bits for P4_PEBS_METRIC, they are
+ * either up to date automatically or not applicable at all.
+ */
+struct p4_event_alias {
+	u64 original;
+	u64 alternative;
+} p4_event_aliases[] = {
+	{
+		/*
+		 * Non-halted cycles can be substituted with non-sleeping cycles (see
+		 * Intel SDM Vol3b for details). We need this alias to be able
+		 * to run nmi-watchdog and 'perf top' (or any other user space tool
+		 * which is interested in running PERF_COUNT_HW_CPU_CYCLES)
+		 * simultaneously.
+		 */
+	.original	=
+		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING)),
+	.alternative	=
+		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)	|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)	|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)	|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))|
+		p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
+				    P4_CCCR_COMPARE),
+	},
+};
+
+static u64 p4_get_alias_event(u64 config)
+{
+	u64 config_match;
+	int i;
+
+	/*
+	 * Only event with special mark is allowed,
+	 * we're to be sure it didn't come as malformed
+	 * RAW event.
+	 */
+	if (!(config & P4_CONFIG_ALIASABLE))
+		return 0;
+
+	config_match = config & P4_CONFIG_EVENT_ALIAS_MASK;
+
+	for (i = 0; i < ARRAY_SIZE(p4_event_aliases); i++) {
+		if (config_match == p4_event_aliases[i].original) {
+			config_match = p4_event_aliases[i].alternative;
+			break;
+		} else if (config_match == p4_event_aliases[i].alternative) {
+			config_match = p4_event_aliases[i].original;
+			break;
+		}
+	}
+
+	if (i >= ARRAY_SIZE(p4_event_aliases))
+		return 0;
+
+	return config_match | (config & P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS);
+}
+
 static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
   /* non-halted CPU clocks */
   [PERF_COUNT_HW_CPU_CYCLES] =
 	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
-		P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING)),
+		P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING))	|
+		P4_CONFIG_ALIASABLE,
 
   /*
    * retired instructions
@@ -945,7 +1034,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 
 		if (!x86_perf_event_set_period(event))
 			continue;
-		if (perf_event_overflow(event, 1, &data, regs))
+		if (perf_event_overflow(event, &data, regs))
 			x86_pmu_stop(event, 0);
 	}
 
@@ -1120,6 +1209,8 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
 	int cntr_idx, escr_idx;
+	u64 config_alias;
+	int pass;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 	bitmap_zero(escr_mask, P4_ESCR_MSR_TABLE_SIZE);
@@ -1128,6 +1219,17 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 
 		hwc = &cpuc->event_list[i]->hw;
 		thread = p4_ht_thread(cpu);
+		pass = 0;
+
+again:
+		/*
+		 * It's possible to hit a circular lock
+		 * between original and alternative events
+		 * if both are scheduled already.
+		 */
+		if (pass > 2)
+			goto done;
+
 		bind = p4_config_get_bind(hwc->config);
 		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]);
 		if (unlikely(escr_idx == -1))
@@ -1141,8 +1243,17 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 		}
 
 		cntr_idx = p4_next_cntr(thread, used_mask, bind);
-		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask))
-			goto done;
+		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask)) {
+			/*
+			 * Check whether an event alias is still available.
+			 */
+			config_alias = p4_get_alias_event(hwc->config);
+			if (!config_alias)
+				goto done;
+			hwc->config = config_alias;
+			pass++;
+			goto again;
+		}
 
 		p4_pmu_swap_config_ts(hwc, cpu);
 		if (assign)
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index e71c98d..19853ad 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -105,34 +105,6 @@ in_irq_stack(unsigned long *stack, unsigned long *irq_stack,
 }
 
 /*
- * We are returning from the irq stack and go to the previous one.
- * If the previous stack is also in the irq stack, then bp in the first
- * frame of the irq stack points to the previous, interrupted one.
- * Otherwise we have another level of indirection: We first save
- * the bp of the previous stack, then we switch the stack to the irq one
- * and save a new bp that links to the previous one.
- * (See save_args())
- */
-static inline unsigned long
-fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
-		  unsigned long *irq_stack, unsigned long *irq_stack_end)
-{
-#ifdef CONFIG_FRAME_POINTER
-	struct stack_frame *frame = (struct stack_frame *)bp;
-	unsigned long next;
-
-	if (!in_irq_stack(stack, irq_stack, irq_stack_end)) {
-		if (!probe_kernel_address(&frame->next_frame, next))
-			return next;
-		else
-			WARN_ONCE(1, "Perf: bad frame pointer = %p in "
-				  "callchain\n", &frame->next_frame);
-	}
-#endif
-	return bp;
-}
-
-/*
  * x86-64 can have up to three kernel stacks:
  * process stack
  * interrupt stack
@@ -155,9 +127,12 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		task = current;
 
 	if (!stack) {
-		stack = &dummy;
-		if (task && task != current)
+		if (regs)
+			stack = (unsigned long *)regs->sp;
+		else if (task && task != current)
 			stack = (unsigned long *)task->thread.sp;
+		else
+			stack = &dummy;
 	}
 
 	if (!bp)
@@ -205,8 +180,6 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 				 * pointer (index -1 to end) in the IRQ stack:
 				 */
 				stack = (unsigned long *) (irq_stack_end[-1]);
-				bp = fixup_bp_irq_link(bp, stack, irq_stack,
-						       irq_stack_end);
 				irq_stack_end = NULL;
 				ops->stack(data, "EOI");
 				continue;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..d656f68 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -297,27 +297,26 @@ ENDPROC(native_usergs_sysret64)
 	.endm
 
 /* save partial stack frame */
-	.pushsection .kprobes.text, "ax"
-ENTRY(save_args)
-	XCPT_FRAME
+	.macro SAVE_ARGS_IRQ
 	cld
-	/*
-	 * start from rbp in pt_regs and jump over
-	 * return address.
-	 */
-	movq_cfi rdi, RDI+8-RBP
-	movq_cfi rsi, RSI+8-RBP
-	movq_cfi rdx, RDX+8-RBP
-	movq_cfi rcx, RCX+8-RBP
-	movq_cfi rax, RAX+8-RBP
-	movq_cfi  r8,  R8+8-RBP
-	movq_cfi  r9,  R9+8-RBP
-	movq_cfi r10, R10+8-RBP
-	movq_cfi r11, R11+8-RBP
-
-	leaq -RBP+8(%rsp),%rdi	/* arg1 for handler */
-	movq_cfi rbp, 8		/* push %rbp */
-	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
+	/* start from rbp in pt_regs and jump over */
+	movq_cfi rdi, RDI-RBP
+	movq_cfi rsi, RSI-RBP
+	movq_cfi rdx, RDX-RBP
+	movq_cfi rcx, RCX-RBP
+	movq_cfi rax, RAX-RBP
+	movq_cfi  r8,  R8-RBP
+	movq_cfi  r9,  R9-RBP
+	movq_cfi r10, R10-RBP
+	movq_cfi r11, R11-RBP
+
+	/* Save rbp so that we can unwind from get_irq_regs() */
+	movq_cfi rbp, 0
+
+	/* Save previous stack value */
+	movq %rsp, %rsi
+
+	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
 	testl $3, CS(%rdi)
 	je 1f
 	SWAPGS
@@ -329,19 +328,14 @@ ENTRY(save_args)
 	 */
 1:	incl PER_CPU_VAR(irq_count)
 	jne 2f
-	popq_cfi %rax			/* move return address... */
 	mov PER_CPU_VAR(irq_stack_ptr),%rsp
 	EMPTY_FRAME 0
-	pushq_cfi %rbp			/* backlink for unwinder */
-	pushq_cfi %rax			/* ... to the new stack */
-	/*
-	 * We entered an interrupt context - irqs are off:
-	 */
-2:	TRACE_IRQS_OFF
-	ret
-	CFI_ENDPROC
-END(save_args)
-	.popsection
+
+2:	/* Store previous stack value */
+	pushq %rsi
+	/* We entered an interrupt context - irqs are off: */
+	TRACE_IRQS_OFF
+	.endm
 
 ENTRY(save_rest)
 	PARTIAL_FRAME 1 REST_SKIP+8
@@ -791,7 +785,7 @@ END(interrupt)
 	/* reserve pt_regs for scratch regs and rbp */
 	subq $ORIG_RAX-RBP, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
-	call save_args
+	SAVE_ARGS_IRQ
 	PARTIAL_FRAME 0
 	call \func
 	.endm
@@ -814,15 +808,14 @@ ret_from_intr:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	decl PER_CPU_VAR(irq_count)
-	leaveq
 
-	CFI_RESTORE		rbp
+	/* Restore saved previous stack */
+	popq %rsi
+	leaq 16(%rsi), %rsp
+
 	CFI_DEF_CFA_REGISTER	rsp
-	CFI_ADJUST_CFA_OFFSET	-8
+	CFI_ADJUST_CFA_OFFSET	-16
 
-	/* we did not save rbx, restore only from ARGOFFSET */
-	addq $8, %rsp
-	CFI_ADJUST_CFA_OFFSET	-8
 exit_intr:
 	GET_THREAD_INFO(%rcx)
 	testl $3,CS-ARGOFFSET(%rsp)
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 5f9ecff..00354d4 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -608,7 +608,7 @@ int kgdb_arch_init(void)
 	return register_die_notifier(&kgdb_notifier);
 }
 
-static void kgdb_hw_overflow_handler(struct perf_event *event, int nmi,
+static void kgdb_hw_overflow_handler(struct perf_event *event,
 		struct perf_sample_data *data, struct pt_regs *regs)
 {
 	struct task_struct *tsk = current;
@@ -638,7 +638,7 @@ void kgdb_arch_late(void)
 	for (i = 0; i < HBP_NUM; i++) {
 		if (breakinfo[i].pev)
 			continue;
-		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL);
+		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL, NULL);
 		if (IS_ERR((void * __force)breakinfo[i].pev)) {
 			printk(KERN_ERR "kgdb: Could not allocate hw"
 			       "breakpoints\nDisabling the kernel debugger\n");
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 807c2a2..8252879 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -528,7 +528,7 @@ static int genregs_set(struct task_struct *target,
 	return ret;
 }
 
-static void ptrace_triggered(struct perf_event *bp, int nmi,
+static void ptrace_triggered(struct perf_event *bp,
 			     struct perf_sample_data *data,
 			     struct pt_regs *regs)
 {
@@ -715,7 +715,8 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		attr.bp_type = HW_BREAKPOINT_W;
 		attr.disabled = 1;
 
-		bp = register_user_hw_breakpoint(&attr, ptrace_triggered, tsk);
+		bp = register_user_hw_breakpoint(&attr, ptrace_triggered,
+						 NULL, tsk);
 
 		/*
 		 * CHECKME: the previous code returned -EIO if the addr wasn't
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 55d9bc0..fdd0c64 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -66,7 +66,7 @@ void save_stack_trace(struct stack_trace *trace)
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 
-void save_stack_trace_regs(struct stack_trace *trace, struct pt_regs *regs)
+void save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
 {
 	dump_trace(current, regs, NULL, 0, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index f2479f1..6ba4773 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
-lib-y += usercopy_$(BITS).o getuser.o putuser.o
+lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
new file mode 100644
index 0000000..97be9cb
--- /dev/null
+++ b/arch/x86/lib/usercopy.c
@@ -0,0 +1,43 @@
+/*
+ * User address space access functions.
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/highmem.h>
+#include <linux/module.h>
+
+/*
+ * best effort, GUP based copy_from_user() that is NMI-safe
+ */
+unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+{
+	unsigned long offset, addr = (unsigned long)from;
+	unsigned long size, len = 0;
+	struct page *page;
+	void *map;
+	int ret;
+
+	do {
+		ret = __get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret)
+			break;
+
+		offset = addr & (PAGE_SIZE - 1);
+		size = min(PAGE_SIZE - offset, n - len);
+
+		map = kmap_atomic(page);
+		memcpy(to, map+offset, size);
+		kunmap_atomic(map);
+		put_page(page);
+
+		len  += size;
+		to   += size;
+		addr += size;
+
+	} while (len < n);
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(copy_from_user_nmi);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2dbf6bf..4d09df0 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1059,7 +1059,7 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 	/*
 	 * If we're in an interrupt, have no user context or are running
@@ -1161,11 +1161,11 @@ good_area:
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
 		if (fault & VM_FAULT_MAJOR) {
 			tsk->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
 				      regs, address);
 		} else {
 			tsk->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
 				      regs, address);
 		}
 		if (fault & VM_FAULT_RETRY) {
diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
index 704a37c..dab4187 100644
--- a/arch/x86/mm/kmemcheck/error.c
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -185,7 +185,7 @@ void kmemcheck_error_save(enum kmemcheck_shadow state,
 	e->trace.entries = e->trace_entries;
 	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
 	e->trace.skip = 0;
-	save_stack_trace_regs(&e->trace, regs);
+	save_stack_trace_regs(regs, &e->trace);
 
 	/* Round address down to nearest 16 bytes */
 	shadow_copy = kmemcheck_shadow_lookup(address
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index a5b64ab..bff89df 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -11,10 +11,11 @@
 #include <linux/oprofile.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/compat.h>
+#include <linux/uaccess.h>
+
 #include <asm/ptrace.h>
-#include <asm/uaccess.h>
 #include <asm/stacktrace.h>
-#include <linux/compat.h>
 
 static int backtrace_stack(void *data, char *name)
 {
@@ -40,13 +41,13 @@ static struct stacktrace_ops backtrace_ops = {
 static struct stack_frame_ia32 *
 dump_user_backtrace_32(struct stack_frame_ia32 *head)
 {
+	/* Also check accessibility of one struct frame_head beyond: */
 	struct stack_frame_ia32 bufhead[2];
 	struct stack_frame_ia32 *fp;
+	unsigned long bytes;
 
-	/* Also check accessibility of one struct frame_head beyond */
-	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
-		return NULL;
-	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	if (bytes != sizeof(bufhead))
 		return NULL;
 
 	fp = (struct stack_frame_ia32 *) compat_ptr(bufhead[0].next_frame);
@@ -87,12 +88,12 @@ x86_backtrace_32(struct pt_regs * const regs, unsigned int depth)
 
 static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
 {
+	/* Also check accessibility of one struct frame_head beyond: */
 	struct stack_frame bufhead[2];
+	unsigned long bytes;
 
-	/* Also check accessibility of one struct stack_frame beyond */
-	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
-		return NULL;
-	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	if (bytes != sizeof(bufhead))
 		return NULL;
 
 	oprofile_add_trace(bufhead[0].return_address);
diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index 9046f7b..94796f3 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -31,7 +31,7 @@ static int num_counters;
 /*
  * Overflow callback for oprofile.
  */
-static void op_overflow_handler(struct perf_event *event, int unused,
+static void op_overflow_handler(struct perf_event *event,
 			struct perf_sample_data *data, struct pt_regs *regs)
 {
 	int id;
@@ -79,7 +79,7 @@ static int op_create_counter(int cpu, int event)
 
 	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
 						  cpu, NULL,
-						  op_overflow_handler);
+						  op_overflow_handler, NULL);
 
 	if (IS_ERR(pevent))
 		return PTR_ERR(pevent);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9d88e1c..f0c0e8a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -19,6 +19,8 @@
 
 #include <asm/ftrace.h>
 
+struct ftrace_hash;
+
 #ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
@@ -29,8 +31,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
-struct ftrace_hash;
-
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
@@ -123,7 +123,8 @@ stack_trace_sysctl(struct ctl_table *table, int write,
 struct ftrace_func_command {
 	struct list_head	list;
 	char			*name;
-	int			(*func)(char *func, char *cmd,
+	int			(*func)(struct ftrace_hash *hash,
+					char *func, char *cmd,
 					char *params, int enable);
 };
 
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 59d3ef1..96efa67 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -76,6 +76,7 @@ struct trace_iterator {
 	struct trace_entry	*ent;
 	unsigned long		lost_events;
 	int			leftover;
+	int			ent_size;
 	int			cpu;
 	u64			ts;
 
@@ -129,6 +130,10 @@ void trace_current_buffer_unlock_commit(struct ring_buffer *buffer,
 void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
 				       struct ring_buffer_event *event,
 					unsigned long flags, int pc);
+void trace_nowake_buffer_unlock_commit_regs(struct ring_buffer *buffer,
+					    struct ring_buffer_event *event,
+					    unsigned long flags, int pc,
+					    struct pt_regs *regs);
 void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 					 struct ring_buffer_event *event);
 
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index d1e55fe..6ae9c63 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -73,6 +73,7 @@ static inline unsigned long hw_breakpoint_len(struct perf_event *bp)
 extern struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
+			    void *context,
 			    struct task_struct *tsk);
 
 /* FIXME: only change from the attr, and don't unregister */
@@ -85,11 +86,13 @@ modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr);
 extern struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	triggered,
+				void *context,
 				int cpu);
 
 extern struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_overflow_handler_t triggered);
+			    perf_overflow_handler_t triggered,
+			    void *context);
 
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern int __register_perf_hw_breakpoint(struct perf_event *bp);
@@ -115,6 +118,7 @@ static inline int __init init_hw_breakpoint(void) { return 0; }
 static inline struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
+			    void *context,
 			    struct task_struct *tsk)	{ return NULL; }
 static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
@@ -122,10 +126,12 @@ modify_user_hw_breakpoint(struct perf_event *bp,
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	 triggered,
+				void *context,
 				int cpu)		{ return NULL; }
 static inline struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_overflow_handler_t triggered)	{ return NULL; }
+			    perf_overflow_handler_t triggered,
+			    void *context)		{ return NULL; }
 static inline int
 register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
 static inline int
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e0786e3..3f2711c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -61,7 +61,7 @@ enum perf_hw_id {
 /*
  * Generalized hardware cache events:
  *
- *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU } x
+ *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU, NODE } x
  *       { read, write, prefetch } x
  *       { accesses, misses }
  */
@@ -72,6 +72,7 @@ enum perf_hw_cache_id {
 	PERF_COUNT_HW_CACHE_DTLB		= 3,
 	PERF_COUNT_HW_CACHE_ITLB		= 4,
 	PERF_COUNT_HW_CACHE_BPU			= 5,
+	PERF_COUNT_HW_CACHE_NODE		= 6,
 
 	PERF_COUNT_HW_CACHE_MAX,		/* non-ABI */
 };
@@ -536,6 +537,16 @@ struct perf_branch_stack {
 
 struct task_struct;
 
+/*
+ * extra PMU register associated with an event
+ */
+struct hw_perf_event_extra {
+	u64		config;	/* register value */
+	unsigned int	reg;	/* register address or index */
+	int		alloc;	/* extra register already allocated */
+	int		idx;	/* index in shared_regs->regs[] */
+};
+
 /**
  * struct hw_perf_event - performance event hardware details:
  */
@@ -549,9 +560,7 @@ struct hw_perf_event {
 			unsigned long	event_base;
 			int		idx;
 			int		last_cpu;
-			unsigned int	extra_reg;
-			u64		extra_config;
-			int		extra_alloc;
+			struct hw_perf_event_extra extra_reg;
 		};
 		struct { /* software */
 			struct hrtimer	hrtimer;
@@ -680,36 +689,9 @@ enum perf_event_active_state {
 };
 
 struct file;
-
-#define PERF_BUFFER_WRITABLE		0x01
-
-struct perf_buffer {
-	atomic_t			refcount;
-	struct rcu_head			rcu_head;
-#ifdef CONFIG_PERF_USE_VMALLOC
-	struct work_struct		work;
-	int				page_order;	/* allocation order  */
-#endif
-	int				nr_pages;	/* nr of data pages  */
-	int				writable;	/* are we writable   */
-
-	atomic_t			poll;		/* POLL_ for wakeups */
-
-	local_t				head;		/* write position    */
-	local_t				nest;		/* nested writers    */
-	local_t				events;		/* event limit       */
-	local_t				wakeup;		/* wakeup stamp      */
-	local_t				lost;		/* nr records lost   */
-
-	long				watermark;	/* wakeup watermark  */
-
-	struct perf_event_mmap_page	*user_page;
-	void				*data_pages[0];
-};
-
 struct perf_sample_data;
 
-typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
+typedef void (*perf_overflow_handler_t)(struct perf_event *,
 					struct perf_sample_data *,
 					struct pt_regs *regs);
 
@@ -745,6 +727,8 @@ struct perf_cgroup {
 };
 #endif
 
+struct ring_buffer;
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -834,7 +818,7 @@ struct perf_event {
 	atomic_t			mmap_count;
 	int				mmap_locked;
 	struct user_struct		*mmap_user;
-	struct perf_buffer		*buffer;
+	struct ring_buffer		*rb;
 
 	/* poll related */
 	wait_queue_head_t		waitq;
@@ -855,6 +839,7 @@ struct perf_event {
 	u64				id;
 
 	perf_overflow_handler_t		overflow_handler;
+	void				*overflow_handler_context;
 
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
@@ -919,8 +904,8 @@ struct perf_event_context {
 	u64				parent_gen;
 	u64				generation;
 	int				pin_count;
-	struct rcu_head			rcu_head;
 	int				nr_cgroups; /* cgroup events present */
+	struct rcu_head			rcu_head;
 };
 
 /*
@@ -945,13 +930,11 @@ struct perf_cpu_context {
 
 struct perf_output_handle {
 	struct perf_event		*event;
-	struct perf_buffer		*buffer;
+	struct ring_buffer		*rb;
 	unsigned long			wakeup;
 	unsigned long			size;
 	void				*addr;
 	int				page;
-	int				nmi;
-	int				sample;
 };
 
 #ifdef CONFIG_PERF_EVENTS
@@ -972,13 +955,15 @@ extern void perf_pmu_disable(struct pmu *pmu);
 extern void perf_pmu_enable(struct pmu *pmu);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
+extern int perf_event_refresh(struct perf_event *event, int refresh);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
 				struct task_struct *task,
-				perf_overflow_handler_t callback);
+				perf_overflow_handler_t callback,
+				void *context);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
@@ -1018,7 +1003,7 @@ extern void perf_prepare_sample(struct perf_event_header *header,
 				struct perf_event *event,
 				struct pt_regs *regs);
 
-extern int perf_event_overflow(struct perf_event *event, int nmi,
+extern int perf_event_overflow(struct perf_event *event,
 				 struct perf_sample_data *data,
 				 struct pt_regs *regs);
 
@@ -1037,7 +1022,7 @@ static inline int is_software_event(struct perf_event *event)
 
 extern struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
-extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
+extern void __perf_sw_event(u32, u64, struct pt_regs *, u64);
 
 #ifndef perf_arch_fetch_caller_regs
 static inline void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
@@ -1059,7 +1044,7 @@ static inline void perf_fetch_caller_regs(struct pt_regs *regs)
 }
 
 static __always_inline void
-perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
@@ -1068,7 +1053,7 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 			perf_fetch_caller_regs(&hot_regs);
 			regs = &hot_regs;
 		}
-		__perf_sw_event(event_id, nr, nmi, regs, addr);
+		__perf_sw_event(event_id, nr, regs, addr);
 	}
 }
 
@@ -1082,7 +1067,7 @@ static inline void perf_event_task_sched_in(struct task_struct *task)
 
 static inline void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
 {
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
+	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
 	__perf_event_task_sched_out(task, next);
 }
@@ -1143,8 +1128,7 @@ extern void perf_bp_event(struct perf_event *event, void *data);
 #endif
 
 extern int perf_output_begin(struct perf_output_handle *handle,
-			     struct perf_event *event, unsigned int size,
-			     int nmi, int sample);
+			     struct perf_event *event, unsigned int size);
 extern void perf_output_end(struct perf_output_handle *handle);
 extern void perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
@@ -1166,10 +1150,13 @@ static inline void perf_event_delayed_put(struct task_struct *task)	{ }
 static inline void perf_event_print_debug(void)				{ }
 static inline int perf_event_task_disable(void)				{ return -EINVAL; }
 static inline int perf_event_task_enable(void)				{ return -EINVAL; }
+static inline int perf_event_refresh(struct perf_event *event, int refresh)
+{
+	return -EINVAL;
+}
 
 static inline void
-perf_sw_event(u32 event_id, u64 nr, int nmi,
-		     struct pt_regs *regs, u64 addr)			{ }
+perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)	{ }
 static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index ab38ac8..b891de9 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -169,7 +169,7 @@ void ring_buffer_set_clock(struct ring_buffer *buffer,
 size_t ring_buffer_page_len(void *page);
 
 
-void *ring_buffer_alloc_read_page(struct ring_buffer *buffer);
+void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu);
 void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
 int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,
 			  size_t len, int cpu, int full);
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 25310f1..115b570 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -14,8 +14,8 @@ struct stack_trace {
 };
 
 extern void save_stack_trace(struct stack_trace *trace);
-extern void save_stack_trace_regs(struct stack_trace *trace,
-				  struct pt_regs *regs);
+extern void save_stack_trace_regs(struct pt_regs *regs,
+				  struct stack_trace *trace);
 extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
diff --git a/kernel/async.c b/kernel/async.c
index cd9dbb9..d5fe7af 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -49,12 +49,13 @@ asynchronous and synchronous parts of the kernel.
 */
 
 #include <linux/async.h>
+#include <linux/atomic.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
 
 static async_cookie_t next_cookie = 1;
 
@@ -128,7 +129,8 @@ static void async_run_entry_fn(struct work_struct *work)
 
 	/* 2) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("calling  %lli_%pF @ %i\n", (long long)entry->cookie,
+		printk(KERN_DEBUG "calling  %lli_%pF @ %i\n",
+			(long long)entry->cookie,
 			entry->func, task_pid_nr(current));
 		calltime = ktime_get();
 	}
@@ -136,7 +138,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		printk("initcall %lli_%pF returned 0 after %lld usecs\n",
+		printk(KERN_DEBUG "initcall %lli_%pF returned 0 after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
 			(long long)ktime_to_ns(delta) >> 10);
@@ -270,7 +272,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie,
 	ktime_t starttime, delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("async_waiting @ %i\n", task_pid_nr(current));
+		printk(KERN_DEBUG "async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
 	}
 
@@ -280,7 +282,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie,
 		endtime = ktime_get();
 		delta = ktime_sub(endtime, starttime);
 
-		printk("async_continuing @ %i after %lli usec\n",
+		printk(KERN_DEBUG "async_continuing @ %i after %lli usec\n",
 			task_pid_nr(current),
 			(long long)ktime_to_ns(delta) >> 10);
 	}
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 1ce23d3..89e5e8a 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,5 +2,5 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o
+obj-y := core.o ring_buffer.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9efe710..b8785e2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -36,6 +36,8 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 
+#include "internal.h"
+
 #include <asm/irq_regs.h>
 
 struct remote_function_call {
@@ -200,6 +202,22 @@ __get_cpu_context(struct perf_event_context *ctx)
 	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
 }
 
+static void perf_ctx_lock(struct perf_cpu_context *cpuctx,
+			  struct perf_event_context *ctx)
+{
+	raw_spin_lock(&cpuctx->ctx.lock);
+	if (ctx)
+		raw_spin_lock(&ctx->lock);
+}
+
+static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
+			    struct perf_event_context *ctx)
+{
+	if (ctx)
+		raw_spin_unlock(&ctx->lock);
+	raw_spin_unlock(&cpuctx->ctx.lock);
+}
+
 #ifdef CONFIG_CGROUP_PERF
 
 /*
@@ -340,11 +358,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 
-		perf_pmu_disable(cpuctx->ctx.pmu);
-
 		/*
 		 * perf_cgroup_events says at least one
 		 * context on this CPU has cgroup events.
@@ -353,6 +368,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 		 * events for a context.
 		 */
 		if (cpuctx->ctx.nr_cgroups > 0) {
+			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+			perf_pmu_disable(cpuctx->ctx.pmu);
 
 			if (mode & PERF_CGROUP_SWOUT) {
 				cpu_ctx_sched_out(cpuctx, EVENT_ALL);
@@ -372,9 +389,9 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 				cpuctx->cgrp = perf_cgroup_from_task(task);
 				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
 			}
+			perf_pmu_enable(cpuctx->ctx.pmu);
+			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 		}
-
-		perf_pmu_enable(cpuctx->ctx.pmu);
 	}
 
 	rcu_read_unlock();
@@ -731,6 +748,7 @@ static u64 perf_event_time(struct perf_event *event)
 
 /*
  * Update the total_time_enabled and total_time_running fields for a event.
+ * The caller of this function needs to hold the ctx->lock.
  */
 static void update_event_times(struct perf_event *event)
 {
@@ -1105,6 +1123,10 @@ static int __perf_remove_from_context(void *info)
 	raw_spin_lock(&ctx->lock);
 	event_sched_out(event, cpuctx, ctx);
 	list_del_event(event, ctx);
+	if (!ctx->nr_events && cpuctx->task_ctx == ctx) {
+		ctx->is_active = 0;
+		cpuctx->task_ctx = NULL;
+	}
 	raw_spin_unlock(&ctx->lock);
 
 	return 0;
@@ -1454,8 +1476,24 @@ static void add_event_to_ctx(struct perf_event *event,
 	event->tstamp_stopped = tstamp;
 }
 
-static void perf_event_context_sched_in(struct perf_event_context *ctx,
-					struct task_struct *tsk);
+static void task_ctx_sched_out(struct perf_event_context *ctx);
+static void
+ctx_sched_in(struct perf_event_context *ctx,
+	     struct perf_cpu_context *cpuctx,
+	     enum event_type_t event_type,
+	     struct task_struct *task);
+
+static void perf_event_sched_in(struct perf_cpu_context *cpuctx,
+				struct perf_event_context *ctx,
+				struct task_struct *task)
+{
+	cpu_ctx_sched_in(cpuctx, EVENT_PINNED, task);
+	if (ctx)
+		ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
+	if (ctx)
+		ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
+}
 
 /*
  * Cross CPU call to install and enable a performance event
@@ -1466,20 +1504,37 @@ static int  __perf_install_in_context(void *info)
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
-	struct perf_event *leader = event->group_leader;
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
-	int err;
+	struct perf_event_context *task_ctx = cpuctx->task_ctx;
+	struct task_struct *task = current;
+
+	perf_ctx_lock(cpuctx, task_ctx);
+	perf_pmu_disable(cpuctx->ctx.pmu);
 
 	/*
-	 * In case we're installing a new context to an already running task,
-	 * could also happen before perf_event_task_sched_in() on architectures
-	 * which do context switches with IRQs enabled.
+	 * If there was an active task_ctx schedule it out.
 	 */
-	if (ctx->task && !cpuctx->task_ctx)
-		perf_event_context_sched_in(ctx, ctx->task);
+	if (task_ctx)
+		task_ctx_sched_out(task_ctx);
+
+	/*
+	 * If the context we're installing events in is not the
+	 * active task_ctx, flip them.
+	 */
+	if (ctx->task && task_ctx != ctx) {
+		if (task_ctx)
+			raw_spin_unlock(&task_ctx->lock);
+		raw_spin_lock(&ctx->lock);
+		task_ctx = ctx;
+	}
+
+	if (task_ctx) {
+		cpuctx->task_ctx = task_ctx;
+		task = task_ctx->task;
+	}
+
+	cpu_ctx_sched_out(cpuctx, EVENT_ALL);
 
-	raw_spin_lock(&ctx->lock);
-	ctx->is_active = 1;
 	update_context_time(ctx);
 	/*
 	 * update cgrp time only if current cgrp
@@ -1490,43 +1545,13 @@ static int  __perf_install_in_context(void *info)
 
 	add_event_to_ctx(event, ctx);
 
-	if (!event_filter_match(event))
-		goto unlock;
-
-	/*
-	 * Don't put the event on if it is disabled or if
-	 * it is in a group and the group isn't on.
-	 */
-	if (event->state != PERF_EVENT_STATE_INACTIVE ||
-	    (leader != event && leader->state != PERF_EVENT_STATE_ACTIVE))
-		goto unlock;
-
 	/*
-	 * An exclusive event can't go on if there are already active
-	 * hardware events, and no hardware event can go on if there
-	 * is already an exclusive event on.
+	 * Schedule everything back in
 	 */
-	if (!group_can_go_on(event, cpuctx, 1))
-		err = -EEXIST;
-	else
-		err = event_sched_in(event, cpuctx, ctx);
-
-	if (err) {
-		/*
-		 * This event couldn't go on.  If it is in a group
-		 * then we have to pull the whole group off.
-		 * If the event group is pinned then put it in error state.
-		 */
-		if (leader != event)
-			group_sched_out(leader, cpuctx, ctx);
-		if (leader->attr.pinned) {
-			update_group_times(leader);
-			leader->state = PERF_EVENT_STATE_ERROR;
-		}
-	}
+	perf_event_sched_in(cpuctx, task_ctx, task);
 
-unlock:
-	raw_spin_unlock(&ctx->lock);
+	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_ctx_unlock(cpuctx, task_ctx);
 
 	return 0;
 }
@@ -1739,7 +1764,7 @@ out:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
-static int perf_event_refresh(struct perf_event *event, int refresh)
+int perf_event_refresh(struct perf_event *event, int refresh)
 {
 	/*
 	 * not supported on inherited events
@@ -1752,36 +1777,35 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(perf_event_refresh);
 
 static void ctx_sched_out(struct perf_event_context *ctx,
 			  struct perf_cpu_context *cpuctx,
 			  enum event_type_t event_type)
 {
 	struct perf_event *event;
+	int is_active = ctx->is_active;
 
-	raw_spin_lock(&ctx->lock);
-	perf_pmu_disable(ctx->pmu);
-	ctx->is_active = 0;
+	ctx->is_active &= ~event_type;
 	if (likely(!ctx->nr_events))
-		goto out;
+		return;
+
 	update_context_time(ctx);
 	update_cgrp_time_from_cpuctx(cpuctx);
-
 	if (!ctx->nr_active)
-		goto out;
+		return;
 
-	if (event_type & EVENT_PINNED) {
+	perf_pmu_disable(ctx->pmu);
+	if ((is_active & EVENT_PINNED) && (event_type & EVENT_PINNED)) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
 
-	if (event_type & EVENT_FLEXIBLE) {
+	if ((is_active & EVENT_FLEXIBLE) && (event_type & EVENT_FLEXIBLE)) {
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
-out:
 	perf_pmu_enable(ctx->pmu);
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -1929,8 +1953,10 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	rcu_read_unlock();
 
 	if (do_switch) {
+		raw_spin_lock(&ctx->lock);
 		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 		cpuctx->task_ctx = NULL;
+		raw_spin_unlock(&ctx->lock);
 	}
 }
 
@@ -1965,8 +1991,7 @@ void __perf_event_task_sched_out(struct task_struct *task,
 		perf_cgroup_sched_out(task);
 }
 
-static void task_ctx_sched_out(struct perf_event_context *ctx,
-			       enum event_type_t event_type)
+static void task_ctx_sched_out(struct perf_event_context *ctx)
 {
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
@@ -1976,7 +2001,7 @@ static void task_ctx_sched_out(struct perf_event_context *ctx,
 	if (WARN_ON_ONCE(ctx != cpuctx->task_ctx))
 		return;
 
-	ctx_sched_out(ctx, cpuctx, event_type);
+	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 	cpuctx->task_ctx = NULL;
 }
 
@@ -2055,11 +2080,11 @@ ctx_sched_in(struct perf_event_context *ctx,
 	     struct task_struct *task)
 {
 	u64 now;
+	int is_active = ctx->is_active;
 
-	raw_spin_lock(&ctx->lock);
-	ctx->is_active = 1;
+	ctx->is_active |= event_type;
 	if (likely(!ctx->nr_events))
-		goto out;
+		return;
 
 	now = perf_clock();
 	ctx->timestamp = now;
@@ -2068,15 +2093,12 @@ ctx_sched_in(struct perf_event_context *ctx,
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
 	 */
-	if (event_type & EVENT_PINNED)
+	if (!(is_active & EVENT_PINNED) && (event_type & EVENT_PINNED))
 		ctx_pinned_sched_in(ctx, cpuctx);
 
 	/* Then walk through the lower prio flexible groups */
-	if (event_type & EVENT_FLEXIBLE)
+	if (!(is_active & EVENT_FLEXIBLE) && (event_type & EVENT_FLEXIBLE))
 		ctx_flexible_sched_in(ctx, cpuctx);
-
-out:
-	raw_spin_unlock(&ctx->lock);
 }
 
 static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
@@ -2088,19 +2110,6 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 	ctx_sched_in(ctx, cpuctx, event_type, task);
 }
 
-static void task_ctx_sched_in(struct perf_event_context *ctx,
-			      enum event_type_t event_type)
-{
-	struct perf_cpu_context *cpuctx;
-
-	cpuctx = __get_cpu_context(ctx);
-	if (cpuctx->task_ctx == ctx)
-		return;
-
-	ctx_sched_in(ctx, cpuctx, event_type, NULL);
-	cpuctx->task_ctx = ctx;
-}
-
 static void perf_event_context_sched_in(struct perf_event_context *ctx,
 					struct task_struct *task)
 {
@@ -2110,6 +2119,7 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	if (cpuctx->task_ctx == ctx)
 		return;
 
+	perf_ctx_lock(cpuctx, ctx);
 	perf_pmu_disable(ctx->pmu);
 	/*
 	 * We want to keep the following priority order:
@@ -2118,18 +2128,18 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, task);
-	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE, task);
+	perf_event_sched_in(cpuctx, ctx, task);
 
 	cpuctx->task_ctx = ctx;
 
+	perf_pmu_enable(ctx->pmu);
+	perf_ctx_unlock(cpuctx, ctx);
+
 	/*
 	 * Since these rotations are per-cpu, we need to ensure the
 	 * cpu-context we got scheduled on is actually rotating.
 	 */
 	perf_pmu_rotate_start(ctx->pmu);
-	perf_pmu_enable(ctx->pmu);
 }
 
 /*
@@ -2269,7 +2279,6 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 	u64 interrupts, now;
 	s64 delta;
 
-	raw_spin_lock(&ctx->lock);
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -2301,7 +2310,6 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (delta > 0)
 			perf_adjust_period(event, period, delta);
 	}
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -2309,16 +2317,12 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
  */
 static void rotate_ctx(struct perf_event_context *ctx)
 {
-	raw_spin_lock(&ctx->lock);
-
 	/*
 	 * Rotate the first entry last of non-pinned groups. Rotation might be
 	 * disabled by the inheritance code.
 	 */
 	if (!ctx->rotate_disable)
 		list_rotate_left(&ctx->flexible_groups);
-
-	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -2345,6 +2349,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 			rotate = 1;
 	}
 
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(cpuctx->ctx.pmu);
 	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
 	if (ctx)
@@ -2355,21 +2360,20 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_out(ctx, EVENT_FLEXIBLE);
+		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	rotate_ctx(&cpuctx->ctx);
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE, current);
-	if (ctx)
-		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
+	perf_event_sched_in(cpuctx, ctx, current);
 
 done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
 
 	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
 void perf_event_task_tick(void)
@@ -2424,9 +2428,9 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	 * in.
 	 */
 	perf_cgroup_sched_out(current);
-	task_ctx_sched_out(ctx, EVENT_ALL);
 
 	raw_spin_lock(&ctx->lock);
+	task_ctx_sched_out(ctx);
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		ret = event_enable_on_exec(event, ctx);
@@ -2835,16 +2839,12 @@ retry:
 		unclone_ctx(ctx);
 		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
-	}
-
-	if (!ctx) {
+	} else {
 		ctx = alloc_perf_context(pmu, task);
 		err = -ENOMEM;
 		if (!ctx)
 			goto errout;
 
-		get_ctx(ctx);
-
 		err = 0;
 		mutex_lock(&task->perf_event_mutex);
 		/*
@@ -2856,14 +2856,14 @@ retry:
 		else if (task->perf_event_ctxp[ctxn])
 			err = -EAGAIN;
 		else {
+			get_ctx(ctx);
 			++ctx->pin_count;
 			rcu_assign_pointer(task->perf_event_ctxp[ctxn], ctx);
 		}
 		mutex_unlock(&task->perf_event_mutex);
 
 		if (unlikely(err)) {
-			put_task_struct(task);
-			kfree(ctx);
+			put_ctx(ctx);
 
 			if (err == -EAGAIN)
 				goto retry;
@@ -2890,7 +2890,7 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void perf_buffer_put(struct perf_buffer *buffer);
+static void ring_buffer_put(struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -2913,9 +2913,9 @@ static void free_event(struct perf_event *event)
 		}
 	}
 
-	if (event->buffer) {
-		perf_buffer_put(event->buffer);
-		event->buffer = NULL;
+	if (event->rb) {
+		ring_buffer_put(event->rb);
+		event->rb = NULL;
 	}
 
 	if (is_cgroup_event(event))
@@ -2934,12 +2934,6 @@ int perf_event_release_kernel(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 
-	/*
-	 * Remove from the PMU, can't get re-enabled since we got
-	 * here because the last ref went.
-	 */
-	perf_event_disable(event);
-
 	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
 	 * There are two ways this annotation is useful:
@@ -2956,8 +2950,8 @@ int perf_event_release_kernel(struct perf_event *event)
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
 	raw_spin_lock_irq(&ctx->lock);
 	perf_group_detach(event);
-	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
+	perf_remove_from_context(event);
 	mutex_unlock(&ctx->mutex);
 
 	free_event(event);
@@ -3149,13 +3143,13 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 	unsigned int events = POLL_HUP;
 
 	rcu_read_lock();
-	buffer = rcu_dereference(event->buffer);
-	if (buffer)
-		events = atomic_xchg(&buffer->poll, 0);
+	rb = rcu_dereference(event->rb);
+	if (rb)
+		events = atomic_xchg(&rb->poll, 0);
 	rcu_read_unlock();
 
 	poll_wait(file, &event->waitq, wait);
@@ -3358,6 +3352,18 @@ static int perf_event_index(struct perf_event *event)
 	return event->hw.idx + 1 - PERF_EVENT_INDEX_OFFSET;
 }
 
+static void calc_timer_values(struct perf_event *event,
+				u64 *running,
+				u64 *enabled)
+{
+	u64 now, ctx_time;
+
+	now = perf_clock();
+	ctx_time = event->shadow_ctx_time + now;
+	*enabled = ctx_time - event->tstamp_enabled;
+	*running = ctx_time - event->tstamp_running;
+}
+
 /*
  * Callers need to ensure there can be no nesting of this function, otherwise
  * the seqlock logic goes bad. We can not serialize this because the arch
@@ -3366,14 +3372,25 @@ static int perf_event_index(struct perf_event *event)
 void perf_event_update_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
+	u64 enabled, running;
 
 	rcu_read_lock();
-	buffer = rcu_dereference(event->buffer);
-	if (!buffer)
+	/*
+	 * compute total_time_enabled, total_time_running
+	 * based on snapshot values taken when the event
+	 * was last scheduled in.
+	 *
+	 * we cannot simply called update_context_time()
+	 * because of locking issue as we can be called in
+	 * NMI context
+	 */
+	calc_timer_values(event, &enabled, &running);
+	rb = rcu_dereference(event->rb);
+	if (!rb)
 		goto unlock;
 
-	userpg = buffer->user_page;
+	userpg = rb->user_page;
 
 	/*
 	 * Disable preemption so as to not let the corresponding user-space
@@ -3387,10 +3404,10 @@ void perf_event_update_userpage(struct perf_event *event)
 	if (event->state == PERF_EVENT_STATE_ACTIVE)
 		userpg->offset -= local64_read(&event->hw.prev_count);
 
-	userpg->time_enabled = event->total_time_enabled +
+	userpg->time_enabled = enabled +
 			atomic64_read(&event->child_total_time_enabled);
 
-	userpg->time_running = event->total_time_running +
+	userpg->time_running = running +
 			atomic64_read(&event->child_total_time_running);
 
 	barrier();
@@ -3400,220 +3417,10 @@ unlock:
 	rcu_read_unlock();
 }
 
-static unsigned long perf_data_size(struct perf_buffer *buffer);
-
-static void
-perf_buffer_init(struct perf_buffer *buffer, long watermark, int flags)
-{
-	long max_size = perf_data_size(buffer);
-
-	if (watermark)
-		buffer->watermark = min(max_size, watermark);
-
-	if (!buffer->watermark)
-		buffer->watermark = max_size / 2;
-
-	if (flags & PERF_BUFFER_WRITABLE)
-		buffer->writable = 1;
-
-	atomic_set(&buffer->refcount, 1);
-}
-
-#ifndef CONFIG_PERF_USE_VMALLOC
-
-/*
- * Back perf_mmap() with regular GFP_KERNEL-0 pages.
- */
-
-static struct page *
-perf_mmap_to_page(struct perf_buffer *buffer, unsigned long pgoff)
-{
-	if (pgoff > buffer->nr_pages)
-		return NULL;
-
-	if (pgoff == 0)
-		return virt_to_page(buffer->user_page);
-
-	return virt_to_page(buffer->data_pages[pgoff - 1]);
-}
-
-static void *perf_mmap_alloc_page(int cpu)
-{
-	struct page *page;
-	int node;
-
-	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
-	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
-	if (!page)
-		return NULL;
-
-	return page_address(page);
-}
-
-static struct perf_buffer *
-perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
-{
-	struct perf_buffer *buffer;
-	unsigned long size;
-	int i;
-
-	size = sizeof(struct perf_buffer);
-	size += nr_pages * sizeof(void *);
-
-	buffer = kzalloc(size, GFP_KERNEL);
-	if (!buffer)
-		goto fail;
-
-	buffer->user_page = perf_mmap_alloc_page(cpu);
-	if (!buffer->user_page)
-		goto fail_user_page;
-
-	for (i = 0; i < nr_pages; i++) {
-		buffer->data_pages[i] = perf_mmap_alloc_page(cpu);
-		if (!buffer->data_pages[i])
-			goto fail_data_pages;
-	}
-
-	buffer->nr_pages = nr_pages;
-
-	perf_buffer_init(buffer, watermark, flags);
-
-	return buffer;
-
-fail_data_pages:
-	for (i--; i >= 0; i--)
-		free_page((unsigned long)buffer->data_pages[i]);
-
-	free_page((unsigned long)buffer->user_page);
-
-fail_user_page:
-	kfree(buffer);
-
-fail:
-	return NULL;
-}
-
-static void perf_mmap_free_page(unsigned long addr)
-{
-	struct page *page = virt_to_page((void *)addr);
-
-	page->mapping = NULL;
-	__free_page(page);
-}
-
-static void perf_buffer_free(struct perf_buffer *buffer)
-{
-	int i;
-
-	perf_mmap_free_page((unsigned long)buffer->user_page);
-	for (i = 0; i < buffer->nr_pages; i++)
-		perf_mmap_free_page((unsigned long)buffer->data_pages[i]);
-	kfree(buffer);
-}
-
-static inline int page_order(struct perf_buffer *buffer)
-{
-	return 0;
-}
-
-#else
-
-/*
- * Back perf_mmap() with vmalloc memory.
- *
- * Required for architectures that have d-cache aliasing issues.
- */
-
-static inline int page_order(struct perf_buffer *buffer)
-{
-	return buffer->page_order;
-}
-
-static struct page *
-perf_mmap_to_page(struct perf_buffer *buffer, unsigned long pgoff)
-{
-	if (pgoff > (1UL << page_order(buffer)))
-		return NULL;
-
-	return vmalloc_to_page((void *)buffer->user_page + pgoff * PAGE_SIZE);
-}
-
-static void perf_mmap_unmark_page(void *addr)
-{
-	struct page *page = vmalloc_to_page(addr);
-
-	page->mapping = NULL;
-}
-
-static void perf_buffer_free_work(struct work_struct *work)
-{
-	struct perf_buffer *buffer;
-	void *base;
-	int i, nr;
-
-	buffer = container_of(work, struct perf_buffer, work);
-	nr = 1 << page_order(buffer);
-
-	base = buffer->user_page;
-	for (i = 0; i < nr + 1; i++)
-		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
-
-	vfree(base);
-	kfree(buffer);
-}
-
-static void perf_buffer_free(struct perf_buffer *buffer)
-{
-	schedule_work(&buffer->work);
-}
-
-static struct perf_buffer *
-perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
-{
-	struct perf_buffer *buffer;
-	unsigned long size;
-	void *all_buf;
-
-	size = sizeof(struct perf_buffer);
-	size += sizeof(void *);
-
-	buffer = kzalloc(size, GFP_KERNEL);
-	if (!buffer)
-		goto fail;
-
-	INIT_WORK(&buffer->work, perf_buffer_free_work);
-
-	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
-	if (!all_buf)
-		goto fail_all_buf;
-
-	buffer->user_page = all_buf;
-	buffer->data_pages[0] = all_buf + PAGE_SIZE;
-	buffer->page_order = ilog2(nr_pages);
-	buffer->nr_pages = 1;
-
-	perf_buffer_init(buffer, watermark, flags);
-
-	return buffer;
-
-fail_all_buf:
-	kfree(buffer);
-
-fail:
-	return NULL;
-}
-
-#endif
-
-static unsigned long perf_data_size(struct perf_buffer *buffer)
-{
-	return buffer->nr_pages << (PAGE_SHIFT + page_order(buffer));
-}
-
 static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct perf_event *event = vma->vm_file->private_data;
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 	int ret = VM_FAULT_SIGBUS;
 
 	if (vmf->flags & FAULT_FLAG_MKWRITE) {
@@ -3623,14 +3430,14 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 
 	rcu_read_lock();
-	buffer = rcu_dereference(event->buffer);
-	if (!buffer)
+	rb = rcu_dereference(event->rb);
+	if (!rb)
 		goto unlock;
 
 	if (vmf->pgoff && (vmf->flags & FAULT_FLAG_WRITE))
 		goto unlock;
 
-	vmf->page = perf_mmap_to_page(buffer, vmf->pgoff);
+	vmf->page = perf_mmap_to_page(rb, vmf->pgoff);
 	if (!vmf->page)
 		goto unlock;
 
@@ -3645,35 +3452,35 @@ unlock:
 	return ret;
 }
 
-static void perf_buffer_free_rcu(struct rcu_head *rcu_head)
+static void rb_free_rcu(struct rcu_head *rcu_head)
 {
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 
-	buffer = container_of(rcu_head, struct perf_buffer, rcu_head);
-	perf_buffer_free(buffer);
+	rb = container_of(rcu_head, struct ring_buffer, rcu_head);
+	rb_free(rb);
 }
 
-static struct perf_buffer *perf_buffer_get(struct perf_event *event)
+static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 {
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 
 	rcu_read_lock();
-	buffer = rcu_dereference(event->buffer);
-	if (buffer) {
-		if (!atomic_inc_not_zero(&buffer->refcount))
-			buffer = NULL;
+	rb = rcu_dereference(event->rb);
+	if (rb) {
+		if (!atomic_inc_not_zero(&rb->refcount))
+			rb = NULL;
 	}
 	rcu_read_unlock();
 
-	return buffer;
+	return rb;
 }
 
-static void perf_buffer_put(struct perf_buffer *buffer)
+static void ring_buffer_put(struct ring_buffer *rb)
 {
-	if (!atomic_dec_and_test(&buffer->refcount))
+	if (!atomic_dec_and_test(&rb->refcount))
 		return;
 
-	call_rcu(&buffer->rcu_head, perf_buffer_free_rcu);
+	call_rcu(&rb->rcu_head, rb_free_rcu);
 }
 
 static void perf_mmap_open(struct vm_area_struct *vma)
@@ -3688,16 +3495,16 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->buffer);
+		unsigned long size = perf_data_size(event->rb);
 		struct user_struct *user = event->mmap_user;
-		struct perf_buffer *buffer = event->buffer;
+		struct ring_buffer *rb = event->rb;
 
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
 		vma->vm_mm->locked_vm -= event->mmap_locked;
-		rcu_assign_pointer(event->buffer, NULL);
+		rcu_assign_pointer(event->rb, NULL);
 		mutex_unlock(&event->mmap_mutex);
 
-		perf_buffer_put(buffer);
+		ring_buffer_put(rb);
 		free_uid(user);
 	}
 }
@@ -3715,7 +3522,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
 	unsigned long locked, lock_limit;
-	struct perf_buffer *buffer;
+	struct ring_buffer *rb;
 	unsigned long vma_size;
 	unsigned long nr_pages;
 	long user_extra, extra;
@@ -3724,7 +3531,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	/*
 	 * Don't allow mmap() of inherited per-task counters. This would
 	 * create a performance issue due to all children writing to the
-	 * same buffer.
+	 * same rb.
 	 */
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
@@ -3736,7 +3543,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
 	/*
-	 * If we have buffer pages ensure they're a power-of-two number, so we
+	 * If we have rb pages ensure they're a power-of-two number, so we
 	 * can do bitmasks instead of modulo.
 	 */
 	if (nr_pages != 0 && !is_power_of_2(nr_pages))
@@ -3750,9 +3557,9 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	mutex_lock(&event->mmap_mutex);
-	if (event->buffer) {
-		if (event->buffer->nr_pages == nr_pages)
-			atomic_inc(&event->buffer->refcount);
+	if (event->rb) {
+		if (event->rb->nr_pages == nr_pages)
+			atomic_inc(&event->rb->refcount);
 		else
 			ret = -EINVAL;
 		goto unlock;
@@ -3782,18 +3589,20 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		goto unlock;
 	}
 
-	WARN_ON(event->buffer);
+	WARN_ON(event->rb);
 
 	if (vma->vm_flags & VM_WRITE)
-		flags |= PERF_BUFFER_WRITABLE;
+		flags |= RING_BUFFER_WRITABLE;
 
-	buffer = perf_buffer_alloc(nr_pages, event->attr.wakeup_watermark,
-				   event->cpu, flags);
-	if (!buffer) {
+	rb = rb_alloc(nr_pages, 
+		event->attr.watermark ? event->attr.wakeup_watermark : 0,
+		event->cpu, flags);
+
+	if (!rb) {
 		ret = -ENOMEM;
 		goto unlock;
 	}
-	rcu_assign_pointer(event->buffer, buffer);
+	rcu_assign_pointer(event->rb, rb);
 
 	atomic_long_add(user_extra, &user->locked_vm);
 	event->mmap_locked = extra;
@@ -3892,117 +3701,6 @@ int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
 
-/*
- * Output
- */
-static bool perf_output_space(struct perf_buffer *buffer, unsigned long tail,
-			      unsigned long offset, unsigned long head)
-{
-	unsigned long mask;
-
-	if (!buffer->writable)
-		return true;
-
-	mask = perf_data_size(buffer) - 1;
-
-	offset = (offset - tail) & mask;
-	head   = (head   - tail) & mask;
-
-	if ((int)(head - offset) < 0)
-		return false;
-
-	return true;
-}
-
-static void perf_output_wakeup(struct perf_output_handle *handle)
-{
-	atomic_set(&handle->buffer->poll, POLL_IN);
-
-	if (handle->nmi) {
-		handle->event->pending_wakeup = 1;
-		irq_work_queue(&handle->event->pending);
-	} else
-		perf_event_wakeup(handle->event);
-}
-
-/*
- * We need to ensure a later event_id doesn't publish a head when a former
- * event isn't done writing. However since we need to deal with NMIs we
- * cannot fully serialize things.
- *
- * We only publish the head (and generate a wakeup) when the outer-most
- * event completes.
- */
-static void perf_output_get_handle(struct perf_output_handle *handle)
-{
-	struct perf_buffer *buffer = handle->buffer;
-
-	preempt_disable();
-	local_inc(&buffer->nest);
-	handle->wakeup = local_read(&buffer->wakeup);
-}
-
-static void perf_output_put_handle(struct perf_output_handle *handle)
-{
-	struct perf_buffer *buffer = handle->buffer;
-	unsigned long head;
-
-again:
-	head = local_read(&buffer->head);
-
-	/*
-	 * IRQ/NMI can happen here, which means we can miss a head update.
-	 */
-
-	if (!local_dec_and_test(&buffer->nest))
-		goto out;
-
-	/*
-	 * Publish the known good head. Rely on the full barrier implied
-	 * by atomic_dec_and_test() order the buffer->head read and this
-	 * write.
-	 */
-	buffer->user_page->data_head = head;
-
-	/*
-	 * Now check if we missed an update, rely on the (compiler)
-	 * barrier in atomic_dec_and_test() to re-read buffer->head.
-	 */
-	if (unlikely(head != local_read(&buffer->head))) {
-		local_inc(&buffer->nest);
-		goto again;
-	}
-
-	if (handle->wakeup != local_read(&buffer->wakeup))
-		perf_output_wakeup(handle);
-
-out:
-	preempt_enable();
-}
-
-__always_inline void perf_output_copy(struct perf_output_handle *handle,
-		      const void *buf, unsigned int len)
-{
-	do {
-		unsigned long size = min_t(unsigned long, handle->size, len);
-
-		memcpy(handle->addr, buf, size);
-
-		len -= size;
-		handle->addr += size;
-		buf += size;
-		handle->size -= size;
-		if (!handle->size) {
-			struct perf_buffer *buffer = handle->buffer;
-
-			handle->page++;
-			handle->page &= buffer->nr_pages - 1;
-			handle->addr = buffer->data_pages[handle->page];
-			handle->size = PAGE_SIZE << page_order(buffer);
-		}
-	} while (len);
-}
-
 static void __perf_event_header__init_id(struct perf_event_header *header,
 					 struct perf_sample_data *data,
 					 struct perf_event *event)
@@ -4033,9 +3731,9 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
 	}
 }
 
-static void perf_event_header__init_id(struct perf_event_header *header,
-				       struct perf_sample_data *data,
-				       struct perf_event *event)
+void perf_event_header__init_id(struct perf_event_header *header,
+				struct perf_sample_data *data,
+				struct perf_event *event)
 {
 	if (event->attr.sample_id_all)
 		__perf_event_header__init_id(header, data, event);
@@ -4062,121 +3760,14 @@ static void __perf_event__output_id_sample(struct perf_output_handle *handle,
 		perf_output_put(handle, data->cpu_entry);
 }
 
-static void perf_event__output_id_sample(struct perf_event *event,
-					 struct perf_output_handle *handle,
-					 struct perf_sample_data *sample)
+void perf_event__output_id_sample(struct perf_event *event,
+				  struct perf_output_handle *handle,
+				  struct perf_sample_data *sample)
 {
 	if (event->attr.sample_id_all)
 		__perf_event__output_id_sample(handle, sample);
 }
 
-int perf_output_begin(struct perf_output_handle *handle,
-		      struct perf_event *event, unsigned int size,
-		      int nmi, int sample)
-{
-	struct perf_buffer *buffer;
-	unsigned long tail, offset, head;
-	int have_lost;
-	struct perf_sample_data sample_data;
-	struct {
-		struct perf_event_header header;
-		u64			 id;
-		u64			 lost;
-	} lost_event;
-
-	rcu_read_lock();
-	/*
-	 * For inherited events we send all the output towards the parent.
-	 */
-	if (event->parent)
-		event = event->parent;
-
-	buffer = rcu_dereference(event->buffer);
-	if (!buffer)
-		goto out;
-
-	handle->buffer	= buffer;
-	handle->event	= event;
-	handle->nmi	= nmi;
-	handle->sample	= sample;
-
-	if (!buffer->nr_pages)
-		goto out;
-
-	have_lost = local_read(&buffer->lost);
-	if (have_lost) {
-		lost_event.header.size = sizeof(lost_event);
-		perf_event_header__init_id(&lost_event.header, &sample_data,
-					   event);
-		size += lost_event.header.size;
-	}
-
-	perf_output_get_handle(handle);
-
-	do {
-		/*
-		 * Userspace could choose to issue a mb() before updating the
-		 * tail pointer. So that all reads will be completed before the
-		 * write is issued.
-		 */
-		tail = ACCESS_ONCE(buffer->user_page->data_tail);
-		smp_rmb();
-		offset = head = local_read(&buffer->head);
-		head += size;
-		if (unlikely(!perf_output_space(buffer, tail, offset, head)))
-			goto fail;
-	} while (local_cmpxchg(&buffer->head, offset, head) != offset);
-
-	if (head - local_read(&buffer->wakeup) > buffer->watermark)
-		local_add(buffer->watermark, &buffer->wakeup);
-
-	handle->page = offset >> (PAGE_SHIFT + page_order(buffer));
-	handle->page &= buffer->nr_pages - 1;
-	handle->size = offset & ((PAGE_SIZE << page_order(buffer)) - 1);
-	handle->addr = buffer->data_pages[handle->page];
-	handle->addr += handle->size;
-	handle->size = (PAGE_SIZE << page_order(buffer)) - handle->size;
-
-	if (have_lost) {
-		lost_event.header.type = PERF_RECORD_LOST;
-		lost_event.header.misc = 0;
-		lost_event.id          = event->id;
-		lost_event.lost        = local_xchg(&buffer->lost, 0);
-
-		perf_output_put(handle, lost_event);
-		perf_event__output_id_sample(event, handle, &sample_data);
-	}
-
-	return 0;
-
-fail:
-	local_inc(&buffer->lost);
-	perf_output_put_handle(handle);
-out:
-	rcu_read_unlock();
-
-	return -ENOSPC;
-}
-
-void perf_output_end(struct perf_output_handle *handle)
-{
-	struct perf_event *event = handle->event;
-	struct perf_buffer *buffer = handle->buffer;
-
-	int wakeup_events = event->attr.wakeup_events;
-
-	if (handle->sample && wakeup_events) {
-		int events = local_inc_return(&buffer->events);
-		if (events >= wakeup_events) {
-			local_sub(wakeup_events, &buffer->events);
-			local_inc(&buffer->wakeup);
-		}
-	}
-
-	perf_output_put_handle(handle);
-	rcu_read_unlock();
-}
-
 static void perf_output_read_one(struct perf_output_handle *handle,
 				 struct perf_event *event,
 				 u64 enabled, u64 running)
@@ -4197,7 +3788,7 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(event);
 
-	perf_output_copy(handle, values, n * sizeof(u64));
+	__output_copy(handle, values, n * sizeof(u64));
 }
 
 /*
@@ -4227,7 +3818,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
 
-	perf_output_copy(handle, values, n * sizeof(u64));
+	__output_copy(handle, values, n * sizeof(u64));
 
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		n = 0;
@@ -4239,7 +3830,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
 
-		perf_output_copy(handle, values, n * sizeof(u64));
+		__output_copy(handle, values, n * sizeof(u64));
 	}
 }
 
@@ -4249,7 +3840,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 static void perf_output_read(struct perf_output_handle *handle,
 			     struct perf_event *event)
 {
-	u64 enabled = 0, running = 0, now, ctx_time;
+	u64 enabled = 0, running = 0;
 	u64 read_format = event->attr.read_format;
 
 	/*
@@ -4261,12 +3852,8 @@ static void perf_output_read(struct perf_output_handle *handle,
 	 * because of locking issue as we are called in
 	 * NMI context
 	 */
-	if (read_format & PERF_FORMAT_TOTAL_TIMES) {
-		now = perf_clock();
-		ctx_time = event->shadow_ctx_time + now;
-		enabled = ctx_time - event->tstamp_enabled;
-		running = ctx_time - event->tstamp_running;
-	}
+	if (read_format & PERF_FORMAT_TOTAL_TIMES)
+		calc_timer_values(event, &enabled, &running);
 
 	if (event->attr.read_format & PERF_FORMAT_GROUP)
 		perf_output_read_group(handle, event, enabled, running);
@@ -4319,7 +3906,7 @@ void perf_output_sample(struct perf_output_handle *handle,
 
 			size *= sizeof(u64);
 
-			perf_output_copy(handle, data->callchain, size);
+			__output_copy(handle, data->callchain, size);
 		} else {
 			u64 nr = 0;
 			perf_output_put(handle, nr);
@@ -4329,8 +3916,8 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_RAW) {
 		if (data->raw) {
 			perf_output_put(handle, data->raw->size);
-			perf_output_copy(handle, data->raw->data,
-					 data->raw->size);
+			__output_copy(handle, data->raw->data,
+					   data->raw->size);
 		} else {
 			struct {
 				u32	size;
@@ -4342,6 +3929,20 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, raw);
 		}
 	}
+
+	if (!event->attr.watermark) {
+		int wakeup_events = event->attr.wakeup_events;
+
+		if (wakeup_events) {
+			struct ring_buffer *rb = handle->rb;
+			int events = local_inc_return(&rb->events);
+
+			if (events >= wakeup_events) {
+				local_sub(wakeup_events, &rb->events);
+				local_inc(&rb->wakeup);
+			}
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -4386,7 +3987,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 	}
 }
 
-static void perf_event_output(struct perf_event *event, int nmi,
+static void perf_event_output(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
@@ -4398,7 +3999,7 @@ static void perf_event_output(struct perf_event *event, int nmi,
 
 	perf_prepare_sample(&header, data, event, regs);
 
-	if (perf_output_begin(&handle, event, header.size, nmi, 1))
+	if (perf_output_begin(&handle, event, header.size))
 		goto exit;
 
 	perf_output_sample(&handle, &header, data, event);
@@ -4438,7 +4039,7 @@ perf_event_read_event(struct perf_event *event,
 	int ret;
 
 	perf_event_header__init_id(&read_event.header, &sample, event);
-	ret = perf_output_begin(&handle, event, read_event.header.size, 0, 0);
+	ret = perf_output_begin(&handle, event, read_event.header.size);
 	if (ret)
 		return;
 
@@ -4481,7 +4082,7 @@ static void perf_event_task_output(struct perf_event *event,
 	perf_event_header__init_id(&task_event->event_id.header, &sample, event);
 
 	ret = perf_output_begin(&handle, event,
-				task_event->event_id.header.size, 0, 0);
+				task_event->event_id.header.size);
 	if (ret)
 		goto out;
 
@@ -4618,7 +4219,7 @@ static void perf_event_comm_output(struct perf_event *event,
 
 	perf_event_header__init_id(&comm_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
-				comm_event->event_id.header.size, 0, 0);
+				comm_event->event_id.header.size);
 
 	if (ret)
 		goto out;
@@ -4627,7 +4228,7 @@ static void perf_event_comm_output(struct perf_event *event,
 	comm_event->event_id.tid = perf_event_tid(event, comm_event->task);
 
 	perf_output_put(&handle, comm_event->event_id);
-	perf_output_copy(&handle, comm_event->comm,
+	__output_copy(&handle, comm_event->comm,
 				   comm_event->comm_size);
 
 	perf_event__output_id_sample(event, &handle, &sample);
@@ -4765,7 +4366,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
-				mmap_event->event_id.header.size, 0, 0);
+				mmap_event->event_id.header.size);
 	if (ret)
 		goto out;
 
@@ -4773,7 +4374,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 	mmap_event->event_id.tid = perf_event_tid(event, current);
 
 	perf_output_put(&handle, mmap_event->event_id);
-	perf_output_copy(&handle, mmap_event->file_name,
+	__output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
 
 	perf_event__output_id_sample(event, &handle, &sample);
@@ -4829,7 +4430,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 
 	if (file) {
 		/*
-		 * d_path works from the end of the buffer backwards, so we
+		 * d_path works from the end of the rb backwards, so we
 		 * need to add enough zero bytes after the string to handle
 		 * the 64bit alignment we do later.
 		 */
@@ -4960,7 +4561,7 @@ static void perf_log_throttle(struct perf_event *event, int enable)
 	perf_event_header__init_id(&throttle_event.header, &sample, event);
 
 	ret = perf_output_begin(&handle, event,
-				throttle_event.header.size, 1, 0);
+				throttle_event.header.size);
 	if (ret)
 		return;
 
@@ -4973,7 +4574,7 @@ static void perf_log_throttle(struct perf_event *event, int enable)
  * Generic event overflow handling, sampling.
  */
 
-static int __perf_event_overflow(struct perf_event *event, int nmi,
+static int __perf_event_overflow(struct perf_event *event,
 				   int throttle, struct perf_sample_data *data,
 				   struct pt_regs *regs)
 {
@@ -5016,34 +4617,28 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	if (events && atomic_dec_and_test(&event->event_limit)) {
 		ret = 1;
 		event->pending_kill = POLL_HUP;
-		if (nmi) {
-			event->pending_disable = 1;
-			irq_work_queue(&event->pending);
-		} else
-			perf_event_disable(event);
+		event->pending_disable = 1;
+		irq_work_queue(&event->pending);
 	}
 
 	if (event->overflow_handler)
-		event->overflow_handler(event, nmi, data, regs);
+		event->overflow_handler(event, data, regs);
 	else
-		perf_event_output(event, nmi, data, regs);
+		perf_event_output(event, data, regs);
 
 	if (event->fasync && event->pending_kill) {
-		if (nmi) {
-			event->pending_wakeup = 1;
-			irq_work_queue(&event->pending);
-		} else
-			perf_event_wakeup(event);
+		event->pending_wakeup = 1;
+		irq_work_queue(&event->pending);
 	}
 
 	return ret;
 }
 
-int perf_event_overflow(struct perf_event *event, int nmi,
+int perf_event_overflow(struct perf_event *event,
 			  struct perf_sample_data *data,
 			  struct pt_regs *regs)
 {
-	return __perf_event_overflow(event, nmi, 1, data, regs);
+	return __perf_event_overflow(event, 1, data, regs);
 }
 
 /*
@@ -5092,7 +4687,7 @@ again:
 }
 
 static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
-				    int nmi, struct perf_sample_data *data,
+				    struct perf_sample_data *data,
 				    struct pt_regs *regs)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -5106,7 +4701,7 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 		return;
 
 	for (; overflow; overflow--) {
-		if (__perf_event_overflow(event, nmi, throttle,
+		if (__perf_event_overflow(event, throttle,
 					    data, regs)) {
 			/*
 			 * We inhibit the overflow from happening when
@@ -5119,7 +4714,7 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 }
 
 static void perf_swevent_event(struct perf_event *event, u64 nr,
-			       int nmi, struct perf_sample_data *data,
+			       struct perf_sample_data *data,
 			       struct pt_regs *regs)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -5133,12 +4728,12 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
 		return;
 
 	if (nr == 1 && hwc->sample_period == 1 && !event->attr.freq)
-		return perf_swevent_overflow(event, 1, nmi, data, regs);
+		return perf_swevent_overflow(event, 1, data, regs);
 
 	if (local64_add_negative(nr, &hwc->period_left))
 		return;
 
-	perf_swevent_overflow(event, 0, nmi, data, regs);
+	perf_swevent_overflow(event, 0, data, regs);
 }
 
 static int perf_exclude_event(struct perf_event *event,
@@ -5226,7 +4821,7 @@ find_swevent_head(struct swevent_htable *swhash, struct perf_event *event)
 }
 
 static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
-				    u64 nr, int nmi,
+				    u64 nr,
 				    struct perf_sample_data *data,
 				    struct pt_regs *regs)
 {
@@ -5242,7 +4837,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 
 	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
 		if (perf_swevent_match(event, type, event_id, data, regs))
-			perf_swevent_event(event, nr, nmi, data, regs);
+			perf_swevent_event(event, nr, data, regs);
 	}
 end:
 	rcu_read_unlock();
@@ -5263,8 +4858,7 @@ inline void perf_swevent_put_recursion_context(int rctx)
 	put_recursion_context(swhash->recursion, rctx);
 }
 
-void __perf_sw_event(u32 event_id, u64 nr, int nmi,
-			    struct pt_regs *regs, u64 addr)
+void __perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data;
 	int rctx;
@@ -5276,7 +4870,7 @@ void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 
 	perf_sample_data_init(&data, addr);
 
-	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs);
+	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, &data, regs);
 
 	perf_swevent_put_recursion_context(rctx);
 	preempt_enable_notrace();
@@ -5524,7 +5118,7 @@ void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
 
 	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
 		if (perf_tp_event_match(event, &data, regs))
-			perf_swevent_event(event, count, 1, &data, regs);
+			perf_swevent_event(event, count, &data, regs);
 	}
 
 	perf_swevent_put_recursion_context(rctx);
@@ -5617,7 +5211,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	perf_sample_data_init(&sample, bp->attr.bp_addr);
 
 	if (!bp->hw.state && !perf_exclude_event(bp, regs))
-		perf_swevent_event(bp, 1, 1, &sample, regs);
+		perf_swevent_event(bp, 1, &sample, regs);
 }
 #endif
 
@@ -5646,7 +5240,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 
 	if (regs && !perf_exclude_event(event, regs)) {
 		if (!(event->attr.exclude_idle && current->pid == 0))
-			if (perf_event_overflow(event, 0, &data, regs))
+			if (perf_event_overflow(event, &data, regs))
 				ret = HRTIMER_NORESTART;
 	}
 
@@ -5986,6 +5580,7 @@ free_dev:
 }
 
 static struct lock_class_key cpuctx_mutex;
+static struct lock_class_key cpuctx_lock;
 
 int perf_pmu_register(struct pmu *pmu, char *name, int type)
 {
@@ -6036,6 +5631,7 @@ skip_type:
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		__perf_event_init_context(&cpuctx->ctx);
 		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
+		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
@@ -6150,7 +5746,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		 struct task_struct *task,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
-		 perf_overflow_handler_t overflow_handler)
+		 perf_overflow_handler_t overflow_handler,
+		 void *context)
 {
 	struct pmu *pmu;
 	struct perf_event *event;
@@ -6208,10 +5805,13 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 #endif
 	}
 
-	if (!overflow_handler && parent_event)
+	if (!overflow_handler && parent_event) {
 		overflow_handler = parent_event->overflow_handler;
+		context = parent_event->overflow_handler_context;
+	}
 
 	event->overflow_handler	= overflow_handler;
+	event->overflow_handler_context = context;
 
 	if (attr->disabled)
 		event->state = PERF_EVENT_STATE_OFF;
@@ -6326,13 +5926,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
-	/*
-	 * If the type exists, the corresponding creation will verify
-	 * the attr->config.
-	 */
-	if (attr->type >= PERF_TYPE_MAX)
-		return -EINVAL;
-
 	if (attr->__reserved_1)
 		return -EINVAL;
 
@@ -6354,7 +5947,7 @@ err_size:
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct perf_buffer *buffer = NULL, *old_buffer = NULL;
+	struct ring_buffer *rb = NULL, *old_rb = NULL;
 	int ret = -EINVAL;
 
 	if (!output_event)
@@ -6371,7 +5964,7 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 		goto out;
 
 	/*
-	 * If its not a per-cpu buffer, it must be the same task.
+	 * If its not a per-cpu rb, it must be the same task.
 	 */
 	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
 		goto out;
@@ -6383,20 +5976,20 @@ set:
 		goto unlock;
 
 	if (output_event) {
-		/* get the buffer we want to redirect to */
-		buffer = perf_buffer_get(output_event);
-		if (!buffer)
+		/* get the rb we want to redirect to */
+		rb = ring_buffer_get(output_event);
+		if (!rb)
 			goto unlock;
 	}
 
-	old_buffer = event->buffer;
-	rcu_assign_pointer(event->buffer, buffer);
+	old_rb = event->rb;
+	rcu_assign_pointer(event->rb, rb);
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
 
-	if (old_buffer)
-		perf_buffer_put(old_buffer);
+	if (old_rb)
+		ring_buffer_put(old_rb);
 out:
 	return ret;
 }
@@ -6478,7 +6071,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL, NULL);
+	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
+				 NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_task;
@@ -6663,7 +6257,8 @@ err_fd:
 struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 				 struct task_struct *task,
-				 perf_overflow_handler_t overflow_handler)
+				 perf_overflow_handler_t overflow_handler,
+				 void *context)
 {
 	struct perf_event_context *ctx;
 	struct perf_event *event;
@@ -6673,7 +6268,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, task, NULL, NULL, overflow_handler);
+	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
+				 overflow_handler, context);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -6780,7 +6376,6 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * our context.
 	 */
 	child_ctx = rcu_dereference_raw(child->perf_event_ctxp[ctxn]);
-	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*
 	 * Take the context lock here so that if find_get_context is
@@ -6788,6 +6383,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	raw_spin_lock(&child_ctx->lock);
+	task_ctx_sched_out(child_ctx);
 	child->perf_event_ctxp[ctxn] = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
@@ -6957,7 +6553,7 @@ inherit_event(struct perf_event *parent_event,
 					   parent_event->cpu,
 					   child,
 					   group_leader, parent_event,
-					   NULL);
+				           NULL, NULL);
 	if (IS_ERR(child_event))
 		return child_event;
 	get_ctx(child_ctx);
@@ -6984,6 +6580,8 @@ inherit_event(struct perf_event *parent_event,
 
 	child_event->ctx = child_ctx;
 	child_event->overflow_handler = parent_event->overflow_handler;
+	child_event->overflow_handler_context
+		= parent_event->overflow_handler_context;
 
 	/*
 	 * Precalculate sample_data sizes
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 086adf2..b7971d6 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -431,9 +431,11 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
 struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
+			    void *context,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, tsk, triggered);
+	return perf_event_create_kernel_counter(attr, -1, tsk, triggered,
+						context);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
@@ -502,7 +504,8 @@ EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
  */
 struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_overflow_handler_t triggered)
+			    perf_overflow_handler_t triggered,
+			    void *context)
 {
 	struct perf_event * __percpu *cpu_events, **pevent, *bp;
 	long err;
@@ -515,7 +518,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		pevent = per_cpu_ptr(cpu_events, cpu);
-		bp = perf_event_create_kernel_counter(attr, cpu, NULL, triggered);
+		bp = perf_event_create_kernel_counter(attr, cpu, NULL,
+						      triggered, context);
 
 		*pevent = bp;
 
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
new file mode 100644
index 0000000..09097dd
--- /dev/null
+++ b/kernel/events/internal.h
@@ -0,0 +1,96 @@
+#ifndef _KERNEL_EVENTS_INTERNAL_H
+#define _KERNEL_EVENTS_INTERNAL_H
+
+#define RING_BUFFER_WRITABLE		0x01
+
+struct ring_buffer {
+	atomic_t			refcount;
+	struct rcu_head			rcu_head;
+#ifdef CONFIG_PERF_USE_VMALLOC
+	struct work_struct		work;
+	int				page_order;	/* allocation order  */
+#endif
+	int				nr_pages;	/* nr of data pages  */
+	int				writable;	/* are we writable   */
+
+	atomic_t			poll;		/* POLL_ for wakeups */
+
+	local_t				head;		/* write position    */
+	local_t				nest;		/* nested writers    */
+	local_t				events;		/* event limit       */
+	local_t				wakeup;		/* wakeup stamp      */
+	local_t				lost;		/* nr records lost   */
+
+	long				watermark;	/* wakeup watermark  */
+
+	struct perf_event_mmap_page	*user_page;
+	void				*data_pages[0];
+};
+
+extern void rb_free(struct ring_buffer *rb);
+extern struct ring_buffer *
+rb_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void perf_event_wakeup(struct perf_event *event);
+
+extern void
+perf_event_header__init_id(struct perf_event_header *header,
+			   struct perf_sample_data *data,
+			   struct perf_event *event);
+extern void
+perf_event__output_id_sample(struct perf_event *event,
+			     struct perf_output_handle *handle,
+			     struct perf_sample_data *sample);
+
+extern struct page *
+perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff);
+
+#ifdef CONFIG_PERF_USE_VMALLOC
+/*
+ * Back perf_mmap() with vmalloc memory.
+ *
+ * Required for architectures that have d-cache aliasing issues.
+ */
+
+static inline int page_order(struct ring_buffer *rb)
+{
+	return rb->page_order;
+}
+
+#else
+
+static inline int page_order(struct ring_buffer *rb)
+{
+	return 0;
+}
+#endif
+
+static unsigned long perf_data_size(struct ring_buffer *rb)
+{
+	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
+}
+
+static inline void
+__output_copy(struct perf_output_handle *handle,
+		   const void *buf, unsigned int len)
+{
+	do {
+		unsigned long size = min_t(unsigned long, handle->size, len);
+
+		memcpy(handle->addr, buf, size);
+
+		len -= size;
+		handle->addr += size;
+		buf += size;
+		handle->size -= size;
+		if (!handle->size) {
+			struct ring_buffer *rb = handle->rb;
+
+			handle->page++;
+			handle->page &= rb->nr_pages - 1;
+			handle->addr = rb->data_pages[handle->page];
+			handle->size = PAGE_SIZE << page_order(rb);
+		}
+	} while (len);
+}
+
+#endif /* _KERNEL_EVENTS_INTERNAL_H */
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
new file mode 100644
index 0000000..a2a2920
--- /dev/null
+++ b/kernel/events/ring_buffer.c
@@ -0,0 +1,380 @@
+/*
+ * Performance events ring-buffer code:
+ *
+ *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright  �  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *
+ * For licensing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_event.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+
+#include "internal.h"
+
+static bool perf_output_space(struct ring_buffer *rb, unsigned long tail,
+			      unsigned long offset, unsigned long head)
+{
+	unsigned long mask;
+
+	if (!rb->writable)
+		return true;
+
+	mask = perf_data_size(rb) - 1;
+
+	offset = (offset - tail) & mask;
+	head   = (head   - tail) & mask;
+
+	if ((int)(head - offset) < 0)
+		return false;
+
+	return true;
+}
+
+static void perf_output_wakeup(struct perf_output_handle *handle)
+{
+	atomic_set(&handle->rb->poll, POLL_IN);
+
+	handle->event->pending_wakeup = 1;
+	irq_work_queue(&handle->event->pending);
+}
+
+/*
+ * We need to ensure a later event_id doesn't publish a head when a former
+ * event isn't done writing. However since we need to deal with NMIs we
+ * cannot fully serialize things.
+ *
+ * We only publish the head (and generate a wakeup) when the outer-most
+ * event completes.
+ */
+static void perf_output_get_handle(struct perf_output_handle *handle)
+{
+	struct ring_buffer *rb = handle->rb;
+
+	preempt_disable();
+	local_inc(&rb->nest);
+	handle->wakeup = local_read(&rb->wakeup);
+}
+
+static void perf_output_put_handle(struct perf_output_handle *handle)
+{
+	struct ring_buffer *rb = handle->rb;
+	unsigned long head;
+
+again:
+	head = local_read(&rb->head);
+
+	/*
+	 * IRQ/NMI can happen here, which means we can miss a head update.
+	 */
+
+	if (!local_dec_and_test(&rb->nest))
+		goto out;
+
+	/*
+	 * Publish the known good head. Rely on the full barrier implied
+	 * by atomic_dec_and_test() order the rb->head read and this
+	 * write.
+	 */
+	rb->user_page->data_head = head;
+
+	/*
+	 * Now check if we missed an update, rely on the (compiler)
+	 * barrier in atomic_dec_and_test() to re-read rb->head.
+	 */
+	if (unlikely(head != local_read(&rb->head))) {
+		local_inc(&rb->nest);
+		goto again;
+	}
+
+	if (handle->wakeup != local_read(&rb->wakeup))
+		perf_output_wakeup(handle);
+
+out:
+	preempt_enable();
+}
+
+int perf_output_begin(struct perf_output_handle *handle,
+		      struct perf_event *event, unsigned int size)
+{
+	struct ring_buffer *rb;
+	unsigned long tail, offset, head;
+	int have_lost;
+	struct perf_sample_data sample_data;
+	struct {
+		struct perf_event_header header;
+		u64			 id;
+		u64			 lost;
+	} lost_event;
+
+	rcu_read_lock();
+	/*
+	 * For inherited events we send all the output towards the parent.
+	 */
+	if (event->parent)
+		event = event->parent;
+
+	rb = rcu_dereference(event->rb);
+	if (!rb)
+		goto out;
+
+	handle->rb	= rb;
+	handle->event	= event;
+
+	if (!rb->nr_pages)
+		goto out;
+
+	have_lost = local_read(&rb->lost);
+	if (have_lost) {
+		lost_event.header.size = sizeof(lost_event);
+		perf_event_header__init_id(&lost_event.header, &sample_data,
+					   event);
+		size += lost_event.header.size;
+	}
+
+	perf_output_get_handle(handle);
+
+	do {
+		/*
+		 * Userspace could choose to issue a mb() before updating the
+		 * tail pointer. So that all reads will be completed before the
+		 * write is issued.
+		 */
+		tail = ACCESS_ONCE(rb->user_page->data_tail);
+		smp_rmb();
+		offset = head = local_read(&rb->head);
+		head += size;
+		if (unlikely(!perf_output_space(rb, tail, offset, head)))
+			goto fail;
+	} while (local_cmpxchg(&rb->head, offset, head) != offset);
+
+	if (head - local_read(&rb->wakeup) > rb->watermark)
+		local_add(rb->watermark, &rb->wakeup);
+
+	handle->page = offset >> (PAGE_SHIFT + page_order(rb));
+	handle->page &= rb->nr_pages - 1;
+	handle->size = offset & ((PAGE_SIZE << page_order(rb)) - 1);
+	handle->addr = rb->data_pages[handle->page];
+	handle->addr += handle->size;
+	handle->size = (PAGE_SIZE << page_order(rb)) - handle->size;
+
+	if (have_lost) {
+		lost_event.header.type = PERF_RECORD_LOST;
+		lost_event.header.misc = 0;
+		lost_event.id          = event->id;
+		lost_event.lost        = local_xchg(&rb->lost, 0);
+
+		perf_output_put(handle, lost_event);
+		perf_event__output_id_sample(event, handle, &sample_data);
+	}
+
+	return 0;
+
+fail:
+	local_inc(&rb->lost);
+	perf_output_put_handle(handle);
+out:
+	rcu_read_unlock();
+
+	return -ENOSPC;
+}
+
+void perf_output_copy(struct perf_output_handle *handle,
+		      const void *buf, unsigned int len)
+{
+	__output_copy(handle, buf, len);
+}
+
+void perf_output_end(struct perf_output_handle *handle)
+{
+	perf_output_put_handle(handle);
+	rcu_read_unlock();
+}
+
+static void
+ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
+{
+	long max_size = perf_data_size(rb);
+
+	if (watermark)
+		rb->watermark = min(max_size, watermark);
+
+	if (!rb->watermark)
+		rb->watermark = max_size / 2;
+
+	if (flags & RING_BUFFER_WRITABLE)
+		rb->writable = 1;
+
+	atomic_set(&rb->refcount, 1);
+}
+
+#ifndef CONFIG_PERF_USE_VMALLOC
+
+/*
+ * Back perf_mmap() with regular GFP_KERNEL-0 pages.
+ */
+
+struct page *
+perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+{
+	if (pgoff > rb->nr_pages)
+		return NULL;
+
+	if (pgoff == 0)
+		return virt_to_page(rb->user_page);
+
+	return virt_to_page(rb->data_pages[pgoff - 1]);
+}
+
+static void *perf_mmap_alloc_page(int cpu)
+{
+	struct page *page;
+	int node;
+
+	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
+	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
+struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+{
+	struct ring_buffer *rb;
+	unsigned long size;
+	int i;
+
+	size = sizeof(struct ring_buffer);
+	size += nr_pages * sizeof(void *);
+
+	rb = kzalloc(size, GFP_KERNEL);
+	if (!rb)
+		goto fail;
+
+	rb->user_page = perf_mmap_alloc_page(cpu);
+	if (!rb->user_page)
+		goto fail_user_page;
+
+	for (i = 0; i < nr_pages; i++) {
+		rb->data_pages[i] = perf_mmap_alloc_page(cpu);
+		if (!rb->data_pages[i])
+			goto fail_data_pages;
+	}
+
+	rb->nr_pages = nr_pages;
+
+	ring_buffer_init(rb, watermark, flags);
+
+	return rb;
+
+fail_data_pages:
+	for (i--; i >= 0; i--)
+		free_page((unsigned long)rb->data_pages[i]);
+
+	free_page((unsigned long)rb->user_page);
+
+fail_user_page:
+	kfree(rb);
+
+fail:
+	return NULL;
+}
+
+static void perf_mmap_free_page(unsigned long addr)
+{
+	struct page *page = virt_to_page((void *)addr);
+
+	page->mapping = NULL;
+	__free_page(page);
+}
+
+void rb_free(struct ring_buffer *rb)
+{
+	int i;
+
+	perf_mmap_free_page((unsigned long)rb->user_page);
+	for (i = 0; i < rb->nr_pages; i++)
+		perf_mmap_free_page((unsigned long)rb->data_pages[i]);
+	kfree(rb);
+}
+
+#else
+
+struct page *
+perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+{
+	if (pgoff > (1UL << page_order(rb)))
+		return NULL;
+
+	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
+}
+
+static void perf_mmap_unmark_page(void *addr)
+{
+	struct page *page = vmalloc_to_page(addr);
+
+	page->mapping = NULL;
+}
+
+static void rb_free_work(struct work_struct *work)
+{
+	struct ring_buffer *rb;
+	void *base;
+	int i, nr;
+
+	rb = container_of(work, struct ring_buffer, work);
+	nr = 1 << page_order(rb);
+
+	base = rb->user_page;
+	for (i = 0; i < nr + 1; i++)
+		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
+
+	vfree(base);
+	kfree(rb);
+}
+
+void rb_free(struct ring_buffer *rb)
+{
+	schedule_work(&rb->work);
+}
+
+struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+{
+	struct ring_buffer *rb;
+	unsigned long size;
+	void *all_buf;
+
+	size = sizeof(struct ring_buffer);
+	size += sizeof(void *);
+
+	rb = kzalloc(size, GFP_KERNEL);
+	if (!rb)
+		goto fail;
+
+	INIT_WORK(&rb->work, rb_free_work);
+
+	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
+	if (!all_buf)
+		goto fail_all_buf;
+
+	rb->user_page = all_buf;
+	rb->data_pages[0] = all_buf + PAGE_SIZE;
+	rb->page_order = ilog2(nr_pages);
+	rb->nr_pages = 1;
+
+	ring_buffer_init(rb, watermark, flags);
+
+	return rb;
+
+fail_all_buf:
+	kfree(rb);
+
+fail:
+	return NULL;
+}
+
+#endif
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 7798181..b30fd54 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1255,19 +1255,29 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
 /*
  * If we have a symbol_name argument, look it up and add the offset field
  * to it. This way, we can specify a relative address to a symbol.
+ * This returns encoded errors if it fails to look up symbol or invalid
+ * combination of parameters.
  */
 static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
 {
 	kprobe_opcode_t *addr = p->addr;
+
+	if ((p->symbol_name && p->addr) ||
+	    (!p->symbol_name && !p->addr))
+		goto invalid;
+
 	if (p->symbol_name) {
-		if (addr)
-			return NULL;
 		kprobe_lookup_name(p->symbol_name, addr);
+		if (!addr)
+			return ERR_PTR(-ENOENT);
 	}
 
-	if (!addr)
-		return NULL;
-	return (kprobe_opcode_t *)(((char *)addr) + p->offset);
+	addr = (kprobe_opcode_t *)(((char *)addr) + p->offset);
+	if (addr)
+		return addr;
+
+invalid:
+	return ERR_PTR(-EINVAL);
 }
 
 /* Check passed kprobe is valid and return kprobe in kprobe_table. */
@@ -1311,8 +1321,8 @@ int __kprobes register_kprobe(struct kprobe *p)
 	kprobe_opcode_t *addr;
 
 	addr = kprobe_addr(p);
-	if (!addr)
-		return -EINVAL;
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
 	p->addr = addr;
 
 	ret = check_kprobe_rereg(p);
@@ -1335,6 +1345,8 @@ int __kprobes register_kprobe(struct kprobe *p)
 	 */
 	probed_mod = __module_text_address((unsigned long) p->addr);
 	if (probed_mod) {
+		/* Return -ENOENT if fail. */
+		ret = -ENOENT;
 		/*
 		 * We must hold a refcount of the probed module while updating
 		 * its code to prohibit unexpected unloading.
@@ -1351,6 +1363,7 @@ int __kprobes register_kprobe(struct kprobe *p)
 			module_put(probed_mod);
 			goto fail_with_jump_label;
 		}
+		/* ret will be updated by following code */
 	}
 	preempt_enable();
 	jump_label_unlock();
@@ -1399,7 +1412,7 @@ out:
 fail_with_jump_label:
 	preempt_enable();
 	jump_label_unlock();
-	return -EINVAL;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
@@ -1686,8 +1699,8 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 
 	if (kretprobe_blacklist_size) {
 		addr = kprobe_addr(&rp->kp);
-		if (!addr)
-			return -EINVAL;
+		if (IS_ERR(addr))
+			return PTR_ERR(addr);
 
 		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
 			if (kretprobe_blacklist[i].addr == addr)
diff --git a/kernel/sched.c b/kernel/sched.c
index fde6ff9..baa538a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2220,7 +2220,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 	if (task_cpu(p) != new_cpu) {
 		p->se.nr_migrations++;
-		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
+		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
 	}
 
 	__set_task_cpu(p, new_cpu);
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index eb212f8..d20c698 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -26,12 +26,18 @@ void print_stack_trace(struct stack_trace *trace, int spaces)
 EXPORT_SYMBOL_GPL(print_stack_trace);
 
 /*
- * Architectures that do not implement save_stack_trace_tsk get this
- * weak alias and a once-per-bootup warning (whenever this facility
- * is utilized - for example by procfs):
+ * Architectures that do not implement save_stack_trace_tsk or
+ * save_stack_trace_regs get this weak alias and a once-per-bootup warning
+ * (whenever this facility is utilized - for example by procfs):
  */
 __weak void
 save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
 	WARN_ONCE(1, KERN_INFO "save_stack_trace_tsk() not implemented yet.\n");
 }
+
+__weak void
+save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
+{
+	WARN_ONCE(1, KERN_INFO "save_stack_trace_regs() not implemented yet.\n");
+}
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 908038f..c3e4575 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -32,7 +32,6 @@
 
 #include <trace/events/sched.h>
 
-#include <asm/ftrace.h>
 #include <asm/setup.h>
 
 #include "trace_output.h"
@@ -82,14 +81,14 @@ static int ftrace_disabled __read_mostly;
 
 static DEFINE_MUTEX(ftrace_lock);
 
-static struct ftrace_ops ftrace_list_end __read_mostly =
-{
+static struct ftrace_ops ftrace_list_end __read_mostly = {
 	.func		= ftrace_stub,
 };
 
 static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
+static ftrace_func_t __ftrace_trace_function_delay __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
@@ -148,9 +147,11 @@ void clear_ftrace_function(void)
 {
 	ftrace_trace_function = ftrace_stub;
 	__ftrace_trace_function = ftrace_stub;
+	__ftrace_trace_function_delay = ftrace_stub;
 	ftrace_pid_function = ftrace_stub;
 }
 
+#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
  * For those archs that do not test ftrace_trace_stop in their
@@ -210,7 +211,12 @@ static void update_ftrace_function(void)
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	ftrace_trace_function = func;
 #else
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/* do not update till all functions have been modified */
+	__ftrace_trace_function_delay = func;
+#else
 	__ftrace_trace_function = func;
+#endif
 	ftrace_trace_function = ftrace_test_stop_func;
 #endif
 }
@@ -785,8 +791,7 @@ static void unregister_ftrace_profiler(void)
 	unregister_ftrace_graph();
 }
 #else
-static struct ftrace_ops ftrace_profile_ops __read_mostly =
-{
+static struct ftrace_ops ftrace_profile_ops __read_mostly = {
 	.func		= function_profile_call,
 };
 
@@ -806,19 +811,10 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
 	unsigned long val;
-	char buf[64];		/* big enough to hold a number */
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	val = !!val;
@@ -1182,8 +1178,14 @@ alloc_and_copy_ftrace_hash(int size_bits, struct ftrace_hash *hash)
 	return NULL;
 }
 
+static void
+ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
+static void
+ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
+
 static int
-ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
+ftrace_hash_move(struct ftrace_ops *ops, int enable,
+		 struct ftrace_hash **dst, struct ftrace_hash *src)
 {
 	struct ftrace_func_entry *entry;
 	struct hlist_node *tp, *tn;
@@ -1193,9 +1195,16 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 	unsigned long key;
 	int size = src->count;
 	int bits = 0;
+	int ret;
 	int i;
 
 	/*
+	 * Remove the current set, update the hash and add
+	 * them back.
+	 */
+	ftrace_hash_rec_disable(ops, enable);
+
+	/*
 	 * If the new source is empty, just free dst and assign it
 	 * the empty_hash.
 	 */
@@ -1215,9 +1224,10 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 	if (bits > FTRACE_HASH_MAX_BITS)
 		bits = FTRACE_HASH_MAX_BITS;
 
+	ret = -ENOMEM;
 	new_hash = alloc_ftrace_hash(bits);
 	if (!new_hash)
-		return -ENOMEM;
+		goto out;
 
 	size = 1 << src->size_bits;
 	for (i = 0; i < size; i++) {
@@ -1236,7 +1246,16 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 	rcu_assign_pointer(*dst, new_hash);
 	free_ftrace_hash_rcu(old_hash);
 
-	return 0;
+	ret = 0;
+ out:
+	/*
+	 * Enable regardless of ret:
+	 *  On success, we enable the new hash.
+	 *  On failure, we re-enable the original hash.
+	 */
+	ftrace_hash_rec_enable(ops, enable);
+
+	return ret;
 }
 
 /*
@@ -1596,6 +1615,12 @@ static int __ftrace_modify_code(void *data)
 {
 	int *command = data;
 
+	/*
+	 * Do not call function tracer while we update the code.
+	 * We are in stop machine, no worrying about races.
+	 */
+	function_trace_stop++;
+
 	if (*command & FTRACE_ENABLE_CALLS)
 		ftrace_replace_code(1);
 	else if (*command & FTRACE_DISABLE_CALLS)
@@ -1609,6 +1634,18 @@ static int __ftrace_modify_code(void *data)
 	else if (*command & FTRACE_STOP_FUNC_RET)
 		ftrace_disable_ftrace_graph_caller();
 
+#ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	/*
+	 * For archs that call ftrace_test_stop_func(), we must
+	 * wait till after we update all the function callers
+	 * before we update the callback. This keeps different
+	 * ops that record different functions from corrupting
+	 * each other.
+	 */
+	__ftrace_trace_function = __ftrace_trace_function_delay;
+#endif
+	function_trace_stop--;
+
 	return 0;
 }
 
@@ -1744,10 +1781,36 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
+static int ops_traces_mod(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash;
+
+	hash = ops->filter_hash;
+	return !!(!hash || !hash->count);
+}
+
 static int ftrace_update_code(struct module *mod)
 {
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
+	unsigned long ref = 0;
+
+	/*
+	 * When adding a module, we need to check if tracers are
+	 * currently enabled and if they are set to trace all functions.
+	 * If they are, we need to enable the module functions as well
+	 * as update the reference counts for those function records.
+	 */
+	if (mod) {
+		struct ftrace_ops *ops;
+
+		for (ops = ftrace_ops_list;
+		     ops != &ftrace_list_end; ops = ops->next) {
+			if (ops->flags & FTRACE_OPS_FL_ENABLED &&
+			    ops_traces_mod(ops))
+				ref++;
+		}
+	}
 
 	start = ftrace_now(raw_smp_processor_id());
 	ftrace_update_cnt = 0;
@@ -1760,7 +1823,7 @@ static int ftrace_update_code(struct module *mod)
 
 		p = ftrace_new_addrs;
 		ftrace_new_addrs = p->newlist;
-		p->flags = 0L;
+		p->flags = ref;
 
 		/*
 		 * Do the initial record conversion from mcount jump
@@ -1783,7 +1846,7 @@ static int ftrace_update_code(struct module *mod)
 		 * conversion puts the module to the correct state, thus
 		 * passing the ftrace_make_call check.
 		 */
-		if (ftrace_start_up) {
+		if (ftrace_start_up && ref) {
 			int failed = __ftrace_replace_code(p, 1);
 			if (failed) {
 				ftrace_bug(failed, p->ip);
@@ -2407,10 +2470,9 @@ ftrace_match_module_records(struct ftrace_hash *hash, char *buff, char *mod)
  */
 
 static int
-ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
+ftrace_mod_callback(struct ftrace_hash *hash,
+		    char *func, char *cmd, char *param, int enable)
 {
-	struct ftrace_ops *ops = &global_ops;
-	struct ftrace_hash *hash;
 	char *mod;
 	int ret = -EINVAL;
 
@@ -2430,11 +2492,6 @@ ftrace_mod_callback(char *func, char *cmd, char *param, int enable)
 	if (!strlen(mod))
 		return ret;
 
-	if (enable)
-		hash = ops->filter_hash;
-	else
-		hash = ops->notrace_hash;
-
 	ret = ftrace_match_module_records(hash, func, mod);
 	if (!ret)
 		ret = -EINVAL;
@@ -2760,7 +2817,7 @@ static int ftrace_process_regex(struct ftrace_hash *hash,
 	mutex_lock(&ftrace_cmd_mutex);
 	list_for_each_entry(p, &ftrace_commands, list) {
 		if (strcmp(p->name, command) == 0) {
-			ret = p->func(func, command, next, enable);
+			ret = p->func(hash, func, command, next, enable);
 			goto out_unlock;
 		}
 	}
@@ -2857,7 +2914,11 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 		ftrace_match_records(hash, buf, len);
 
 	mutex_lock(&ftrace_lock);
-	ret = ftrace_hash_move(orig_hash, hash);
+	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
+	if (!ret && ops->flags & FTRACE_OPS_FL_ENABLED
+	    && ftrace_enabled)
+		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+
 	mutex_unlock(&ftrace_lock);
 
 	mutex_unlock(&ftrace_regex_lock);
@@ -3040,18 +3101,12 @@ ftrace_regex_release(struct inode *inode, struct file *file)
 			orig_hash = &iter->ops->notrace_hash;
 
 		mutex_lock(&ftrace_lock);
-		/*
-		 * Remove the current set, update the hash and add
-		 * them back.
-		 */
-		ftrace_hash_rec_disable(iter->ops, filter_hash);
-		ret = ftrace_hash_move(orig_hash, iter->hash);
-		if (!ret) {
-			ftrace_hash_rec_enable(iter->ops, filter_hash);
-			if (iter->ops->flags & FTRACE_OPS_FL_ENABLED
-			    && ftrace_enabled)
-				ftrace_run_update_code(FTRACE_ENABLE_CALLS);
-		}
+		ret = ftrace_hash_move(iter->ops, filter_hash,
+				       orig_hash, iter->hash);
+		if (!ret && (iter->ops->flags & FTRACE_OPS_FL_ENABLED)
+		    && ftrace_enabled)
+			ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+
 		mutex_unlock(&ftrace_lock);
 	}
 	free_ftrace_hash(iter->hash);
@@ -3330,7 +3385,7 @@ static int ftrace_process_locs(struct module *mod,
 {
 	unsigned long *p;
 	unsigned long addr;
-	unsigned long flags;
+	unsigned long flags = 0; /* Shut up gcc */
 
 	mutex_lock(&ftrace_lock);
 	p = start;
@@ -3348,12 +3403,18 @@ static int ftrace_process_locs(struct module *mod,
 	}
 
 	/*
-	 * Disable interrupts to prevent interrupts from executing
-	 * code that is being modified.
+	 * We only need to disable interrupts on start up
+	 * because we are modifying code that an interrupt
+	 * may execute, and the modification is not atomic.
+	 * But for modules, nothing runs the code we modify
+	 * until we are finished with it, and there's no
+	 * reason to cause large interrupt latencies while we do it.
 	 */
-	local_irq_save(flags);
+	if (!mod)
+		local_irq_save(flags);
 	ftrace_update_code(mod);
-	local_irq_restore(flags);
+	if (!mod)
+		local_irq_restore(flags);
 	mutex_unlock(&ftrace_lock);
 
 	return 0;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b0c7aa4..731201b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -997,15 +997,21 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			     unsigned nr_pages)
 {
 	struct buffer_page *bpage, *tmp;
-	unsigned long addr;
 	LIST_HEAD(pages);
 	unsigned i;
 
 	WARN_ON(!nr_pages);
 
 	for (i = 0; i < nr_pages; i++) {
+		struct page *page;
+		/*
+		 * __GFP_NORETRY flag makes sure that the allocation fails
+		 * gracefully without invoking oom-killer and the system is
+		 * not destabilized.
+		 */
 		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
-				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
+				    GFP_KERNEL | __GFP_NORETRY,
+				    cpu_to_node(cpu_buffer->cpu));
 		if (!bpage)
 			goto free_pages;
 
@@ -1013,10 +1019,11 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 		list_add(&bpage->list, &pages);
 
-		addr = __get_free_page(GFP_KERNEL);
-		if (!addr)
+		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
+					GFP_KERNEL | __GFP_NORETRY, 0);
+		if (!page)
 			goto free_pages;
-		bpage->page = (void *)addr;
+		bpage->page = page_address(page);
 		rb_init_page(bpage->page);
 	}
 
@@ -1045,7 +1052,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long addr;
+	struct page *page;
 	int ret;
 
 	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
@@ -1067,10 +1074,10 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	rb_check_bpage(cpu_buffer, bpage);
 
 	cpu_buffer->reader_page = bpage;
-	addr = __get_free_page(GFP_KERNEL);
-	if (!addr)
+	page = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+	if (!page)
 		goto fail_free_reader;
-	bpage->page = (void *)addr;
+	bpage->page = page_address(page);
 	rb_init_page(bpage->page);
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
@@ -1314,7 +1321,6 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	unsigned nr_pages, rm_pages, new_pages;
 	struct buffer_page *bpage, *tmp;
 	unsigned long buffer_size;
-	unsigned long addr;
 	LIST_HEAD(pages);
 	int i, cpu;
 
@@ -1375,16 +1381,24 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 
 	for_each_buffer_cpu(buffer, cpu) {
 		for (i = 0; i < new_pages; i++) {
+			struct page *page;
+			/*
+			 * __GFP_NORETRY flag makes sure that the allocation
+			 * fails gracefully without invoking oom-killer and
+			 * the system is not destabilized.
+			 */
 			bpage = kzalloc_node(ALIGN(sizeof(*bpage),
 						  cache_line_size()),
-					    GFP_KERNEL, cpu_to_node(cpu));
+					    GFP_KERNEL | __GFP_NORETRY,
+					    cpu_to_node(cpu));
 			if (!bpage)
 				goto free_pages;
 			list_add(&bpage->list, &pages);
-			addr = __get_free_page(GFP_KERNEL);
-			if (!addr)
+			page = alloc_pages_node(cpu_to_node(cpu),
+						GFP_KERNEL | __GFP_NORETRY, 0);
+			if (!page)
 				goto free_pages;
-			bpage->page = (void *)addr;
+			bpage->page = page_address(page);
 			rb_init_page(bpage->page);
 		}
 	}
@@ -3730,16 +3744,17 @@ EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
  * Returns:
  *  The page allocated, or NULL on error.
  */
-void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
+void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu)
 {
 	struct buffer_data_page *bpage;
-	unsigned long addr;
+	struct page *page;
 
-	addr = __get_free_page(GFP_KERNEL);
-	if (!addr)
+	page = alloc_pages_node(cpu_to_node(cpu),
+				GFP_KERNEL | __GFP_NORETRY, 0);
+	if (!page)
 		return NULL;
 
-	bpage = (void *)addr;
+	bpage = page_address(page);
 
 	rb_init_page(bpage);
 
@@ -3978,20 +3993,11 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
 	unsigned long *p = filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	if (val)
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 302f8a6..a5457d5 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -106,7 +106,7 @@ static enum event_status read_page(int cpu)
 	int inc;
 	int i;
 
-	bpage = ring_buffer_alloc_read_page(buffer);
+	bpage = ring_buffer_alloc_read_page(buffer, cpu);
 	if (!bpage)
 		return EVENT_DROPPED;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee9c921..e5df02c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -343,26 +343,27 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
 
+static void wakeup_work_handler(struct work_struct *work)
+{
+	wake_up(&trace_wait);
+}
+
+static DECLARE_DELAYED_WORK(wakeup_work, wakeup_work_handler);
+
 /**
  * trace_wake_up - wake up tasks waiting for trace input
  *
- * Simply wakes up any task that is blocked on the trace_wait
- * queue. These is used with trace_poll for tasks polling the trace.
+ * Schedules a delayed work to wake up any task that is blocked on the
+ * trace_wait queue. These is used with trace_poll for tasks polling the
+ * trace.
  */
 void trace_wake_up(void)
 {
-	int cpu;
+	const unsigned long delay = msecs_to_jiffies(2);
 
 	if (trace_flags & TRACE_ITER_BLOCK)
 		return;
-	/*
-	 * The runqueue_is_locked() can fail, but this is the best we
-	 * have for now:
-	 */
-	cpu = get_cpu();
-	if (!runqueue_is_locked(cpu))
-		wake_up(&trace_wait);
-	put_cpu();
+	schedule_delayed_work(&wakeup_work, delay);
 }
 
 static int __init set_buf_size(char *str)
@@ -424,6 +425,7 @@ static const char *trace_options[] = {
 	"graph-time",
 	"record-cmd",
 	"overwrite",
+	"disable_on_free",
 	NULL
 };
 
@@ -1191,6 +1193,18 @@ void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit);
 
+void trace_nowake_buffer_unlock_commit_regs(struct ring_buffer *buffer,
+					    struct ring_buffer_event *event,
+					    unsigned long flags, int pc,
+					    struct pt_regs *regs)
+{
+	ring_buffer_unlock_commit(buffer, event);
+
+	ftrace_trace_stack_regs(buffer, flags, 0, pc, regs);
+	ftrace_trace_userstack(buffer, flags, pc);
+}
+EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit_regs);
+
 void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 					 struct ring_buffer_event *event)
 {
@@ -1234,30 +1248,103 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 }
 
 #ifdef CONFIG_STACKTRACE
+
+#define FTRACE_STACK_MAX_ENTRIES (PAGE_SIZE / sizeof(unsigned long))
+struct ftrace_stack {
+	unsigned long		calls[FTRACE_STACK_MAX_ENTRIES];
+};
+
+static DEFINE_PER_CPU(struct ftrace_stack, ftrace_stack);
+static DEFINE_PER_CPU(int, ftrace_stack_reserve);
+
 static void __ftrace_trace_stack(struct ring_buffer *buffer,
 				 unsigned long flags,
-				 int skip, int pc)
+				 int skip, int pc, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
 	struct stack_entry *entry;
 	struct stack_trace trace;
+	int use_stack;
+	int size = FTRACE_STACK_ENTRIES;
+
+	trace.nr_entries	= 0;
+	trace.skip		= skip;
+
+	/*
+	 * Since events can happen in NMIs there's no safe way to
+	 * use the per cpu ftrace_stacks. We reserve it and if an interrupt
+	 * or NMI comes in, it will just have to use the default
+	 * FTRACE_STACK_SIZE.
+	 */
+	preempt_disable_notrace();
+
+	use_stack = ++__get_cpu_var(ftrace_stack_reserve);
+	/*
+	 * We don't need any atomic variables, just a barrier.
+	 * If an interrupt comes in, we don't care, because it would
+	 * have exited and put the counter back to what we want.
+	 * We just need a barrier to keep gcc from moving things
+	 * around.
+	 */
+	barrier();
+	if (use_stack == 1) {
+		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
+		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
+
+		if (regs)
+			save_stack_trace_regs(regs, &trace);
+		else
+			save_stack_trace(&trace);
+
+		if (trace.nr_entries > size)
+			size = trace.nr_entries;
+	} else
+		/* From now on, use_stack is a boolean */
+		use_stack = 0;
+
+	size *= sizeof(unsigned long);
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_STACK,
-					  sizeof(*entry), flags, pc);
+					  sizeof(*entry) + size, flags, pc);
 	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	memset(&entry->caller, 0, sizeof(entry->caller));
+		goto out;
+	entry = ring_buffer_event_data(event);
 
-	trace.nr_entries	= 0;
-	trace.max_entries	= FTRACE_STACK_ENTRIES;
-	trace.skip		= skip;
-	trace.entries		= entry->caller;
+	memset(&entry->caller, 0, size);
+
+	if (use_stack)
+		memcpy(&entry->caller, trace.entries,
+		       trace.nr_entries * sizeof(unsigned long));
+	else {
+		trace.max_entries	= FTRACE_STACK_ENTRIES;
+		trace.entries		= entry->caller;
+		if (regs)
+			save_stack_trace_regs(regs, &trace);
+		else
+			save_stack_trace(&trace);
+	}
+
+	entry->size = trace.nr_entries;
 
-	save_stack_trace(&trace);
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
+
+ out:
+	/* Again, don't let gcc optimize things here */
+	barrier();
+	__get_cpu_var(ftrace_stack_reserve)--;
+	preempt_enable_notrace();
+
+}
+
+void ftrace_trace_stack_regs(struct ring_buffer *buffer, unsigned long flags,
+			     int skip, int pc, struct pt_regs *regs)
+{
+	if (!(trace_flags & TRACE_ITER_STACKTRACE))
+		return;
+
+	__ftrace_trace_stack(buffer, flags, skip, pc, regs);
 }
 
 void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
@@ -1266,13 +1353,13 @@ void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
 	if (!(trace_flags & TRACE_ITER_STACKTRACE))
 		return;
 
-	__ftrace_trace_stack(buffer, flags, skip, pc);
+	__ftrace_trace_stack(buffer, flags, skip, pc, NULL);
 }
 
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc)
 {
-	__ftrace_trace_stack(tr->buffer, flags, skip, pc);
+	__ftrace_trace_stack(tr->buffer, flags, skip, pc, NULL);
 }
 
 /**
@@ -1288,7 +1375,7 @@ void trace_dump_stack(void)
 	local_save_flags(flags);
 
 	/* skipping 3 traces, seems to get us at the caller of this function */
-	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
+	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count(), NULL);
 }
 
 static DEFINE_PER_CPU(int, user_stack_count);
@@ -1536,7 +1623,12 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
 
 	ftrace_enable_cpu();
 
-	return event ? ring_buffer_event_data(event) : NULL;
+	if (event) {
+		iter->ent_size = ring_buffer_event_length(event);
+		return ring_buffer_event_data(event);
+	}
+	iter->ent_size = 0;
+	return NULL;
 }
 
 static struct trace_entry *
@@ -2051,6 +2143,9 @@ void trace_default_header(struct seq_file *m)
 {
 	struct trace_iterator *iter = m->private;
 
+	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
+		return;
+
 	if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
 		/* print nothing if the buffers are empty */
 		if (trace_empty(iter))
@@ -2701,20 +2796,11 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	val = !!val;
@@ -2767,7 +2853,7 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
 	return t->init(tr);
 }
 
-static int tracing_resize_ring_buffer(unsigned long size)
+static int __tracing_resize_ring_buffer(unsigned long size)
 {
 	int ret;
 
@@ -2819,6 +2905,41 @@ static int tracing_resize_ring_buffer(unsigned long size)
 	return ret;
 }
 
+static ssize_t tracing_resize_ring_buffer(unsigned long size)
+{
+	int cpu, ret = size;
+
+	mutex_lock(&trace_types_lock);
+
+	tracing_stop();
+
+	/* disable all cpu buffers */
+	for_each_tracing_cpu(cpu) {
+		if (global_trace.data[cpu])
+			atomic_inc(&global_trace.data[cpu]->disabled);
+		if (max_tr.data[cpu])
+			atomic_inc(&max_tr.data[cpu]->disabled);
+	}
+
+	if (size != global_trace.entries)
+		ret = __tracing_resize_ring_buffer(size);
+
+	if (ret < 0)
+		ret = -ENOMEM;
+
+	for_each_tracing_cpu(cpu) {
+		if (global_trace.data[cpu])
+			atomic_dec(&global_trace.data[cpu]->disabled);
+		if (max_tr.data[cpu])
+			atomic_dec(&max_tr.data[cpu]->disabled);
+	}
+
+	tracing_start();
+	mutex_unlock(&trace_types_lock);
+
+	return ret;
+}
+
 
 /**
  * tracing_update_buffers - used by tracing facility to expand ring buffers
@@ -2836,7 +2957,7 @@ int tracing_update_buffers(void)
 
 	mutex_lock(&trace_types_lock);
 	if (!ring_buffer_expanded)
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size);
 	mutex_unlock(&trace_types_lock);
 
 	return ret;
@@ -2860,7 +2981,7 @@ static int tracing_set_tracer(const char *buf)
 	mutex_lock(&trace_types_lock);
 
 	if (!ring_buffer_expanded) {
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size);
 		if (ret < 0)
 			goto out;
 		ret = 0;
@@ -2966,20 +3087,11 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
 	unsigned long *ptr = filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	*ptr = val * 1000;
@@ -3434,67 +3546,54 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
 	unsigned long val;
-	char buf[64];
-	int ret, cpu;
-
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
+	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	/* must have at least 1 entry */
 	if (!val)
 		return -EINVAL;
 
-	mutex_lock(&trace_types_lock);
-
-	tracing_stop();
-
-	/* disable all cpu buffers */
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_inc(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_inc(&max_tr.data[cpu]->disabled);
-	}
-
 	/* value is in KB */
 	val <<= 10;
 
-	if (val != global_trace.entries) {
-		ret = tracing_resize_ring_buffer(val);
-		if (ret < 0) {
-			cnt = ret;
-			goto out;
-		}
-	}
+	ret = tracing_resize_ring_buffer(val);
+	if (ret < 0)
+		return ret;
 
 	*ppos += cnt;
 
-	/* If check pages failed, return ENOMEM */
-	if (tracing_disabled)
-		cnt = -ENOMEM;
- out:
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_dec(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_dec(&max_tr.data[cpu]->disabled);
-	}
+	return cnt;
+}
 
-	tracing_start();
-	mutex_unlock(&trace_types_lock);
+static ssize_t
+tracing_free_buffer_write(struct file *filp, const char __user *ubuf,
+			  size_t cnt, loff_t *ppos)
+{
+	/*
+	 * There is no need to read what the user has written, this function
+	 * is just to make sure that there is no error when "echo" is used
+	 */
+
+	*ppos += cnt;
 
 	return cnt;
 }
 
+static int
+tracing_free_buffer_release(struct inode *inode, struct file *filp)
+{
+	/* disable tracing ? */
+	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
+		tracing_off();
+	/* resize the ring buffer to 0 */
+	tracing_resize_ring_buffer(0);
+
+	return 0;
+}
+
 static int mark_printk(const char *fmt, ...)
 {
 	int ret;
@@ -3640,6 +3739,11 @@ static const struct file_operations tracing_entries_fops = {
 	.llseek		= generic_file_llseek,
 };
 
+static const struct file_operations tracing_free_buffer_fops = {
+	.write		= tracing_free_buffer_write,
+	.release	= tracing_free_buffer_release,
+};
+
 static const struct file_operations tracing_mark_fops = {
 	.open		= tracing_open_generic,
 	.write		= tracing_mark_write,
@@ -3696,7 +3800,7 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 		return 0;
 
 	if (!info->spare)
-		info->spare = ring_buffer_alloc_read_page(info->tr->buffer);
+		info->spare = ring_buffer_alloc_read_page(info->tr->buffer, info->cpu);
 	if (!info->spare)
 		return -ENOMEM;
 
@@ -3853,7 +3957,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 
 		ref->ref = 1;
 		ref->buffer = info->tr->buffer;
-		ref->page = ring_buffer_alloc_read_page(ref->buffer);
+		ref->page = ring_buffer_alloc_read_page(ref->buffer, info->cpu);
 		if (!ref->page) {
 			kfree(ref);
 			break;
@@ -3862,8 +3966,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		r = ring_buffer_read_page(ref->buffer, &ref->page,
 					  len, info->cpu, 1);
 		if (r < 0) {
-			ring_buffer_free_read_page(ref->buffer,
-						   ref->page);
+			ring_buffer_free_read_page(ref->buffer, ref->page);
 			kfree(ref);
 			break;
 		}
@@ -4099,19 +4202,10 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 {
 	struct trace_option_dentry *topt = filp->private_data;
 	unsigned long val;
-	char buf[64];
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	if (val != 0 && val != 1)
@@ -4159,20 +4253,11 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 			 loff_t *ppos)
 {
 	long index = (long)filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	if (val != 0 && val != 1)
@@ -4365,6 +4450,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			&global_trace, &tracing_entries_fops);
 
+	trace_create_file("free_buffer", 0644, d_tracer,
+			&global_trace, &tracing_free_buffer_fops);
+
 	trace_create_file("trace_marker", 0220, d_tracer,
 			NULL, &tracing_mark_fops);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 229f859..3f381d0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -278,6 +278,29 @@ struct tracer {
 };
 
 
+/* Only current can touch trace_recursion */
+#define trace_recursion_inc() do { (current)->trace_recursion++; } while (0)
+#define trace_recursion_dec() do { (current)->trace_recursion--; } while (0)
+
+/* Ring buffer has the 10 LSB bits to count */
+#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
+
+/* for function tracing recursion */
+#define TRACE_INTERNAL_BIT		(1<<11)
+#define TRACE_GLOBAL_BIT		(1<<12)
+/*
+ * Abuse of the trace_recursion.
+ * As we need a way to maintain state if we are tracing the function
+ * graph in irq because we want to trace a particular function that
+ * was called in irq context but we have irq tracing off. Since this
+ * can only be modified by current, we can reuse trace_recursion.
+ */
+#define TRACE_IRQ_BIT			(1<<13)
+
+#define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
+#define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
+#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
+
 #define TRACE_PIPE_ALL_CPU	-1
 
 int tracer_init(struct tracer *t, struct trace_array *tr);
@@ -389,6 +412,9 @@ void update_max_tr_single(struct trace_array *tr,
 void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
 			int skip, int pc);
 
+void ftrace_trace_stack_regs(struct ring_buffer *buffer, unsigned long flags,
+			     int skip, int pc, struct pt_regs *regs);
+
 void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
 			    int pc);
 
@@ -400,6 +426,12 @@ static inline void ftrace_trace_stack(struct ring_buffer *buffer,
 {
 }
 
+static inline void ftrace_trace_stack_regs(struct ring_buffer *buffer,
+					   unsigned long flags, int skip,
+					   int pc, struct pt_regs *regs)
+{
+}
+
 static inline void ftrace_trace_userstack(struct ring_buffer *buffer,
 					  unsigned long flags, int pc)
 {
@@ -507,8 +539,18 @@ static inline int ftrace_graph_addr(unsigned long addr)
 		return 1;
 
 	for (i = 0; i < ftrace_graph_count; i++) {
-		if (addr == ftrace_graph_funcs[i])
+		if (addr == ftrace_graph_funcs[i]) {
+			/*
+			 * If no irqs are to be traced, but a set_graph_function
+			 * is set, and called by an interrupt handler, we still
+			 * want to trace it.
+			 */
+			if (in_irq())
+				trace_recursion_set(TRACE_IRQ_BIT);
+			else
+				trace_recursion_clear(TRACE_IRQ_BIT);
 			return 1;
+		}
 	}
 
 	return 0;
@@ -609,6 +651,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_GRAPH_TIME		= 0x80000,
 	TRACE_ITER_RECORD_CMD		= 0x100000,
 	TRACE_ITER_OVERWRITE		= 0x200000,
+	TRACE_ITER_STOP_ON_FREE		= 0x400000,
 };
 
 /*
@@ -677,6 +720,7 @@ struct event_subsystem {
 	struct dentry		*entry;
 	struct event_filter	*filter;
 	int			nr_events;
+	int			ref_count;
 };
 
 #define FILTER_PRED_INVALID	((unsigned short)-1)
@@ -784,19 +828,4 @@ extern const char *__stop___trace_bprintk_fmt[];
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
 #include "trace_entries.h"
 
-/* Only current can touch trace_recursion */
-#define trace_recursion_inc() do { (current)->trace_recursion++; } while (0)
-#define trace_recursion_dec() do { (current)->trace_recursion--; } while (0)
-
-/* Ring buffer has the 10 LSB bits to count */
-#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
-
-/* for function tracing recursion */
-#define TRACE_INTERNAL_BIT		(1<<11)
-#define TRACE_GLOBAL_BIT		(1<<12)
-
-#define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
-#define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
-#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
-
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index e32744c..9336590 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -161,7 +161,8 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 	TRACE_STACK,
 
 	F_STRUCT(
-		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
+		__field(	int,		size	)
+		__dynamic_array(unsigned long,	caller	)
 	),
 
 	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 686ec39..581876f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -244,6 +244,35 @@ static void ftrace_clear_events(void)
 	mutex_unlock(&event_mutex);
 }
 
+static void __put_system(struct event_subsystem *system)
+{
+	struct event_filter *filter = system->filter;
+
+	WARN_ON_ONCE(system->ref_count == 0);
+	if (--system->ref_count)
+		return;
+
+	if (filter) {
+		kfree(filter->filter_string);
+		kfree(filter);
+	}
+	kfree(system->name);
+	kfree(system);
+}
+
+static void __get_system(struct event_subsystem *system)
+{
+	WARN_ON_ONCE(system->ref_count == 0);
+	system->ref_count++;
+}
+
+static void put_system(struct event_subsystem *system)
+{
+	mutex_lock(&event_mutex);
+	__put_system(system);
+	mutex_unlock(&event_mutex);
+}
+
 /*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
@@ -486,20 +515,11 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	ret = tracing_update_buffers();
@@ -528,7 +548,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
 	const char set_to_char[4] = { '?', '0', '1', 'X' };
-	const char *system = filp->private_data;
+	struct event_subsystem *system = filp->private_data;
 	struct ftrace_event_call *call;
 	char buf[2];
 	int set = 0;
@@ -539,7 +559,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		if (!call->name || !call->class || !call->class->reg)
 			continue;
 
-		if (system && strcmp(call->class->system, system) != 0)
+		if (system && strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		/*
@@ -569,21 +589,13 @@ static ssize_t
 system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		    loff_t *ppos)
 {
-	const char *system = filp->private_data;
+	struct event_subsystem *system = filp->private_data;
+	const char *name = NULL;
 	unsigned long val;
-	char buf[64];
 	ssize_t ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	ret = tracing_update_buffers();
@@ -593,7 +605,14 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (val != 0 && val != 1)
 		return -EINVAL;
 
-	ret = __ftrace_set_clr_event(NULL, system, NULL, val);
+	/*
+	 * Opening of "enable" adds a ref count to system,
+	 * so the name is safe to use.
+	 */
+	if (system)
+		name = system->name;
+
+	ret = __ftrace_set_clr_event(NULL, name, NULL, val);
 	if (ret)
 		goto out;
 
@@ -826,6 +845,52 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+static LIST_HEAD(event_subsystems);
+
+static int subsystem_open(struct inode *inode, struct file *filp)
+{
+	struct event_subsystem *system = NULL;
+	int ret;
+
+	if (!inode->i_private)
+		goto skip_search;
+
+	/* Make sure the system still exists */
+	mutex_lock(&event_mutex);
+	list_for_each_entry(system, &event_subsystems, list) {
+		if (system == inode->i_private) {
+			/* Don't open systems with no events */
+			if (!system->nr_events) {
+				system = NULL;
+				break;
+			}
+			__get_system(system);
+			break;
+		}
+	}
+	mutex_unlock(&event_mutex);
+
+	if (system != inode->i_private)
+		return -ENODEV;
+
+ skip_search:
+	ret = tracing_open_generic(inode, filp);
+	if (ret < 0 && system)
+		put_system(system);
+
+	return ret;
+}
+
+static int subsystem_release(struct inode *inode, struct file *file)
+{
+	struct event_subsystem *system = inode->i_private;
+
+	if (system)
+		put_system(system);
+
+	return 0;
+}
+
 static ssize_t
 subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		      loff_t *ppos)
@@ -963,17 +1028,19 @@ static const struct file_operations ftrace_event_filter_fops = {
 };
 
 static const struct file_operations ftrace_subsystem_filter_fops = {
-	.open = tracing_open_generic,
+	.open = subsystem_open,
 	.read = subsystem_filter_read,
 	.write = subsystem_filter_write,
 	.llseek = default_llseek,
+	.release = subsystem_release,
 };
 
 static const struct file_operations ftrace_system_enable_fops = {
-	.open = tracing_open_generic,
+	.open = subsystem_open,
 	.read = system_enable_read,
 	.write = system_enable_write,
 	.llseek = default_llseek,
+	.release = subsystem_release,
 };
 
 static const struct file_operations ftrace_show_header_fops = {
@@ -1002,8 +1069,6 @@ static struct dentry *event_trace_events_dir(void)
 	return d_events;
 }
 
-static LIST_HEAD(event_subsystems);
-
 static struct dentry *
 event_subsystem_dir(const char *name, struct dentry *d_events)
 {
@@ -1013,6 +1078,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) == 0) {
+			__get_system(system);
 			system->nr_events++;
 			return system->entry;
 		}
@@ -1035,6 +1101,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	}
 
 	system->nr_events = 1;
+	system->ref_count = 1;
 	system->name = kstrdup(name, GFP_KERNEL);
 	if (!system->name) {
 		debugfs_remove(system->entry);
@@ -1062,8 +1129,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 			   "'%s/filter' entry\n", name);
 	}
 
-	trace_create_file("enable", 0644, system->entry,
-			  (void *)system->name,
+	trace_create_file("enable", 0644, system->entry, system,
 			  &ftrace_system_enable_fops);
 
 	return system->entry;
@@ -1184,16 +1250,9 @@ static void remove_subsystem_dir(const char *name)
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) == 0) {
 			if (!--system->nr_events) {
-				struct event_filter *filter = system->filter;
-
 				debugfs_remove_recursive(system->entry);
 				list_del(&system->list);
-				if (filter) {
-					kfree(filter->filter_string);
-					kfree(filter);
-				}
-				kfree(system->name);
-				kfree(system);
+				__put_system(system);
 			}
 			break;
 		}
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8008ddc..256764e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1886,6 +1886,12 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 
 	mutex_lock(&event_mutex);
 
+	/* Make sure the system still has events */
+	if (!system->nr_events) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_free_subsystem_preds(system);
 		remove_filter_string(system->filter);
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 8d0e1cc..c7b0c6a 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -324,7 +324,8 @@ ftrace_trace_onoff_unreg(char *glob, char *cmd, char *param)
 }
 
 static int
-ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
+ftrace_trace_onoff_callback(struct ftrace_hash *hash,
+			    char *glob, char *cmd, char *param, int enable)
 {
 	struct ftrace_probe_ops *ops;
 	void *count = (void *)-1;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 962cdb2..a7d2a4c 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -74,6 +74,20 @@ static struct tracer_flags tracer_flags = {
 
 static struct trace_array *graph_array;
 
+/*
+ * DURATION column is being also used to display IRQ signs,
+ * following values are used by print_graph_irq and others
+ * to fill in space into DURATION column.
+ */
+enum {
+	DURATION_FILL_FULL  = -1,
+	DURATION_FILL_START = -2,
+	DURATION_FILL_END   = -3,
+};
+
+static enum print_line_t
+print_graph_duration(unsigned long long duration, struct trace_seq *s,
+		     u32 flags);
 
 /* Add a function return address to the trace stack on thread info.*/
 int
@@ -213,7 +227,7 @@ int __trace_graph_entry(struct trace_array *tr,
 
 static inline int ftrace_graph_ignore_irqs(void)
 {
-	if (!ftrace_graph_skip_irqs)
+	if (!ftrace_graph_skip_irqs || trace_recursion_test(TRACE_IRQ_BIT))
 		return 0;
 
 	return in_irq();
@@ -577,32 +591,6 @@ get_return_for_leaf(struct trace_iterator *iter,
 	return next;
 }
 
-/* Signal a overhead of time execution to the output */
-static int
-print_graph_overhead(unsigned long long duration, struct trace_seq *s,
-		     u32 flags)
-{
-	/* If duration disappear, we don't need anything */
-	if (!(flags & TRACE_GRAPH_PRINT_DURATION))
-		return 1;
-
-	/* Non nested entry or return */
-	if (duration == -1)
-		return trace_seq_printf(s, "  ");
-
-	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
-		/* Duration exceeded 100 msecs */
-		if (duration > 100000ULL)
-			return trace_seq_printf(s, "! ");
-
-		/* Duration exceeded 10 msecs */
-		if (duration > 10000ULL)
-			return trace_seq_printf(s, "+ ");
-	}
-
-	return trace_seq_printf(s, "  ");
-}
-
 static int print_graph_abs_time(u64 t, struct trace_seq *s)
 {
 	unsigned long usecs_rem;
@@ -625,34 +613,36 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		addr >= (unsigned long)__irqentry_text_end)
 		return TRACE_TYPE_UNHANDLED;
 
-	/* Absolute time */
-	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
-		ret = print_graph_abs_time(iter->ts, s);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		/* Absolute time */
+		if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
+			ret = print_graph_abs_time(iter->ts, s);
+			if (!ret)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
 
-	/* Cpu */
-	if (flags & TRACE_GRAPH_PRINT_CPU) {
-		ret = print_graph_cpu(s, cpu);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+		/* Cpu */
+		if (flags & TRACE_GRAPH_PRINT_CPU) {
+			ret = print_graph_cpu(s, cpu);
+			if (ret == TRACE_TYPE_PARTIAL_LINE)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
 
-	/* Proc */
-	if (flags & TRACE_GRAPH_PRINT_PROC) {
-		ret = print_graph_proc(s, pid);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-		ret = trace_seq_printf(s, " | ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		/* Proc */
+		if (flags & TRACE_GRAPH_PRINT_PROC) {
+			ret = print_graph_proc(s, pid);
+			if (ret == TRACE_TYPE_PARTIAL_LINE)
+				return TRACE_TYPE_PARTIAL_LINE;
+			ret = trace_seq_printf(s, " | ");
+			if (!ret)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
 	}
 
 	/* No overhead */
-	ret = print_graph_overhead(-1, s, flags);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	ret = print_graph_duration(DURATION_FILL_START, s, flags);
+	if (ret != TRACE_TYPE_HANDLED)
+		return ret;
 
 	if (type == TRACE_GRAPH_ENT)
 		ret = trace_seq_printf(s, "==========>");
@@ -662,9 +652,10 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Don't close the duration column if haven't one */
-	if (flags & TRACE_GRAPH_PRINT_DURATION)
-		trace_seq_printf(s, " |");
+	ret = print_graph_duration(DURATION_FILL_END, s, flags);
+	if (ret != TRACE_TYPE_HANDLED)
+		return ret;
+
 	ret = trace_seq_printf(s, "\n");
 
 	if (!ret)
@@ -716,9 +707,49 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 }
 
 static enum print_line_t
-print_graph_duration(unsigned long long duration, struct trace_seq *s)
+print_graph_duration(unsigned long long duration, struct trace_seq *s,
+		     u32 flags)
 {
-	int ret;
+	int ret = -1;
+
+	if (!(flags & TRACE_GRAPH_PRINT_DURATION) ||
+	    !(trace_flags & TRACE_ITER_CONTEXT_INFO))
+			return TRACE_TYPE_HANDLED;
+
+	/* No real adata, just filling the column with spaces */
+	switch (duration) {
+	case DURATION_FILL_FULL:
+		ret = trace_seq_printf(s, "              |  ");
+		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+	case DURATION_FILL_START:
+		ret = trace_seq_printf(s, "  ");
+		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+	case DURATION_FILL_END:
+		ret = trace_seq_printf(s, " |");
+		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	/* Signal a overhead of time execution to the output */
+	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
+		/* Duration exceeded 100 msecs */
+		if (duration > 100000ULL)
+			ret = trace_seq_printf(s, "! ");
+		/* Duration exceeded 10 msecs */
+		else if (duration > 10000ULL)
+			ret = trace_seq_printf(s, "+ ");
+	}
+
+	/*
+	 * The -1 means we either did not exceed the duration tresholds
+	 * or we dont want to print out the overhead. Either way we need
+	 * to fill out the space.
+	 */
+	if (ret == -1)
+		ret = trace_seq_printf(s, "  ");
+
+	/* Catching here any failure happenned above */
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	ret = trace_print_graph_duration(duration, s);
 	if (ret != TRACE_TYPE_HANDLED)
@@ -767,18 +798,11 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 			cpu_data->enter_funcs[call->depth] = 0;
 	}
 
-	/* Overhead */
-	ret = print_graph_overhead(duration, s, flags);
-	if (!ret)
+	/* Overhead and duration */
+	ret = print_graph_duration(duration, s, flags);
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Duration */
-	if (flags & TRACE_GRAPH_PRINT_DURATION) {
-		ret = print_graph_duration(duration, s);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
 		ret = trace_seq_printf(s, " ");
@@ -815,17 +839,10 @@ print_graph_entry_nested(struct trace_iterator *iter,
 			cpu_data->enter_funcs[call->depth] = call->func;
 	}
 
-	/* No overhead */
-	ret = print_graph_overhead(-1, s, flags);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	/* No time */
-	if (flags & TRACE_GRAPH_PRINT_DURATION) {
-		ret = trace_seq_printf(s, "            |  ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	ret = print_graph_duration(DURATION_FILL_FULL, s, flags);
+	if (ret != TRACE_TYPE_HANDLED)
+		return ret;
 
 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
@@ -865,6 +882,9 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
+	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
+		return 0;
+
 	/* Absolute time */
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
 		ret = print_graph_abs_time(iter->ts, s);
@@ -1078,18 +1098,11 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	if (print_graph_prologue(iter, s, 0, 0, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Overhead */
-	ret = print_graph_overhead(duration, s, flags);
-	if (!ret)
+	/* Overhead and duration */
+	ret = print_graph_duration(duration, s, flags);
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Duration */
-	if (flags & TRACE_GRAPH_PRINT_DURATION) {
-		ret = print_graph_duration(duration, s);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
 	/* Closing brace */
 	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++) {
 		ret = trace_seq_printf(s, " ");
@@ -1146,17 +1159,10 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 	if (print_graph_prologue(iter, s, 0, 0, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* No overhead */
-	ret = print_graph_overhead(-1, s, flags);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	/* No time */
-	if (flags & TRACE_GRAPH_PRINT_DURATION) {
-		ret = trace_seq_printf(s, "            |  ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	ret = print_graph_duration(DURATION_FILL_FULL, s, flags);
+	if (ret != TRACE_TYPE_HANDLED)
+		return ret;
 
 	/* Indentation */
 	if (depth > 0)
@@ -1207,7 +1213,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 
 
 enum print_line_t
-__print_graph_function_flags(struct trace_iterator *iter, u32 flags)
+print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 {
 	struct ftrace_graph_ent_entry *field;
 	struct fgraph_data *data = iter->private;
@@ -1270,18 +1276,7 @@ __print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 static enum print_line_t
 print_graph_function(struct trace_iterator *iter)
 {
-	return __print_graph_function_flags(iter, tracer_flags.val);
-}
-
-enum print_line_t print_graph_function_flags(struct trace_iterator *iter,
-					     u32 flags)
-{
-	if (trace_flags & TRACE_ITER_LATENCY_FMT)
-		flags |= TRACE_GRAPH_PRINT_DURATION;
-	else
-		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
-
-	return __print_graph_function_flags(iter, flags);
+	return print_graph_function_flags(iter, tracer_flags.val);
 }
 
 static enum print_line_t
@@ -1309,8 +1304,7 @@ static void print_lat_header(struct seq_file *s, u32 flags)
 	seq_printf(s, "#%.*s / _----=> need-resched    \n", size, spaces);
 	seq_printf(s, "#%.*s| / _---=> hardirq/softirq \n", size, spaces);
 	seq_printf(s, "#%.*s|| / _--=> preempt-depth   \n", size, spaces);
-	seq_printf(s, "#%.*s||| / _-=> lock-depth      \n", size, spaces);
-	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
+	seq_printf(s, "#%.*s||| /                      \n", size, spaces);
 }
 
 static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
@@ -1329,7 +1323,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "  TASK/PID       ");
 	if (lat)
-		seq_printf(s, "|||||");
+		seq_printf(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "  DURATION   ");
 	seq_printf(s, "               FUNCTION CALLS\n");
@@ -1343,7 +1337,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "   |    |        ");
 	if (lat)
-		seq_printf(s, "|||||");
+		seq_printf(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "   |   |      ");
 	seq_printf(s, "               |   |   |   |\n");
@@ -1358,15 +1352,16 @@ void print_graph_headers_flags(struct seq_file *s, u32 flags)
 {
 	struct trace_iterator *iter = s->private;
 
+	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
+		return;
+
 	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
 		/* print nothing if the buffers are empty */
 		if (trace_empty(iter))
 			return;
 
 		print_trace_header(s, iter);
-		flags |= TRACE_GRAPH_PRINT_DURATION;
-	} else
-		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
+	}
 
 	__print_graph_headers_flags(s, flags);
 }
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index c77424b..667aa8c 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -226,7 +226,9 @@ static void irqsoff_trace_close(struct trace_iterator *iter)
 }
 
 #define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_CPU | \
-			    TRACE_GRAPH_PRINT_PROC)
+			    TRACE_GRAPH_PRINT_PROC | \
+			    TRACE_GRAPH_PRINT_ABS_TIME | \
+			    TRACE_GRAPH_PRINT_DURATION)
 
 static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
 {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 27d13b3..5fb3697 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -343,6 +343,14 @@ DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
 DEFINE_FETCH_deref(string_size)
 
+static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
+{
+	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
+		update_deref_fetch_param(data->orig.data);
+	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
+		update_symbol_cache(data->orig.data);
+}
+
 static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 {
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
@@ -377,6 +385,19 @@ DEFINE_BASIC_FETCH_FUNCS(bitfield)
 #define fetch_bitfield_string_size NULL
 
 static __kprobes void
+update_bitfield_fetch_param(struct bitfield_fetch_param *data)
+{
+	/*
+	 * Don't check the bitfield itself, because this must be the
+	 * last fetch function.
+	 */
+	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
+		update_deref_fetch_param(data->orig.data);
+	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
+		update_symbol_cache(data->orig.data);
+}
+
+static __kprobes void
 free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 {
 	/*
@@ -389,6 +410,7 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 		free_symbol_cache(data->orig.data);
 	kfree(data);
 }
+
 /* Default (unsigned long) fetch type */
 #define __DEFAULT_FETCH_TYPE(t) u##t
 #define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
@@ -536,6 +558,7 @@ struct probe_arg {
 /* Flags for trace_probe */
 #define TP_FLAG_TRACE	1
 #define TP_FLAG_PROFILE	2
+#define TP_FLAG_REGISTERED 4
 
 struct trace_probe {
 	struct list_head	list;
@@ -555,16 +578,49 @@ struct trace_probe {
 	(sizeof(struct probe_arg) * (n)))
 
 
-static __kprobes int probe_is_return(struct trace_probe *tp)
+static __kprobes int trace_probe_is_return(struct trace_probe *tp)
 {
 	return tp->rp.handler != NULL;
 }
 
-static __kprobes const char *probe_symbol(struct trace_probe *tp)
+static __kprobes const char *trace_probe_symbol(struct trace_probe *tp)
 {
 	return tp->symbol ? tp->symbol : "unknown";
 }
 
+static __kprobes unsigned long trace_probe_offset(struct trace_probe *tp)
+{
+	return tp->rp.kp.offset;
+}
+
+static __kprobes bool trace_probe_is_enabled(struct trace_probe *tp)
+{
+	return !!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE));
+}
+
+static __kprobes bool trace_probe_is_registered(struct trace_probe *tp)
+{
+	return !!(tp->flags & TP_FLAG_REGISTERED);
+}
+
+static __kprobes bool trace_probe_has_gone(struct trace_probe *tp)
+{
+	return !!(kprobe_gone(&tp->rp.kp));
+}
+
+static __kprobes bool trace_probe_within_module(struct trace_probe *tp,
+						struct module *mod)
+{
+	int len = strlen(mod->name);
+	const char *name = trace_probe_symbol(tp);
+	return strncmp(mod->name, name, len) == 0 && name[len] == ':';
+}
+
+static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
+{
+	return !!strchr(trace_probe_symbol(tp), ':');
+}
+
 static int register_probe_event(struct trace_probe *tp);
 static void unregister_probe_event(struct trace_probe *tp);
 
@@ -646,6 +702,16 @@ error:
 	return ERR_PTR(ret);
 }
 
+static void update_probe_arg(struct probe_arg *arg)
+{
+	if (CHECK_FETCH_FUNCS(bitfield, arg->fetch.fn))
+		update_bitfield_fetch_param(arg->fetch.data);
+	else if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
+		update_deref_fetch_param(arg->fetch.data);
+	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
+		update_symbol_cache(arg->fetch.data);
+}
+
 static void free_probe_arg(struct probe_arg *arg)
 {
 	if (CHECK_FETCH_FUNCS(bitfield, arg->fetch.fn))
@@ -671,7 +737,7 @@ static void free_trace_probe(struct trace_probe *tp)
 	kfree(tp);
 }
 
-static struct trace_probe *find_probe_event(const char *event,
+static struct trace_probe *find_trace_probe(const char *event,
 					    const char *group)
 {
 	struct trace_probe *tp;
@@ -683,13 +749,96 @@ static struct trace_probe *find_probe_event(const char *event,
 	return NULL;
 }
 
+/* Enable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
+static int enable_trace_probe(struct trace_probe *tp, int flag)
+{
+	int ret = 0;
+
+	tp->flags |= flag;
+	if (trace_probe_is_enabled(tp) && trace_probe_is_registered(tp) &&
+	    !trace_probe_has_gone(tp)) {
+		if (trace_probe_is_return(tp))
+			ret = enable_kretprobe(&tp->rp);
+		else
+			ret = enable_kprobe(&tp->rp.kp);
+	}
+
+	return ret;
+}
+
+/* Disable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
+static void disable_trace_probe(struct trace_probe *tp, int flag)
+{
+	tp->flags &= ~flag;
+	if (!trace_probe_is_enabled(tp) && trace_probe_is_registered(tp)) {
+		if (trace_probe_is_return(tp))
+			disable_kretprobe(&tp->rp);
+		else
+			disable_kprobe(&tp->rp.kp);
+	}
+}
+
+/* Internal register function - just handle k*probes and flags */
+static int __register_trace_probe(struct trace_probe *tp)
+{
+	int i, ret;
+
+	if (trace_probe_is_registered(tp))
+		return -EINVAL;
+
+	for (i = 0; i < tp->nr_args; i++)
+		update_probe_arg(&tp->args[i]);
+
+	/* Set/clear disabled flag according to tp->flag */
+	if (trace_probe_is_enabled(tp))
+		tp->rp.kp.flags &= ~KPROBE_FLAG_DISABLED;
+	else
+		tp->rp.kp.flags |= KPROBE_FLAG_DISABLED;
+
+	if (trace_probe_is_return(tp))
+		ret = register_kretprobe(&tp->rp);
+	else
+		ret = register_kprobe(&tp->rp.kp);
+
+	if (ret == 0)
+		tp->flags |= TP_FLAG_REGISTERED;
+	else {
+		pr_warning("Could not insert probe at %s+%lu: %d\n",
+			   trace_probe_symbol(tp), trace_probe_offset(tp), ret);
+		if (ret == -ENOENT && trace_probe_is_on_module(tp)) {
+			pr_warning("This probe might be able to register after"
+				   "target module is loaded. Continue.\n");
+			ret = 0;
+		} else if (ret == -EILSEQ) {
+			pr_warning("Probing address(0x%p) is not an "
+				   "instruction boundary.\n",
+				   tp->rp.kp.addr);
+			ret = -EINVAL;
+		}
+	}
+
+	return ret;
+}
+
+/* Internal unregister function - just handle k*probes and flags */
+static void __unregister_trace_probe(struct trace_probe *tp)
+{
+	if (trace_probe_is_registered(tp)) {
+		if (trace_probe_is_return(tp))
+			unregister_kretprobe(&tp->rp);
+		else
+			unregister_kprobe(&tp->rp.kp);
+		tp->flags &= ~TP_FLAG_REGISTERED;
+		/* Cleanup kprobe for reuse */
+		if (tp->rp.kp.symbol_name)
+			tp->rp.kp.addr = NULL;
+	}
+}
+
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
 static void unregister_trace_probe(struct trace_probe *tp)
 {
-	if (probe_is_return(tp))
-		unregister_kretprobe(&tp->rp);
-	else
-		unregister_kprobe(&tp->rp.kp);
+	__unregister_trace_probe(tp);
 	list_del(&tp->list);
 	unregister_probe_event(tp);
 }
@@ -702,41 +851,65 @@ static int register_trace_probe(struct trace_probe *tp)
 
 	mutex_lock(&probe_lock);
 
-	/* register as an event */
-	old_tp = find_probe_event(tp->call.name, tp->call.class->system);
+	/* Delete old (same name) event if exist */
+	old_tp = find_trace_probe(tp->call.name, tp->call.class->system);
 	if (old_tp) {
-		/* delete old event */
 		unregister_trace_probe(old_tp);
 		free_trace_probe(old_tp);
 	}
+
+	/* Register new event */
 	ret = register_probe_event(tp);
 	if (ret) {
 		pr_warning("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
-	tp->rp.kp.flags |= KPROBE_FLAG_DISABLED;
-	if (probe_is_return(tp))
-		ret = register_kretprobe(&tp->rp);
-	else
-		ret = register_kprobe(&tp->rp.kp);
-
-	if (ret) {
-		pr_warning("Could not insert probe(%d)\n", ret);
-		if (ret == -EILSEQ) {
-			pr_warning("Probing address(0x%p) is not an "
-				   "instruction boundary.\n",
-				   tp->rp.kp.addr);
-			ret = -EINVAL;
-		}
+	/* Register k*probe */
+	ret = __register_trace_probe(tp);
+	if (ret < 0)
 		unregister_probe_event(tp);
-	} else
+	else
 		list_add_tail(&tp->list, &probe_list);
+
 end:
 	mutex_unlock(&probe_lock);
 	return ret;
 }
 
+/* Module notifier call back, checking event on the module */
+static int trace_probe_module_callback(struct notifier_block *nb,
+				       unsigned long val, void *data)
+{
+	struct module *mod = data;
+	struct trace_probe *tp;
+	int ret;
+
+	if (val != MODULE_STATE_COMING)
+		return NOTIFY_DONE;
+
+	/* Update probes on coming module */
+	mutex_lock(&probe_lock);
+	list_for_each_entry(tp, &probe_list, list) {
+		if (trace_probe_within_module(tp, mod)) {
+			__unregister_trace_probe(tp);
+			ret = __register_trace_probe(tp);
+			if (ret)
+				pr_warning("Failed to re-register probe %s on"
+					   "%s: %d\n",
+					   tp->call.name, mod->name, ret);
+		}
+	}
+	mutex_unlock(&probe_lock);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block trace_probe_module_nb = {
+	.notifier_call = trace_probe_module_callback,
+	.priority = 1	/* Invoked after kprobe module callback */
+};
+
 /* Split symbol and offset. */
 static int split_symbol_offset(char *symbol, unsigned long *offset)
 {
@@ -962,8 +1135,8 @@ static int create_trace_probe(int argc, char **argv)
 {
 	/*
 	 * Argument syntax:
-	 *  - Add kprobe: p[:[GRP/]EVENT] KSYM[+OFFS]|KADDR [FETCHARGS]
-	 *  - Add kretprobe: r[:[GRP/]EVENT] KSYM[+0] [FETCHARGS]
+	 *  - Add kprobe: p[:[GRP/]EVENT] [MOD:]KSYM[+OFFS]|KADDR [FETCHARGS]
+	 *  - Add kretprobe: r[:[GRP/]EVENT] [MOD:]KSYM[+0] [FETCHARGS]
 	 * Fetch args:
 	 *  $retval	: fetch return value
 	 *  $stack	: fetch stack address
@@ -1025,7 +1198,7 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 		mutex_lock(&probe_lock);
-		tp = find_probe_event(event, group);
+		tp = find_trace_probe(event, group);
 		if (!tp) {
 			mutex_unlock(&probe_lock);
 			pr_info("Event %s/%s doesn't exist.\n", group, event);
@@ -1144,7 +1317,7 @@ error:
 	return ret;
 }
 
-static void cleanup_all_probes(void)
+static void release_all_trace_probes(void)
 {
 	struct trace_probe *tp;
 
@@ -1158,7 +1331,6 @@ static void cleanup_all_probes(void)
 	mutex_unlock(&probe_lock);
 }
 
-
 /* Probes listing interfaces */
 static void *probes_seq_start(struct seq_file *m, loff_t *pos)
 {
@@ -1181,15 +1353,16 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	struct trace_probe *tp = v;
 	int i;
 
-	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
+	seq_printf(m, "%c", trace_probe_is_return(tp) ? 'r' : 'p');
 	seq_printf(m, ":%s/%s", tp->call.class->system, tp->call.name);
 
 	if (!tp->symbol)
 		seq_printf(m, " 0x%p", tp->rp.kp.addr);
 	else if (tp->rp.kp.offset)
-		seq_printf(m, " %s+%u", probe_symbol(tp), tp->rp.kp.offset);
+		seq_printf(m, " %s+%u", trace_probe_symbol(tp),
+			   tp->rp.kp.offset);
 	else
-		seq_printf(m, " %s", probe_symbol(tp));
+		seq_printf(m, " %s", trace_probe_symbol(tp));
 
 	for (i = 0; i < tp->nr_args; i++)
 		seq_printf(m, " %s=%s", tp->args[i].name, tp->args[i].comm);
@@ -1209,7 +1382,7 @@ static int probes_open(struct inode *inode, struct file *file)
 {
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
-		cleanup_all_probes();
+		release_all_trace_probes();
 
 	return seq_open(file, &probes_seq_op);
 }
@@ -1397,7 +1570,8 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
+		trace_nowake_buffer_unlock_commit_regs(buffer, event,
+						       irq_flags, pc, regs);
 }
 
 /* Kretprobe handler */
@@ -1429,7 +1603,8 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
+		trace_nowake_buffer_unlock_commit_regs(buffer, event,
+						       irq_flags, pc, regs);
 }
 
 /* Event entry printers */
@@ -1511,30 +1686,6 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int probe_event_enable(struct ftrace_event_call *call)
-{
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	tp->flags |= TP_FLAG_TRACE;
-	if (probe_is_return(tp))
-		return enable_kretprobe(&tp->rp);
-	else
-		return enable_kprobe(&tp->rp.kp);
-}
-
-static void probe_event_disable(struct ftrace_event_call *call)
-{
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	tp->flags &= ~TP_FLAG_TRACE;
-	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
-		if (probe_is_return(tp))
-			disable_kretprobe(&tp->rp);
-		else
-			disable_kprobe(&tp->rp.kp);
-	}
-}
-
 #undef DEFINE_FIELD
 #define DEFINE_FIELD(type, item, name, is_signed)			\
 	do {								\
@@ -1596,7 +1747,7 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 
 	const char *fmt, *arg;
 
-	if (!probe_is_return(tp)) {
+	if (!trace_probe_is_return(tp)) {
 		fmt = "(%lx)";
 		arg = "REC->" FIELD_STRING_IP;
 	} else {
@@ -1713,49 +1864,25 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
 }
-
-static int probe_perf_enable(struct ftrace_event_call *call)
-{
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	tp->flags |= TP_FLAG_PROFILE;
-
-	if (probe_is_return(tp))
-		return enable_kretprobe(&tp->rp);
-	else
-		return enable_kprobe(&tp->rp.kp);
-}
-
-static void probe_perf_disable(struct ftrace_event_call *call)
-{
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	tp->flags &= ~TP_FLAG_PROFILE;
-
-	if (!(tp->flags & TP_FLAG_TRACE)) {
-		if (probe_is_return(tp))
-			disable_kretprobe(&tp->rp);
-		else
-			disable_kprobe(&tp->rp.kp);
-	}
-}
 #endif	/* CONFIG_PERF_EVENTS */
 
 static __kprobes
 int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
 {
+	struct trace_probe *tp = (struct trace_probe *)event->data;
+
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return probe_event_enable(event);
+		return enable_trace_probe(tp, TP_FLAG_TRACE);
 	case TRACE_REG_UNREGISTER:
-		probe_event_disable(event);
+		disable_trace_probe(tp, TP_FLAG_TRACE);
 		return 0;
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return probe_perf_enable(event);
+		return enable_trace_probe(tp, TP_FLAG_PROFILE);
 	case TRACE_REG_PERF_UNREGISTER:
-		probe_perf_disable(event);
+		disable_trace_probe(tp, TP_FLAG_PROFILE);
 		return 0;
 #endif
 	}
@@ -1805,7 +1932,7 @@ static int register_probe_event(struct trace_probe *tp)
 
 	/* Initialize ftrace_event_call */
 	INIT_LIST_HEAD(&call->class->fields);
-	if (probe_is_return(tp)) {
+	if (trace_probe_is_return(tp)) {
 		call->event.funcs = &kretprobe_funcs;
 		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
@@ -1844,6 +1971,9 @@ static __init int init_kprobe_trace(void)
 	struct dentry *d_tracer;
 	struct dentry *entry;
 
+	if (register_module_notifier(&trace_probe_module_nb))
+		return -EINVAL;
+
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
 		return 0;
@@ -1897,12 +2027,12 @@ static __init int kprobe_trace_self_tests_init(void)
 		warn++;
 	} else {
 		/* Enable trace point */
-		tp = find_probe_event("testprobe", KPROBE_EVENT_SYSTEM);
+		tp = find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp == NULL)) {
 			pr_warning("error on getting new probe.\n");
 			warn++;
 		} else
-			probe_event_enable(&tp->call);
+			enable_trace_probe(tp, TP_FLAG_TRACE);
 	}
 
 	ret = command_trace_probe("r:testprobe2 kprobe_trace_selftest_target "
@@ -1912,12 +2042,12 @@ static __init int kprobe_trace_self_tests_init(void)
 		warn++;
 	} else {
 		/* Enable trace point */
-		tp = find_probe_event("testprobe2", KPROBE_EVENT_SYSTEM);
+		tp = find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp == NULL)) {
 			pr_warning("error on getting new probe.\n");
 			warn++;
 		} else
-			probe_event_enable(&tp->call);
+			enable_trace_probe(tp, TP_FLAG_TRACE);
 	}
 
 	if (warn)
@@ -1938,7 +2068,7 @@ static __init int kprobe_trace_self_tests_init(void)
 	}
 
 end:
-	cleanup_all_probes();
+	release_all_trace_probes();
 	if (warn)
 		pr_cont("NG: Some tests are failed. Please check them.\n");
 	else
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index e37de49..5199930 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1107,19 +1107,20 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 {
 	struct stack_entry *field;
 	struct trace_seq *s = &iter->seq;
-	int i;
+	unsigned long *p;
+	unsigned long *end;
 
 	trace_assign_type(field, iter->ent);
+	end = (unsigned long *)((long)iter->ent + iter->ent_size);
 
 	if (!trace_seq_puts(s, "<stack trace>\n"))
 		goto partial;
-	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-		if (!field->caller[i] || (field->caller[i] == ULONG_MAX))
-			break;
+
+	for (p = field->caller; p && *p != ULONG_MAX && p < end; p++) {
 		if (!trace_seq_puts(s, " => "))
 			goto partial;
 
-		if (!seq_print_ip_sym(s, field->caller[i], flags))
+		if (!seq_print_ip_sym(s, *p, flags))
 			goto partial;
 		if (!trace_seq_puts(s, "\n"))
 			goto partial;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index f029dd4..e4a70c0 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -227,7 +227,9 @@ static void wakeup_trace_close(struct trace_iterator *iter)
 		graph_trace_close(iter);
 }
 
-#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_PROC)
+#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_PROC | \
+			    TRACE_GRAPH_PRINT_ABS_TIME | \
+			    TRACE_GRAPH_PRINT_DURATION)
 
 static enum print_line_t wakeup_print_line(struct trace_iterator *iter)
 {
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index b0b53b8..77575b3 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -156,20 +156,11 @@ stack_max_size_write(struct file *filp, const char __user *ubuf,
 {
 	long *ptr = filp->private_data;
 	unsigned long val, flags;
-	char buf[64];
 	int ret;
 	int cpu;
 
-	if (count >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, count))
-		return -EFAULT;
-
-	buf[count] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, count, 10, &val);
+	if (ret)
 		return ret;
 
 	local_irq_save(flags);
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 3d0c56a..36491cd 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -200,6 +200,7 @@ static int is_softlockup(unsigned long touch_ts)
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
+
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
 	.config		= PERF_COUNT_HW_CPU_CYCLES,
@@ -209,7 +210,7 @@ static struct perf_event_attr wd_hw_attr = {
 };
 
 /* Callback function for perf event subsystem */
-static void watchdog_overflow_callback(struct perf_event *event, int nmi,
+static void watchdog_overflow_callback(struct perf_event *event,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
 {
@@ -368,10 +369,11 @@ static int watchdog_nmi_enable(int cpu)
 	if (event != NULL)
 		goto out_enable;
 
-	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
 	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
-	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
+
+	/* Try to register using hardware perf events */
+	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
 		goto out_save;
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index 0636539..ef7f322 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -41,7 +41,7 @@ module_param_string(ksym, ksym_name, KSYM_NAME_LEN, S_IRUGO);
 MODULE_PARM_DESC(ksym, "Kernel symbol to monitor; this module will report any"
 			" write operations on the kernel symbol");
 
-static void sample_hbp_handler(struct perf_event *bp, int nmi,
+static void sample_hbp_handler(struct perf_event *bp,
 			       struct perf_sample_data *data,
 			       struct pt_regs *regs)
 {
@@ -60,7 +60,7 @@ static int __init hw_break_module_init(void)
 	attr.bp_len = HW_BREAKPOINT_LEN_4;
 	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
 
-	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler);
+	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler, NULL);
 	if (IS_ERR((void __force *)sample_hbp)) {
 		ret = PTR_ERR((void __force *)sample_hbp);
 		goto fail;
diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 6f5a498..85c5f02 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -66,6 +66,12 @@ OPTIONS
 	used. This interfaces starts by centering on the line with more
 	samples, TAB/UNTAB cycles through the lines with more samples.
 
+-c::
+--cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
+	be provided as a comma-separated list with no space: 0,1. Ranges of
+	CPUs are specified with -: 0-2. Default is to report samples on all
+	CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 02bafce..2780d9c 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -34,9 +34,11 @@ OPTIONS
 	Specify vmlinux path which has debuginfo (Dwarf binary).
 
 -m::
---module=MODNAME::
+--module=MODNAME|PATH::
 	Specify module name in which perf-probe searches probe points
-	or lines.
+	or lines. If a path of module file is passed, perf-probe
+	treat it as an offline module (this means you can add a probe on
+        a module which has not been loaded yet).
 
 -s::
 --source=PATH::
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8ba03d6..04253c0 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -80,15 +80,24 @@ OPTIONS
 --dump-raw-trace::
         Dump raw trace in ASCII.
 
--g [type,min]::
+-g [type,min,order]::
 --call-graph::
-        Display call chains using type and min percent threshold.
+        Display call chains using type, min percent threshold and order.
 	type can be either:
 	- flat: single column, linear exposure of call chains.
 	- graph: use a graph tree, displaying absolute overhead rates.
 	- fractal: like graph, but displays relative rates. Each branch of
 		 the tree is considered as a new profiled object. +
-	Default: fractal,0.5.
+
+	order can be either:
+	- callee: callee based call graph.
+	- caller: inverted caller based call graph.
+
+	Default: fractal,0.5,callee.
+
+-G::
+--inverted::
+        alias for inverted caller based call graph.
 
 --pretty=<key>::
         Pretty printing style.  key: normal, raw
@@ -119,6 +128,12 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
+-c::
+--cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
+	be provided as a comma-separated list with no space: 0,1. Ranges of
+	CPUs are specified with -: 0-2. Default is to report samples on all
+	CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 86c87e2..db01786 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,10 +115,10 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, sym. Field
-        list can be prepended with the type, trace, sw or hw,
+        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr.
+        Field list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
-        e.g., -f sw:comm,tid,time,sym  and -f trace:time,cpu,trace
+        e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
 
 		perf script -f <fields>
 
@@ -132,17 +132,17 @@ OPTIONS
 	The arguments are processed in the order received. A later usage can
 	reset a prior request. e.g.:
     
-		-f trace: -f comm,tid,time,sym
+		-f trace: -f comm,tid,time,ip,sym
     
 	The first -f suppresses trace events (field list is ""), but then the
-	second invocation sets the fields to comm,tid,time,sym. In this case a
+	second invocation sets the fields to comm,tid,time,ip,sym. In this case a
 	warning is given to the user:
     
 		"Overriding previous field request for all events."
     
 	Alternativey, consider the order:
     
-		-f comm,tid,time,sym -f trace:
+		-f comm,tid,time,ip,sym -f trace:
     
 	The first -f sets the fields for all events and the second -f
 	suppresses trace events. The user is given a warning message about
@@ -182,6 +182,12 @@ OPTIONS
 --hide-call-graph::
         When printing symbols do not display call chain.
 
+-c::
+--cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
+	be provided as a comma-separated list with no space: 0,1. Ranges of
+	CPUs are specified with -: 0-2. Default is to report samples on all
+	CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 940257b..d0861bb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -279,6 +279,7 @@ LIB_H += util/thread.h
 LIB_H += util/thread_map.h
 LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
+LIB_H += util/dwarf-aux.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
@@ -435,6 +436,7 @@ else
 	BASIC_CFLAGS += -DDWARF_SUPPORT
 	EXTLIBS += -lelf -ldw
 	LIB_OBJS += $(OUTPUT)util/probe-finder.o
+	LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
 endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7b139e1..555aefd 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -28,6 +28,8 @@
 #include "util/hist.h"
 #include "util/session.h"
 
+#include <linux/bitmap.h>
+
 static char		const *input_name = "perf.data";
 
 static bool		force, use_tui, use_stdio;
@@ -38,6 +40,9 @@ static bool		print_line;
 
 static const char *sym_hist_filter;
 
+static const char	*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+
 static int perf_evlist__add_sample(struct perf_evlist *evlist,
 				   struct perf_sample *sample,
 				   struct perf_evsel *evsel,
@@ -90,6 +95,9 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		return 0;
+
 	if (!al.filtered &&
 	    perf_evlist__add_sample(session->evlist, sample, evsel, &al)) {
 		pr_warning("problem incrementing symbol count, "
@@ -177,6 +185,12 @@ static int __cmd_annotate(void)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (cpu_list) {
+		ret = perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap);
+		if (ret)
+			goto out_delete;
+	}
+
 	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
@@ -252,6 +266,7 @@ static const struct option options[] = {
 		    "print matching source lines (may be slow)"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
+	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2c0e64d..5f2a5c7 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -242,7 +242,8 @@ static const struct option options[] = {
 	OPT_STRING('s', "source", &symbol_conf.source_prefix,
 		   "directory", "path to kernel source"),
 	OPT_STRING('m', "module", &params.target_module,
-		   "modname", "target module name"),
+		   "modname|path",
+		   "target module name (for online) or path (for offline)"),
 #endif
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8e2c857..80dc5b7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -740,7 +740,7 @@ static bool force, append_file;
 const struct option record_options[] = {
 	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
-		     parse_events),
+		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
 	OPT_INTEGER('p', "pid", &target_pid,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 287a173..f854efd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -33,6 +33,8 @@
 #include "util/sort.h"
 #include "util/hist.h"
 
+#include <linux/bitmap.h>
+
 static char		const *input_name = "perf.data";
 
 static bool		force, use_tui, use_stdio;
@@ -45,9 +47,13 @@ static struct perf_read_values	show_threads_values;
 static const char	default_pretty_printing_style[] = "normal";
 static const char	*pretty_printing_style = default_pretty_printing_style;
 
-static char		callchain_default_opt[] = "fractal,0.5";
+static char		callchain_default_opt[] = "fractal,0.5,callee";
+static bool		inverted_callchain;
 static symbol_filter_t	annotate_init;
 
+static const char	*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -116,6 +122,9 @@ static int process_sample_event(union perf_event *event,
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		return 0;
+
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
@@ -262,6 +271,12 @@ static int __cmd_report(void)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (cpu_list) {
+		ret = perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap);
+		if (ret)
+			goto out_delete;
+	}
+
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
@@ -386,13 +401,29 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	if (!tok)
 		goto setup;
 
-	tok2 = strtok(NULL, ",");
 	callchain_param.min_percent = strtod(tok, &endptr);
 	if (tok == endptr)
 		return -1;
 
-	if (tok2)
+	/* get the print limit */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+
+	if (tok2[0] != 'c') {
 		callchain_param.print_limit = strtod(tok2, &endptr);
+		tok2 = strtok(NULL, ",");
+		if (!tok2)
+			goto setup;
+	}
+
+	/* get the call chain order */
+	if (!strcmp(tok2, "caller"))
+		callchain_param.order = ORDER_CALLER;
+	else if (!strcmp(tok2, "callee"))
+		callchain_param.order = ORDER_CALLEE;
+	else
+		return -1;
 setup:
 	if (callchain_register_param(&callchain_param) < 0) {
 		fprintf(stderr, "Can't register callchain params\n");
@@ -436,9 +467,10 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
-		     "Display callchains using output_type (graph, flat, fractal, or none) and min percent threshold. "
-		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
+	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent, call_order",
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold and callchain order. "
+		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
+	OPT_BOOLEAN('G', "inverted", &inverted_callchain, "alias for inverted call graph"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
@@ -455,6 +487,7 @@ static const struct option options[] = {
 		    "Only display entries resolved to a symbol"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
+	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_END()
 };
 
@@ -467,6 +500,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	else if (use_tui)
 		use_browser = 1;
 
+	if (inverted_callchain)
+		callchain_param.order = ORDER_CALLER;
+
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
 	else
@@ -504,7 +540,14 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (parent_pattern != default_parent_pattern) {
 		if (sort_dimension__add("parent") < 0)
 			return -1;
-		sort_parent.elide = 1;
+
+		/*
+		 * Only show the parent fields if we explicitly
+		 * sort that way. If we only use parent machinery
+		 * for filtering, we don't want it.
+		 */
+		if (!strstr(sort_order, "parent"))
+			sort_parent.elide = 1;
 	} else
 		symbol_conf.exclude_other = false;
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 22747de..09024ec 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -13,6 +13,7 @@
 #include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
+#include <linux/bitmap.h>
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -21,6 +22,8 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
+static const char		*cpu_list;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
 enum perf_output_field {
 	PERF_OUTPUT_COMM            = 1U << 0,
@@ -30,7 +33,10 @@ enum perf_output_field {
 	PERF_OUTPUT_CPU             = 1U << 4,
 	PERF_OUTPUT_EVNAME          = 1U << 5,
 	PERF_OUTPUT_TRACE           = 1U << 6,
-	PERF_OUTPUT_SYM             = 1U << 7,
+	PERF_OUTPUT_IP              = 1U << 7,
+	PERF_OUTPUT_SYM             = 1U << 8,
+	PERF_OUTPUT_DSO             = 1U << 9,
+	PERF_OUTPUT_ADDR            = 1U << 10,
 };
 
 struct output_option {
@@ -44,7 +50,10 @@ struct output_option {
 	{.str = "cpu",   .field = PERF_OUTPUT_CPU},
 	{.str = "event", .field = PERF_OUTPUT_EVNAME},
 	{.str = "trace", .field = PERF_OUTPUT_TRACE},
+	{.str = "ip",    .field = PERF_OUTPUT_IP},
 	{.str = "sym",   .field = PERF_OUTPUT_SYM},
+	{.str = "dso",   .field = PERF_OUTPUT_DSO},
+	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
 };
 
 /* default set to maintain compatibility with current format */
@@ -60,7 +69,8 @@ static struct {
 
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
-			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
+				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -70,7 +80,8 @@ static struct {
 
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
-			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
+				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -88,7 +99,8 @@ static struct {
 
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
-			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
+				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -157,9 +169,9 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		!perf_session__has_traces(session, "record -R"))
 		return -EINVAL;
 
-	if (PRINT_FIELD(SYM)) {
+	if (PRINT_FIELD(IP)) {
 		if (perf_event_attr__check_stype(attr, PERF_SAMPLE_IP, "IP",
-					   PERF_OUTPUT_SYM))
+					   PERF_OUTPUT_IP))
 			return -EINVAL;
 
 		if (!no_callchain &&
@@ -167,6 +179,24 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 			symbol_conf.use_callchain = false;
 	}
 
+	if (PRINT_FIELD(ADDR) &&
+		perf_event_attr__check_stype(attr, PERF_SAMPLE_ADDR, "ADDR",
+				       PERF_OUTPUT_ADDR))
+		return -EINVAL;
+
+	if (PRINT_FIELD(SYM) && !PRINT_FIELD(IP) && !PRINT_FIELD(ADDR)) {
+		pr_err("Display of symbols requested but neither sample IP nor "
+			   "sample address\nis selected. Hence, no addresses to convert "
+		       "to symbols.\n");
+		return -EINVAL;
+	}
+	if (PRINT_FIELD(DSO) && !PRINT_FIELD(IP) && !PRINT_FIELD(ADDR)) {
+		pr_err("Display of DSO requested but neither sample IP nor "
+			   "sample address\nis selected. Hence, no addresses to convert "
+		       "to DSO.\n");
+		return -EINVAL;
+	}
+
 	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
 		perf_event_attr__check_stype(attr, PERF_SAMPLE_TID, "TID",
 				       PERF_OUTPUT_TID|PERF_OUTPUT_PID))
@@ -230,7 +260,7 @@ static void print_sample_start(struct perf_sample *sample,
 	if (PRINT_FIELD(COMM)) {
 		if (latency_format)
 			printf("%8.8s ", thread->comm);
-		else if (PRINT_FIELD(SYM) && symbol_conf.use_callchain)
+		else if (PRINT_FIELD(IP) && symbol_conf.use_callchain)
 			printf("%s ", thread->comm);
 		else
 			printf("%16s ", thread->comm);
@@ -271,6 +301,63 @@ static void print_sample_start(struct perf_sample *sample,
 	}
 }
 
+static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
+{
+	if ((attr->type == PERF_TYPE_SOFTWARE) &&
+	    ((attr->config == PERF_COUNT_SW_PAGE_FAULTS) ||
+	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MIN) ||
+	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)))
+		return true;
+
+	return false;
+}
+
+static void print_sample_addr(union perf_event *event,
+			  struct perf_sample *sample,
+			  struct perf_session *session,
+			  struct thread *thread,
+			  struct perf_event_attr *attr)
+{
+	struct addr_location al;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	const char *symname, *dsoname;
+
+	printf("%16" PRIx64, sample->addr);
+
+	if (!sample_addr_correlates_sym(attr))
+		return;
+
+	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
+			      event->ip.pid, sample->addr, &al);
+	if (!al.map)
+		thread__find_addr_map(thread, session, cpumode, MAP__VARIABLE,
+				      event->ip.pid, sample->addr, &al);
+
+	al.cpu = sample->cpu;
+	al.sym = NULL;
+
+	if (al.map)
+		al.sym = map__find_symbol(al.map, al.addr, NULL);
+
+	if (PRINT_FIELD(SYM)) {
+		if (al.sym && al.sym->name)
+			symname = al.sym->name;
+		else
+			symname = "";
+
+		printf(" %16s", symname);
+	}
+
+	if (PRINT_FIELD(DSO)) {
+		if (al.map && al.map->dso && al.map->dso->name)
+			dsoname = al.map->dso->name;
+		else
+			dsoname = "";
+
+		printf(" (%s)", dsoname);
+	}
+}
+
 static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
@@ -288,12 +375,16 @@ static void process_event(union perf_event *event __unused,
 		print_trace_event(sample->cpu, sample->raw_data,
 				  sample->raw_size);
 
-	if (PRINT_FIELD(SYM)) {
+	if (PRINT_FIELD(ADDR))
+		print_sample_addr(event, sample, session, thread, attr);
+
+	if (PRINT_FIELD(IP)) {
 		if (!symbol_conf.use_callchain)
 			printf(" ");
 		else
 			printf("\n");
-		perf_session__print_symbols(event, sample, session);
+		perf_session__print_ip(event, sample, session,
+					      PRINT_FIELD(SYM), PRINT_FIELD(DSO));
 	}
 
 	printf("\n");
@@ -365,6 +456,10 @@ static int process_sample_event(union perf_event *event,
 		last_timestamp = sample->time;
 		return 0;
 	}
+
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		return 0;
+
 	scripting_ops->process_event(event, sample, evsel, session, thread);
 
 	session->hists.stats.total_period += sample->period;
@@ -985,8 +1080,9 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
+	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 
 	OPT_END()
 };
@@ -1167,6 +1263,11 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (cpu_list) {
+		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
+			return -1;
+	}
+
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
 	else
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a9f0671..1ad04ce 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -61,6 +61,8 @@
 #include <locale.h>
 
 #define DEFAULT_SEPARATOR	" "
+#define CNTR_NOT_SUPPORTED	"<not supported>"
+#define CNTR_NOT_COUNTED	"<not counted>"
 
 static struct perf_event_attr default_attrs[] = {
 
@@ -448,6 +450,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
 						    event_name(counter));
+				counter->supported = false;
 				continue;
 			}
 
@@ -466,6 +469,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 			die("Not all events could be opened.\n");
 			return -1;
 		}
+		counter->supported = true;
 	}
 
 	if (perf_evlist__set_filters(evsel_list)) {
@@ -513,7 +517,10 @@ static void print_noise_pct(double total, double avg)
 	if (avg)
 		pct = 100.0*total/avg;
 
-	fprintf(stderr, "  ( +-%6.2f%% )", pct);
+	if (csv_output)
+		fprintf(stderr, "%s%.2f%%", csv_sep, pct);
+	else
+		fprintf(stderr, "  ( +-%6.2f%% )", pct);
 }
 
 static void print_noise(struct perf_evsel *evsel, double avg)
@@ -861,7 +868,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	if (scaled == -1) {
 		fprintf(stderr, "%*s%s%*s",
 			csv_output ? 0 : 18,
-			"<not counted>",
+			counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 			csv_sep,
 			csv_output ? 0 : -24,
 			event_name(counter));
@@ -878,13 +885,13 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	else
 		abs_printout(-1, counter, avg);
 
+	print_noise(counter, avg);
+
 	if (csv_output) {
 		fputc('\n', stderr);
 		return;
 	}
 
-	print_noise(counter, avg);
-
 	if (scaled) {
 		double avg_enabled, avg_running;
 
@@ -914,7 +921,8 @@ static void print_counter(struct perf_evsel *counter)
 				csv_output ? 0 : -4,
 				evsel_list->cpus->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
-				"<not counted>", csv_sep,
+				counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
+				csv_sep,
 				csv_output ? 0 : -24,
 				event_name(counter));
 
@@ -1024,7 +1032,7 @@ static int stat__set_big_num(const struct option *opt __used,
 static const struct option options[] = {
 	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
-		     parse_events),
+		     parse_events_option),
 	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
 		     "event filter", parse_filter),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 2da9162..55f4c76 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -12,6 +12,7 @@
 #include "util/parse-events.h"
 #include "util/symbol.h"
 #include "util/thread_map.h"
+#include "../../include/linux/hw_breakpoint.h"
 
 static long page_size;
 
@@ -245,8 +246,8 @@ static int trace_event__id(const char *evname)
 	int err = -1, fd;
 
 	if (asprintf(&filename,
-		     "/sys/kernel/debug/tracing/events/syscalls/%s/id",
-		     evname) < 0)
+		     "%s/syscalls/%s/id",
+		     debugfs_path, evname) < 0)
 		return -1;
 
 	fd = open(filename, O_RDONLY);
@@ -600,6 +601,246 @@ out_free_threads:
 #undef nsyscalls
 }
 
+#define TEST_ASSERT_VAL(text, cond) \
+do { \
+	if (!cond) { \
+		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
+		return -1; \
+	} \
+} while (0)
+
+static int test__checkevent_tracepoint(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong sample_type",
+		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
+		evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
+	return 0;
+}
+
+static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_TRACEPOINT == evsel->attr.type);
+		TEST_ASSERT_VAL("wrong sample_type",
+			(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU)
+			== evsel->attr.sample_type);
+		TEST_ASSERT_VAL("wrong sample_period",
+			1 == evsel->attr.sample_period);
+	}
+	return 0;
+}
+
+static int test__checkevent_raw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_numeric(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_genhw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HW_CACHE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", (1 << 16) == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_breakpoint(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
+					 evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_4 ==
+					evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_X == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", sizeof(long) == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_R == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_W == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
+static struct test__event_st {
+	const char *name;
+	__u32 type;
+	int (*check)(struct perf_evlist *evlist);
+} test__events[] = {
+	{
+		.name  = "syscalls:sys_enter_open",
+		.check = test__checkevent_tracepoint,
+	},
+	{
+		.name  = "syscalls:*",
+		.check = test__checkevent_tracepoint_multi,
+	},
+	{
+		.name  = "r1",
+		.check = test__checkevent_raw,
+	},
+	{
+		.name  = "1:1",
+		.check = test__checkevent_numeric,
+	},
+	{
+		.name  = "instructions",
+		.check = test__checkevent_symbolic_name,
+	},
+	{
+		.name  = "faults",
+		.check = test__checkevent_symbolic_alias,
+	},
+	{
+		.name  = "L1-dcache-load-miss",
+		.check = test__checkevent_genhw,
+	},
+	{
+		.name  = "mem:0",
+		.check = test__checkevent_breakpoint,
+	},
+	{
+		.name  = "mem:0:x",
+		.check = test__checkevent_breakpoint_x,
+	},
+	{
+		.name  = "mem:0:r",
+		.check = test__checkevent_breakpoint_r,
+	},
+	{
+		.name  = "mem:0:w",
+		.check = test__checkevent_breakpoint_w,
+	},
+};
+
+#define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
+
+static int test__parse_events(void)
+{
+	struct perf_evlist *evlist;
+	u_int i;
+	int ret = 0;
+
+	for (i = 0; i < TEST__EVENTS_CNT; i++) {
+		struct test__event_st *e = &test__events[i];
+
+		evlist = perf_evlist__new(NULL, NULL);
+		if (evlist == NULL)
+			break;
+
+		ret = parse_events(evlist, e->name, 0);
+		if (ret) {
+			pr_debug("failed to parse event '%s', err %d\n",
+				 e->name, ret);
+			break;
+		}
+
+		ret = e->check(evlist);
+		if (ret)
+			break;
+
+		perf_evlist__delete(evlist);
+	}
+
+	return ret;
+}
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -621,6 +862,10 @@ static struct test {
 		.func = test__basic_mmap,
 	},
 	{
+		.desc = "parse events tests",
+		.func = test__parse_events,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f2f3f49..a43433f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -990,7 +990,7 @@ static const char * const top_usage[] = {
 static const struct option options[] = {
 	OPT_CALLBACK('e', "event", &top.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
-		     parse_events),
+		     parse_events_option),
 	OPT_INTEGER('c', "count", &default_interval,
 		    "event period to sample"),
 	OPT_INTEGER('p', "pid", &top.target_pid,
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 1a79df9..9b4ff16 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -14,6 +14,11 @@ enum chain_mode {
 	CHAIN_GRAPH_REL
 };
 
+enum chain_order {
+	ORDER_CALLER,
+	ORDER_CALLEE
+};
+
 struct callchain_node {
 	struct callchain_node	*parent;
 	struct list_head	siblings;
@@ -41,6 +46,7 @@ struct callchain_param {
 	u32			print_limit;
 	double			min_percent;
 	sort_chain_func_t	sort;
+	enum chain_order	order;
 };
 
 struct callchain_list {
diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
new file mode 100644
index 0000000..fddf40f
--- /dev/null
+++ b/tools/perf/util/dwarf-aux.c
@@ -0,0 +1,663 @@
+/*
+ * dwarf-aux.c : libdw auxiliary interfaces
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+
+#include <stdbool.h>
+#include "util.h"
+#include "debug.h"
+#include "dwarf-aux.h"
+
+/**
+ * cu_find_realpath - Find the realpath of the target file
+ * @cu_die: A DIE(dwarf information entry) of CU(compilation Unit)
+ * @fname:  The tail filename of the target file
+ *
+ * Find the real(long) path of @fname in @cu_die.
+ */
+const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname)
+{
+	Dwarf_Files *files;
+	size_t nfiles, i;
+	const char *src = NULL;
+	int ret;
+
+	if (!fname)
+		return NULL;
+
+	ret = dwarf_getsrcfiles(cu_die, &files, &nfiles);
+	if (ret != 0)
+		return NULL;
+
+	for (i = 0; i < nfiles; i++) {
+		src = dwarf_filesrc(files, i, NULL, NULL);
+		if (strtailcmp(src, fname) == 0)
+			break;
+	}
+	if (i == nfiles)
+		return NULL;
+	return src;
+}
+
+/**
+ * cu_get_comp_dir - Get the path of compilation directory
+ * @cu_die: a CU DIE
+ *
+ * Get the path of compilation directory of given @cu_die.
+ * Since this depends on DW_AT_comp_dir, older gcc will not
+ * embedded it. In that case, this returns NULL.
+ */
+const char *cu_get_comp_dir(Dwarf_Die *cu_die)
+{
+	Dwarf_Attribute attr;
+	if (dwarf_attr(cu_die, DW_AT_comp_dir, &attr) == NULL)
+		return NULL;
+	return dwarf_formstring(&attr);
+}
+
+/**
+ * cu_find_lineinfo - Get a line number and file name for given address
+ * @cu_die: a CU DIE
+ * @addr: An address
+ * @fname: a pointer which returns the file name string
+ * @lineno: a pointer which returns the line number
+ *
+ * Find a line number and file name for @addr in @cu_die.
+ */
+int cu_find_lineinfo(Dwarf_Die *cu_die, unsigned long addr,
+		    const char **fname, int *lineno)
+{
+	Dwarf_Line *line;
+	Dwarf_Addr laddr;
+
+	line = dwarf_getsrc_die(cu_die, (Dwarf_Addr)addr);
+	if (line && dwarf_lineaddr(line, &laddr) == 0 &&
+	    addr == (unsigned long)laddr && dwarf_lineno(line, lineno) == 0) {
+		*fname = dwarf_linesrc(line, NULL, NULL);
+		if (!*fname)
+			/* line number is useless without filename */
+			*lineno = 0;
+	}
+
+	return *lineno ?: -ENOENT;
+}
+
+/**
+ * die_compare_name - Compare diename and tname
+ * @dw_die: a DIE
+ * @tname: a string of target name
+ *
+ * Compare the name of @dw_die and @tname. Return false if @dw_die has no name.
+ */
+bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
+{
+	const char *name;
+	name = dwarf_diename(dw_die);
+	return name ? (strcmp(tname, name) == 0) : false;
+}
+
+/**
+ * die_get_call_lineno - Get callsite line number of inline-function instance
+ * @in_die: a DIE of an inlined function instance
+ *
+ * Get call-site line number of @in_die. This means from where the inline
+ * function is called.
+ */
+int die_get_call_lineno(Dwarf_Die *in_die)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Word ret;
+
+	if (!dwarf_attr(in_die, DW_AT_call_line, &attr))
+		return -ENOENT;
+
+	dwarf_formudata(&attr, &ret);
+	return (int)ret;
+}
+
+/**
+ * die_get_type - Get type DIE
+ * @vr_die: a DIE of a variable
+ * @die_mem: where to store a type DIE
+ *
+ * Get a DIE of the type of given variable (@vr_die), and store
+ * it to die_mem. Return NULL if fails to get a type DIE.
+ */
+Dwarf_Die *die_get_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
+{
+	Dwarf_Attribute attr;
+
+	if (dwarf_attr_integrate(vr_die, DW_AT_type, &attr) &&
+	    dwarf_formref_die(&attr, die_mem))
+		return die_mem;
+	else
+		return NULL;
+}
+
+/* Get a type die, but skip qualifiers */
+static Dwarf_Die *__die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
+{
+	int tag;
+
+	do {
+		vr_die = die_get_type(vr_die, die_mem);
+		if (!vr_die)
+			break;
+		tag = dwarf_tag(vr_die);
+	} while (tag == DW_TAG_const_type ||
+		 tag == DW_TAG_restrict_type ||
+		 tag == DW_TAG_volatile_type ||
+		 tag == DW_TAG_shared_type);
+
+	return vr_die;
+}
+
+/**
+ * die_get_real_type - Get a type die, but skip qualifiers and typedef
+ * @vr_die: a DIE of a variable
+ * @die_mem: where to store a type DIE
+ *
+ * Get a DIE of the type of given variable (@vr_die), and store
+ * it to die_mem. Return NULL if fails to get a type DIE.
+ * If the type is qualifiers (e.g. const) or typedef, this skips it
+ * and tries to find real type (structure or basic types, e.g. int).
+ */
+Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
+{
+	do {
+		vr_die = __die_get_real_type(vr_die, die_mem);
+	} while (vr_die && dwarf_tag(vr_die) == DW_TAG_typedef);
+
+	return vr_die;
+}
+
+/* Get attribute and translate it as a udata */
+static int die_get_attr_udata(Dwarf_Die *tp_die, unsigned int attr_name,
+			      Dwarf_Word *result)
+{
+	Dwarf_Attribute attr;
+
+	if (dwarf_attr(tp_die, attr_name, &attr) == NULL ||
+	    dwarf_formudata(&attr, result) != 0)
+		return -ENOENT;
+
+	return 0;
+}
+
+/**
+ * die_is_signed_type - Check whether a type DIE is signed or not
+ * @tp_die: a DIE of a type
+ *
+ * Get the encoding of @tp_die and return true if the encoding
+ * is signed.
+ */
+bool die_is_signed_type(Dwarf_Die *tp_die)
+{
+	Dwarf_Word ret;
+
+	if (die_get_attr_udata(tp_die, DW_AT_encoding, &ret))
+		return false;
+
+	return (ret == DW_ATE_signed_char || ret == DW_ATE_signed ||
+		ret == DW_ATE_signed_fixed);
+}
+
+/**
+ * die_get_data_member_location - Get the data-member offset
+ * @mb_die: a DIE of a member of a data structure
+ * @offs: The offset of the member in the data structure
+ *
+ * Get the offset of @mb_die in the data structure including @mb_die, and
+ * stores result offset to @offs. If any error occurs this returns errno.
+ */
+int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Op *expr;
+	size_t nexpr;
+	int ret;
+
+	if (dwarf_attr(mb_die, DW_AT_data_member_location, &attr) == NULL)
+		return -ENOENT;
+
+	if (dwarf_formudata(&attr, offs) != 0) {
+		/* DW_AT_data_member_location should be DW_OP_plus_uconst */
+		ret = dwarf_getlocation(&attr, &expr, &nexpr);
+		if (ret < 0 || nexpr == 0)
+			return -ENOENT;
+
+		if (expr[0].atom != DW_OP_plus_uconst || nexpr != 1) {
+			pr_debug("Unable to get offset:Unexpected OP %x (%zd)\n",
+				 expr[0].atom, nexpr);
+			return -ENOTSUP;
+		}
+		*offs = (Dwarf_Word)expr[0].number;
+	}
+	return 0;
+}
+
+/**
+ * die_find_child - Generic DIE search function in DIE tree
+ * @rt_die: a root DIE
+ * @callback: a callback function
+ * @data: a user data passed to the callback function
+ * @die_mem: a buffer for result DIE
+ *
+ * Trace DIE tree from @rt_die and call @callback for each child DIE.
+ * If @callback returns DIE_FIND_CB_END, this stores the DIE into
+ * @die_mem and returns it. If @callback returns DIE_FIND_CB_CONTINUE,
+ * this continues to trace the tree. Optionally, @callback can return
+ * DIE_FIND_CB_CHILD and DIE_FIND_CB_SIBLING, those means trace only
+ * the children and trace only the siblings respectively.
+ * Returns NULL if @callback can't find any appropriate DIE.
+ */
+Dwarf_Die *die_find_child(Dwarf_Die *rt_die,
+			  int (*callback)(Dwarf_Die *, void *),
+			  void *data, Dwarf_Die *die_mem)
+{
+	Dwarf_Die child_die;
+	int ret;
+
+	ret = dwarf_child(rt_die, die_mem);
+	if (ret != 0)
+		return NULL;
+
+	do {
+		ret = callback(die_mem, data);
+		if (ret == DIE_FIND_CB_END)
+			return die_mem;
+
+		if ((ret & DIE_FIND_CB_CHILD) &&
+		    die_find_child(die_mem, callback, data, &child_die)) {
+			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
+			return die_mem;
+		}
+	} while ((ret & DIE_FIND_CB_SIBLING) &&
+		 dwarf_siblingof(die_mem, die_mem) == 0);
+
+	return NULL;
+}
+
+struct __addr_die_search_param {
+	Dwarf_Addr	addr;
+	Dwarf_Die	*die_mem;
+};
+
+/* die_find callback for non-inlined function search */
+static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
+{
+	struct __addr_die_search_param *ad = data;
+
+	if (dwarf_tag(fn_die) == DW_TAG_subprogram &&
+	    dwarf_haspc(fn_die, ad->addr)) {
+		memcpy(ad->die_mem, fn_die, sizeof(Dwarf_Die));
+		return DWARF_CB_ABORT;
+	}
+	return DWARF_CB_OK;
+}
+
+/**
+ * die_find_realfunc - Search a non-inlined function at given address
+ * @cu_die: a CU DIE which including @addr
+ * @addr: target address
+ * @die_mem: a buffer for result DIE
+ *
+ * Search a non-inlined function DIE which includes @addr. Stores the
+ * DIE to @die_mem and returns it if found. Returns NULl if failed.
+ */
+Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
+				    Dwarf_Die *die_mem)
+{
+	struct __addr_die_search_param ad;
+	ad.addr = addr;
+	ad.die_mem = die_mem;
+	/* dwarf_getscopes can't find subprogram. */
+	if (!dwarf_getfuncs(cu_die, __die_search_func_cb, &ad, 0))
+		return NULL;
+	else
+		return die_mem;
+}
+
+/* die_find callback for inline function search */
+static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data)
+{
+	Dwarf_Addr *addr = data;
+
+	if (dwarf_tag(die_mem) == DW_TAG_inlined_subroutine &&
+	    dwarf_haspc(die_mem, *addr))
+		return DIE_FIND_CB_END;
+
+	return DIE_FIND_CB_CONTINUE;
+}
+
+/**
+ * die_find_inlinefunc - Search an inlined function at given address
+ * @cu_die: a CU DIE which including @addr
+ * @addr: target address
+ * @die_mem: a buffer for result DIE
+ *
+ * Search an inlined function DIE which includes @addr. Stores the
+ * DIE to @die_mem and returns it if found. Returns NULl if failed.
+ * If several inlined functions are expanded recursively, this trace
+ * it and returns deepest one.
+ */
+Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+			       Dwarf_Die *die_mem)
+{
+	Dwarf_Die tmp_die;
+
+	sp_die = die_find_child(sp_die, __die_find_inline_cb, &addr, &tmp_die);
+	if (!sp_die)
+		return NULL;
+
+	/* Inlined function could be recursive. Trace it until fail */
+	while (sp_die) {
+		memcpy(die_mem, sp_die, sizeof(Dwarf_Die));
+		sp_die = die_find_child(sp_die, __die_find_inline_cb, &addr,
+					&tmp_die);
+	}
+
+	return die_mem;
+}
+
+/* Line walker internal parameters */
+struct __line_walk_param {
+	const char *fname;
+	line_walk_callback_t callback;
+	void *data;
+	int retval;
+};
+
+static int __die_walk_funclines_cb(Dwarf_Die *in_die, void *data)
+{
+	struct __line_walk_param *lw = data;
+	Dwarf_Addr addr;
+	int lineno;
+
+	if (dwarf_tag(in_die) == DW_TAG_inlined_subroutine) {
+		lineno = die_get_call_lineno(in_die);
+		if (lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
+			lw->retval = lw->callback(lw->fname, lineno, addr,
+						  lw->data);
+			if (lw->retval != 0)
+				return DIE_FIND_CB_END;
+		}
+	}
+	return DIE_FIND_CB_SIBLING;
+}
+
+/* Walk on lines of blocks included in given DIE */
+static int __die_walk_funclines(Dwarf_Die *sp_die,
+				line_walk_callback_t callback, void *data)
+{
+	struct __line_walk_param lw = {
+		.callback = callback,
+		.data = data,
+		.retval = 0,
+	};
+	Dwarf_Die die_mem;
+	Dwarf_Addr addr;
+	int lineno;
+
+	/* Handle function declaration line */
+	lw.fname = dwarf_decl_file(sp_die);
+	if (lw.fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
+	    dwarf_entrypc(sp_die, &addr) == 0) {
+		lw.retval = callback(lw.fname, lineno, addr, data);
+		if (lw.retval != 0)
+			goto done;
+	}
+	die_find_child(sp_die, __die_walk_funclines_cb, &lw, &die_mem);
+done:
+	return lw.retval;
+}
+
+static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
+{
+	struct __line_walk_param *lw = data;
+
+	lw->retval = __die_walk_funclines(sp_die, lw->callback, lw->data);
+	if (lw->retval != 0)
+		return DWARF_CB_ABORT;
+
+	return DWARF_CB_OK;
+}
+
+/**
+ * die_walk_lines - Walk on lines inside given DIE
+ * @rt_die: a root DIE (CU or subprogram)
+ * @callback: callback routine
+ * @data: user data
+ *
+ * Walk on all lines inside given @rt_die and call @callback on each line.
+ * If the @rt_die is a function, walk only on the lines inside the function,
+ * otherwise @rt_die must be a CU DIE.
+ * Note that this walks not only dwarf line list, but also function entries
+ * and inline call-site.
+ */
+int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
+{
+	Dwarf_Lines *lines;
+	Dwarf_Line *line;
+	Dwarf_Addr addr;
+	const char *fname;
+	int lineno, ret = 0;
+	Dwarf_Die die_mem, *cu_die;
+	size_t nlines, i;
+
+	/* Get the CU die */
+	if (dwarf_tag(rt_die) == DW_TAG_subprogram)
+		cu_die = dwarf_diecu(rt_die, &die_mem, NULL, NULL);
+	else
+		cu_die = rt_die;
+	if (!cu_die) {
+		pr_debug2("Failed to get CU from subprogram\n");
+		return -EINVAL;
+	}
+
+	/* Get lines list in the CU */
+	if (dwarf_getsrclines(cu_die, &lines, &nlines) != 0) {
+		pr_debug2("Failed to get source lines on this CU.\n");
+		return -ENOENT;
+	}
+	pr_debug2("Get %zd lines from this CU\n", nlines);
+
+	/* Walk on the lines on lines list */
+	for (i = 0; i < nlines; i++) {
+		line = dwarf_onesrcline(lines, i);
+		if (line == NULL ||
+		    dwarf_lineno(line, &lineno) != 0 ||
+		    dwarf_lineaddr(line, &addr) != 0) {
+			pr_debug2("Failed to get line info. "
+				  "Possible error in debuginfo.\n");
+			continue;
+		}
+		/* Filter lines based on address */
+		if (rt_die != cu_die)
+			/*
+			 * Address filtering
+			 * The line is included in given function, and
+			 * no inline block includes it.
+			 */
+			if (!dwarf_haspc(rt_die, addr) ||
+			    die_find_inlinefunc(rt_die, addr, &die_mem))
+				continue;
+		/* Get source line */
+		fname = dwarf_linesrc(line, NULL, NULL);
+
+		ret = callback(fname, lineno, addr, data);
+		if (ret != 0)
+			return ret;
+	}
+
+	/*
+	 * Dwarf lines doesn't include function declarations and inlined
+	 * subroutines. We have to check functions list or given function.
+	 */
+	if (rt_die != cu_die)
+		ret = __die_walk_funclines(rt_die, callback, data);
+	else {
+		struct __line_walk_param param = {
+			.callback = callback,
+			.data = data,
+			.retval = 0,
+		};
+		dwarf_getfuncs(cu_die, __die_walk_culines_cb, &param, 0);
+		ret = param.retval;
+	}
+
+	return ret;
+}
+
+struct __find_variable_param {
+	const char *name;
+	Dwarf_Addr addr;
+};
+
+static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
+{
+	struct __find_variable_param *fvp = data;
+	int tag;
+
+	tag = dwarf_tag(die_mem);
+	if ((tag == DW_TAG_formal_parameter ||
+	     tag == DW_TAG_variable) &&
+	    die_compare_name(die_mem, fvp->name))
+		return DIE_FIND_CB_END;
+
+	if (dwarf_haspc(die_mem, fvp->addr))
+		return DIE_FIND_CB_CONTINUE;
+	else
+		return DIE_FIND_CB_SIBLING;
+}
+
+/**
+ * die_find_variable_at - Find a given name variable at given address
+ * @sp_die: a function DIE
+ * @name: variable name
+ * @addr: address
+ * @die_mem: a buffer for result DIE
+ *
+ * Find a variable DIE called @name at @addr in @sp_die.
+ */
+Dwarf_Die *die_find_variable_at(Dwarf_Die *sp_die, const char *name,
+				Dwarf_Addr addr, Dwarf_Die *die_mem)
+{
+	struct __find_variable_param fvp = { .name = name, .addr = addr};
+
+	return die_find_child(sp_die, __die_find_variable_cb, (void *)&fvp,
+			      die_mem);
+}
+
+static int __die_find_member_cb(Dwarf_Die *die_mem, void *data)
+{
+	const char *name = data;
+
+	if ((dwarf_tag(die_mem) == DW_TAG_member) &&
+	    die_compare_name(die_mem, name))
+		return DIE_FIND_CB_END;
+
+	return DIE_FIND_CB_SIBLING;
+}
+
+/**
+ * die_find_member - Find a given name member in a data structure
+ * @st_die: a data structure type DIE
+ * @name: member name
+ * @die_mem: a buffer for result DIE
+ *
+ * Find a member DIE called @name in @st_die.
+ */
+Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
+			   Dwarf_Die *die_mem)
+{
+	return die_find_child(st_die, __die_find_member_cb, (void *)name,
+			      die_mem);
+}
+
+/**
+ * die_get_typename - Get the name of given variable DIE
+ * @vr_die: a variable DIE
+ * @buf: a buffer for result type name
+ * @len: a max-length of @buf
+ *
+ * Get the name of @vr_die and stores it to @buf. Return the actual length
+ * of type name if succeeded. Return -E2BIG if @len is not enough long, and
+ * Return -ENOENT if failed to find type name.
+ * Note that the result will stores typedef name if possible, and stores
+ * "*(function_type)" if the type is a function pointer.
+ */
+int die_get_typename(Dwarf_Die *vr_die, char *buf, int len)
+{
+	Dwarf_Die type;
+	int tag, ret, ret2;
+	const char *tmp = "";
+
+	if (__die_get_real_type(vr_die, &type) == NULL)
+		return -ENOENT;
+
+	tag = dwarf_tag(&type);
+	if (tag == DW_TAG_array_type || tag == DW_TAG_pointer_type)
+		tmp = "*";
+	else if (tag == DW_TAG_subroutine_type) {
+		/* Function pointer */
+		ret = snprintf(buf, len, "(function_type)");
+		return (ret >= len) ? -E2BIG : ret;
+	} else {
+		if (!dwarf_diename(&type))
+			return -ENOENT;
+		if (tag == DW_TAG_union_type)
+			tmp = "union ";
+		else if (tag == DW_TAG_structure_type)
+			tmp = "struct ";
+		/* Write a base name */
+		ret = snprintf(buf, len, "%s%s", tmp, dwarf_diename(&type));
+		return (ret >= len) ? -E2BIG : ret;
+	}
+	ret = die_get_typename(&type, buf, len);
+	if (ret > 0) {
+		ret2 = snprintf(buf + ret, len - ret, "%s", tmp);
+		ret = (ret2 >= len - ret) ? -E2BIG : ret2 + ret;
+	}
+	return ret;
+}
+
+/**
+ * die_get_varname - Get the name and type of given variable DIE
+ * @vr_die: a variable DIE
+ * @buf: a buffer for type and variable name
+ * @len: the max-length of @buf
+ *
+ * Get the name and type of @vr_die and stores it in @buf as "type\tname".
+ */
+int die_get_varname(Dwarf_Die *vr_die, char *buf, int len)
+{
+	int ret, ret2;
+
+	ret = die_get_typename(vr_die, buf, len);
+	if (ret < 0) {
+		pr_debug("Failed to get type, make it unknown.\n");
+		ret = snprintf(buf, len, "(unknown_type)");
+	}
+	if (ret > 0) {
+		ret2 = snprintf(buf + ret, len - ret, "\t%s",
+				dwarf_diename(vr_die));
+		ret = (ret2 >= len - ret) ? -E2BIG : ret2 + ret;
+	}
+	return ret;
+}
+
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
new file mode 100644
index 0000000..bc3b211
--- /dev/null
+++ b/tools/perf/util/dwarf-aux.h
@@ -0,0 +1,100 @@
+#ifndef _DWARF_AUX_H
+#define _DWARF_AUX_H
+/*
+ * dwarf-aux.h : libdw auxiliary interfaces
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+
+#include <dwarf.h>
+#include <elfutils/libdw.h>
+#include <elfutils/libdwfl.h>
+#include <elfutils/version.h>
+
+/* Find the realpath of the target file */
+extern const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname);
+
+/* Get DW_AT_comp_dir (should be NULL with older gcc) */
+extern const char *cu_get_comp_dir(Dwarf_Die *cu_die);
+
+/* Get a line number and file name for given address */
+extern int cu_find_lineinfo(Dwarf_Die *cudie, unsigned long addr,
+			    const char **fname, int *lineno);
+
+/* Compare diename and tname */
+extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
+
+/* Get callsite line number of inline-function instance */
+extern int die_get_call_lineno(Dwarf_Die *in_die);
+
+/* Get type die */
+extern Dwarf_Die *die_get_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem);
+
+/* Get a type die, but skip qualifiers and typedef */
+extern Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem);
+
+/* Check whether the DIE is signed or not */
+extern bool die_is_signed_type(Dwarf_Die *tp_die);
+
+/* Get data_member_location offset */
+extern int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs);
+
+/* Return values for die_find_child() callbacks */
+enum {
+	DIE_FIND_CB_END = 0,		/* End of Search */
+	DIE_FIND_CB_CHILD = 1,		/* Search only children */
+	DIE_FIND_CB_SIBLING = 2,	/* Search only siblings */
+	DIE_FIND_CB_CONTINUE = 3,	/* Search children and siblings */
+};
+
+/* Search child DIEs */
+extern Dwarf_Die *die_find_child(Dwarf_Die *rt_die,
+				 int (*callback)(Dwarf_Die *, void *),
+				 void *data, Dwarf_Die *die_mem);
+
+/* Search a non-inlined function including given address */
+extern Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
+				    Dwarf_Die *die_mem);
+
+/* Search an inlined function including given address */
+extern Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+				      Dwarf_Die *die_mem);
+
+/* Walker on lines (Note: line number will not be sorted) */
+typedef int (* line_walk_callback_t) (const char *fname, int lineno,
+				      Dwarf_Addr addr, void *data);
+
+/*
+ * Walk on lines inside given DIE. If the DIE is a subprogram, walk only on
+ * the lines inside the subprogram, otherwise the DIE must be a CU DIE.
+ */
+extern int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback,
+			  void *data);
+
+/* Find a variable called 'name' at given address */
+extern Dwarf_Die *die_find_variable_at(Dwarf_Die *sp_die, const char *name,
+				       Dwarf_Addr addr, Dwarf_Die *die_mem);
+
+/* Find a member called 'name' */
+extern Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
+				  Dwarf_Die *die_mem);
+
+/* Get the name of given variable DIE */
+extern int die_get_typename(Dwarf_Die *vr_die, char *buf, int len);
+
+/* Get the name and type of given variable DIE, stored as "type\tname" */
+extern int die_get_varname(Dwarf_Die *vr_die, char *buf, int len);
+#endif
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0239eb8..a03a36b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -377,6 +377,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		array++;
 	}
 
+	data->addr = 0;
 	if (type & PERF_SAMPLE_ADDR) {
 		data->addr = *array;
 		array++;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7e9366e..e9a3155 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -61,6 +61,7 @@ struct perf_evsel {
 		off_t		id_offset;
 	};
 	struct cgroup_sel	*cgrp;
+	bool 			supported;
 };
 
 struct cpu_map;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index afb0849..cb2959a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -877,9 +877,12 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		struct perf_evsel *evsel;
 		off_t tmp;
 
-		if (perf_header__getbuffer64(header, fd, &f_attr, sizeof(f_attr)))
+		if (readn(fd, &f_attr, sizeof(f_attr)) <= 0)
 			goto out_errno;
 
+		if (header->needs_swap)
+			perf_event__attr_swap(&f_attr.attr);
+
 		tmp = lseek(fd, 0, SEEK_CUR);
 		evsel = perf_evsel__new(&f_attr.attr, i);
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 627a02e..677e1da 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -14,7 +14,8 @@ enum hist_filter {
 
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
-	.min_percent = 0.5
+	.min_percent = 0.5,
+	.order  = ORDER_CALLEE
 };
 
 u16 hists__col_len(struct hists *self, enum hist_column col)
@@ -846,6 +847,9 @@ print_entries:
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
+		if (h->filtered)
+			continue;
+
 		if (show_displacement) {
 			if (h->pair != NULL)
 				displacement = ((long)h->pair->position -
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..4ea7e19 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -86,22 +86,24 @@ static const char *sw_event_names[PERF_COUNT_SW_MAX] = {
 
 #define MAX_ALIASES 8
 
-static const char *hw_cache[][MAX_ALIASES] = {
+static const char *hw_cache[PERF_COUNT_HW_CACHE_MAX][MAX_ALIASES] = {
  { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
  { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
- { "LLC",	"L2"							},
+ { "LLC",	"L2",							},
  { "dTLB",	"d-tlb",	"Data-TLB",				},
  { "iTLB",	"i-tlb",	"Instruction-TLB",			},
  { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
+ { "node",								},
 };
 
-static const char *hw_cache_op[][MAX_ALIASES] = {
+static const char *hw_cache_op[PERF_COUNT_HW_CACHE_OP_MAX][MAX_ALIASES] = {
  { "load",	"loads",	"read",					},
  { "store",	"stores",	"write",				},
  { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
 };
 
-static const char *hw_cache_result[][MAX_ALIASES] = {
+static const char *hw_cache_result[PERF_COUNT_HW_CACHE_RESULT_MAX]
+				  [MAX_ALIASES] = {
  { "refs",	"Reference",	"ops",		"access",		},
  { "misses",	"miss",							},
 };
@@ -124,6 +126,7 @@ static unsigned long hw_cache_stat[C(MAX)] = {
  [C(DTLB)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
  [C(ITLB)]	= (CACHE_READ),
  [C(BPU)]	= (CACHE_READ),
+ [C(NODE)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
 };
 
 #define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
@@ -393,7 +396,7 @@ parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
 						PERF_COUNT_HW_CACHE_OP_MAX);
 			if (cache_op >= 0) {
 				if (!is_cache_op_valid(cache_type, cache_op))
-					return 0;
+					return EVT_FAILED;
 				continue;
 			}
 		}
@@ -475,7 +478,7 @@ parse_single_tracepoint_event(char *sys_name,
 /* sys + ':' + event + ':' + flags*/
 #define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
 static enum event_result
-parse_multiple_tracepoint_event(const struct option *opt, char *sys_name,
+parse_multiple_tracepoint_event(struct perf_evlist *evlist, char *sys_name,
 				const char *evt_exp, char *flags)
 {
 	char evt_path[MAXPATHLEN];
@@ -509,7 +512,7 @@ parse_multiple_tracepoint_event(const struct option *opt, char *sys_name,
 		if (len < 0)
 			return EVT_FAILED;
 
-		if (parse_events(opt, event_opt, 0))
+		if (parse_events(evlist, event_opt, 0))
 			return EVT_FAILED;
 	}
 
@@ -517,7 +520,7 @@ parse_multiple_tracepoint_event(const struct option *opt, char *sys_name,
 }
 
 static enum event_result
-parse_tracepoint_event(const struct option *opt, const char **strp,
+parse_tracepoint_event(struct perf_evlist *evlist, const char **strp,
 		       struct perf_event_attr *attr)
 {
 	const char *evt_name;
@@ -557,8 +560,8 @@ parse_tracepoint_event(const struct option *opt, const char **strp,
 		return EVT_FAILED;
 	if (strpbrk(evt_name, "*?")) {
 		*strp += strlen(sys_name) + evt_length + 1; /* 1 == the ':' */
-		return parse_multiple_tracepoint_event(opt, sys_name, evt_name,
-						       flags);
+		return parse_multiple_tracepoint_event(evlist, sys_name,
+						       evt_name, flags);
 	} else {
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, attr, strp);
@@ -778,12 +781,12 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
  * Symbolic names are (almost) exactly matched.
  */
 static enum event_result
-parse_event_symbols(const struct option *opt, const char **str,
+parse_event_symbols(struct perf_evlist *evlist, const char **str,
 		    struct perf_event_attr *attr)
 {
 	enum event_result ret;
 
-	ret = parse_tracepoint_event(opt, str, attr);
+	ret = parse_tracepoint_event(evlist, str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
 
@@ -822,9 +825,8 @@ modifier:
 	return ret;
 }
 
-int parse_events(const struct option *opt, const char *str, int unset __used)
+int parse_events(struct perf_evlist *evlist , const char *str, int unset __used)
 {
-	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
 	struct perf_event_attr attr;
 	enum event_result ret;
 	const char *ostr;
@@ -832,7 +834,7 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 	for (;;) {
 		ostr = str;
 		memset(&attr, 0, sizeof(attr));
-		ret = parse_event_symbols(opt, &str, &attr);
+		ret = parse_event_symbols(evlist, &str, &attr);
 		if (ret == EVT_FAILED)
 			return -1;
 
@@ -863,6 +865,13 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 	return 0;
 }
 
+int parse_events_option(const struct option *opt, const char *str,
+			int unset __used)
+{
+	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
+	return parse_events(evlist, str, unset);
+}
+
 int parse_filter(const struct option *opt, const char *str,
 		 int unset __used)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 746d3fc..2f8e375 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -8,6 +8,7 @@
 
 struct list_head;
 struct perf_evsel;
+struct perf_evlist;
 
 struct option;
 
@@ -24,7 +25,10 @@ const char *event_type(int type);
 const char *event_name(struct perf_evsel *event);
 extern const char *__event_name(int type, u64 config);
 
-extern int parse_events(const struct option *opt, const char *str, int unset);
+extern int parse_events_option(const struct option *opt, const char *str,
+			       int unset);
+extern int parse_events(struct perf_evlist *evlist, const char *str,
+			int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f022316..b82d54f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -117,6 +117,10 @@ static struct map *kernel_get_module_map(const char *module)
 	struct rb_node *nd;
 	struct map_groups *grp = &machine.kmaps;
 
+	/* A file path -- this is an offline module */
+	if (module && strchr(module, '/'))
+		return machine__new_module(&machine, 0, module);
+
 	if (!module)
 		module = "kernel";
 
@@ -170,16 +174,24 @@ const char *kernel_get_module_path(const char *module)
 }
 
 #ifdef DWARF_SUPPORT
-static int open_vmlinux(const char *module)
+/* Open new debuginfo of given module */
+static struct debuginfo *open_debuginfo(const char *module)
 {
-	const char *path = kernel_get_module_path(module);
-	if (!path) {
-		pr_err("Failed to find path of %s module.\n",
-		       module ?: "kernel");
-		return -ENOENT;
+	const char *path;
+
+	/* A file path -- this is an offline module */
+	if (module && strchr(module, '/'))
+		path = module;
+	else {
+		path = kernel_get_module_path(module);
+
+		if (!path) {
+			pr_err("Failed to find path of %s module.\n",
+			       module ?: "kernel");
+			return NULL;
+		}
 	}
-	pr_debug("Try to open %s\n", path);
-	return open(path, O_RDONLY);
+	return debuginfo__new(path);
 }
 
 /*
@@ -193,13 +205,24 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 	struct map *map;
 	u64 addr;
 	int ret = -ENOENT;
+	struct debuginfo *dinfo;
 
 	sym = __find_kernel_function_by_name(tp->symbol, &map);
 	if (sym) {
 		addr = map->unmap_ip(map, sym->start + tp->offset);
 		pr_debug("try to find %s+%ld@%" PRIx64 "\n", tp->symbol,
 			 tp->offset, addr);
-		ret = find_perf_probe_point((unsigned long)addr, pp);
+
+		dinfo = debuginfo__new_online_kernel(addr);
+		if (dinfo) {
+			ret = debuginfo__find_probe_point(dinfo,
+						 (unsigned long)addr, pp);
+			debuginfo__delete(dinfo);
+		} else {
+			pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n",
+				 addr);
+			ret = -ENOENT;
+		}
 	}
 	if (ret <= 0) {
 		pr_debug("Failed to find corresponding probes from "
@@ -214,30 +237,70 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 	return 0;
 }
 
+static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
+					    int ntevs, const char *module)
+{
+	int i, ret = 0;
+	char *tmp;
+
+	if (!module)
+		return 0;
+
+	tmp = strrchr(module, '/');
+	if (tmp) {
+		/* This is a module path -- get the module name */
+		module = strdup(tmp + 1);
+		if (!module)
+			return -ENOMEM;
+		tmp = strchr(module, '.');
+		if (tmp)
+			*tmp = '\0';
+		tmp = (char *)module;	/* For free() */
+	}
+
+	for (i = 0; i < ntevs; i++) {
+		tevs[i].point.module = strdup(module);
+		if (!tevs[i].point.module) {
+			ret = -ENOMEM;
+			break;
+		}
+	}
+
+	if (tmp)
+		free(tmp);
+
+	return ret;
+}
+
 /* Try to find perf_probe_event with debuginfo */
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
-					   struct probe_trace_event **tevs,
-					   int max_tevs, const char *module)
+					  struct probe_trace_event **tevs,
+					  int max_tevs, const char *module)
 {
 	bool need_dwarf = perf_probe_event_need_dwarf(pev);
-	int fd, ntevs;
+	struct debuginfo *dinfo = open_debuginfo(module);
+	int ntevs, ret = 0;
 
-	fd = open_vmlinux(module);
-	if (fd < 0) {
+	if (!dinfo) {
 		if (need_dwarf) {
 			pr_warning("Failed to open debuginfo file.\n");
-			return fd;
+			return -ENOENT;
 		}
-		pr_debug("Could not open vmlinux. Try to use symbols.\n");
+		pr_debug("Could not open debuginfo. Try to use symbols.\n");
 		return 0;
 	}
 
-	/* Searching trace events corresponding to probe event */
-	ntevs = find_probe_trace_events(fd, pev, tevs, max_tevs);
+	/* Searching trace events corresponding to a probe event */
+	ntevs = debuginfo__find_trace_events(dinfo, pev, tevs, max_tevs);
+
+	debuginfo__delete(dinfo);
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
 		pr_debug("find %d probe_trace_events.\n", ntevs);
-		return ntevs;
+		if (module)
+			ret = add_module_to_probe_trace_events(*tevs, ntevs,
+							       module);
+		return ret < 0 ? ret : ntevs;
 	}
 
 	if (ntevs == 0)	{	/* No error but failed to find probe point. */
@@ -371,8 +434,9 @@ int show_line_range(struct line_range *lr, const char *module)
 {
 	int l = 1;
 	struct line_node *ln;
+	struct debuginfo *dinfo;
 	FILE *fp;
-	int fd, ret;
+	int ret;
 	char *tmp;
 
 	/* Search a line range */
@@ -380,13 +444,14 @@ int show_line_range(struct line_range *lr, const char *module)
 	if (ret < 0)
 		return ret;
 
-	fd = open_vmlinux(module);
-	if (fd < 0) {
+	dinfo = open_debuginfo(module);
+	if (!dinfo) {
 		pr_warning("Failed to open debuginfo file.\n");
-		return fd;
+		return -ENOENT;
 	}
 
-	ret = find_line_range(fd, lr);
+	ret = debuginfo__find_line_range(dinfo, lr);
+	debuginfo__delete(dinfo);
 	if (ret == 0) {
 		pr_warning("Specified source line is not found.\n");
 		return -ENOENT;
@@ -448,7 +513,8 @@ end:
 	return ret;
 }
 
-static int show_available_vars_at(int fd, struct perf_probe_event *pev,
+static int show_available_vars_at(struct debuginfo *dinfo,
+				  struct perf_probe_event *pev,
 				  int max_vls, struct strfilter *_filter,
 				  bool externs)
 {
@@ -463,7 +529,8 @@ static int show_available_vars_at(int fd, struct perf_probe_event *pev,
 		return -EINVAL;
 	pr_debug("Searching variables at %s\n", buf);
 
-	ret = find_available_vars_at(fd, pev, &vls, max_vls, externs);
+	ret = debuginfo__find_available_vars_at(dinfo, pev, &vls,
+						max_vls, externs);
 	if (ret <= 0) {
 		pr_err("Failed to find variables at %s (%d)\n", buf, ret);
 		goto end;
@@ -504,24 +571,26 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			int max_vls, const char *module,
 			struct strfilter *_filter, bool externs)
 {
-	int i, fd, ret = 0;
+	int i, ret = 0;
+	struct debuginfo *dinfo;
 
 	ret = init_vmlinux();
 	if (ret < 0)
 		return ret;
 
+	dinfo = open_debuginfo(module);
+	if (!dinfo) {
+		pr_warning("Failed to open debuginfo file.\n");
+		return -ENOENT;
+	}
+
 	setup_pager();
 
-	for (i = 0; i < npevs && ret >= 0; i++) {
-		fd = open_vmlinux(module);
-		if (fd < 0) {
-			pr_warning("Failed to open debug information file.\n");
-			ret = fd;
-			break;
-		}
-		ret = show_available_vars_at(fd, &pevs[i], max_vls, _filter,
+	for (i = 0; i < npevs && ret >= 0; i++)
+		ret = show_available_vars_at(dinfo, &pevs[i], max_vls, _filter,
 					     externs);
-	}
+
+	debuginfo__delete(dinfo);
 	return ret;
 }
 
@@ -990,7 +1059,7 @@ bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
 
 /* Parse probe_events event into struct probe_point */
 static int parse_probe_trace_command(const char *cmd,
-					struct probe_trace_event *tev)
+				     struct probe_trace_event *tev)
 {
 	struct probe_trace_point *tp = &tev->point;
 	char pr;
@@ -1023,8 +1092,14 @@ static int parse_probe_trace_command(const char *cmd,
 
 	tp->retprobe = (pr == 'r');
 
-	/* Scan function name and offset */
-	ret = sscanf(argv[1], "%a[^+]+%lu", (float *)(void *)&tp->symbol,
+	/* Scan module name(if there), function name and offset */
+	p = strchr(argv[1], ':');
+	if (p) {
+		tp->module = strndup(argv[1], p - argv[1]);
+		p++;
+	} else
+		p = argv[1];
+	ret = sscanf(p, "%a[^+]+%lu", (float *)(void *)&tp->symbol,
 		     &tp->offset);
 	if (ret == 1)
 		tp->offset = 0;
@@ -1269,9 +1344,10 @@ char *synthesize_probe_trace_command(struct probe_trace_event *tev)
 	if (buf == NULL)
 		return NULL;
 
-	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s+%lu",
+	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s%s%s+%lu",
 			 tp->retprobe ? 'r' : 'p',
 			 tev->group, tev->event,
+			 tp->module ?: "", tp->module ? ":" : "",
 			 tp->symbol, tp->offset);
 	if (len <= 0)
 		goto error;
@@ -1378,6 +1454,8 @@ static void clear_probe_trace_event(struct probe_trace_event *tev)
 		free(tev->group);
 	if (tev->point.symbol)
 		free(tev->point.symbol);
+	if (tev->point.module)
+		free(tev->point.module);
 	for (i = 0; i < tev->nargs; i++) {
 		if (tev->args[i].name)
 			free(tev->args[i].name);
@@ -1729,7 +1807,7 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 	/* Convert perf_probe_event with debuginfo */
 	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, module);
 	if (ret != 0)
-		return ret;
+		return ret;	/* Found in debuginfo or got an error */
 
 	/* Allocate trace event buffer */
 	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
@@ -1742,6 +1820,11 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		ret = -ENOMEM;
 		goto error;
 	}
+	tev->point.module = strdup(module);
+	if (tev->point.module == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
 	tev->point.offset = pev->point.offset;
 	tev->point.retprobe = pev->point.retprobe;
 	tev->nargs = pev->nargs;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 3434fc9..a7dee83 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -10,6 +10,7 @@ extern bool probe_event_dry_run;
 /* kprobe-tracer tracing point */
 struct probe_trace_point {
 	char		*symbol;	/* Base symbol */
+	char		*module;	/* Module name */
 	unsigned long	offset;		/* Offset from symbol */
 	bool		retprobe;	/* Return probe flag */
 };
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3b9d0b8..3e44a3e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -43,21 +43,6 @@
 /* Kprobe tracer basic type is up to u64 */
 #define MAX_BASIC_TYPE_BITS	64
 
-/*
- * Compare the tail of two strings.
- * Return 0 if whole of either string is same as another's tail part.
- */
-static int strtailcmp(const char *s1, const char *s2)
-{
-	int i1 = strlen(s1);
-	int i2 = strlen(s2);
-	while (--i1 >= 0 && --i2 >= 0) {
-		if (s1[i1] != s2[i2])
-			return s1[i1] - s2[i2];
-	}
-	return 0;
-}
-
 /* Line number list operations */
 
 /* Add a line to line number list */
@@ -131,29 +116,37 @@ static const Dwfl_Callbacks offline_callbacks = {
 };
 
 /* Get a Dwarf from offline image */
-static Dwarf *dwfl_init_offline_dwarf(int fd, Dwfl **dwflp, Dwarf_Addr *bias)
+static int debuginfo__init_offline_dwarf(struct debuginfo *self,
+					 const char *path)
 {
 	Dwfl_Module *mod;
-	Dwarf *dbg = NULL;
+	int fd;
 
-	if (!dwflp)
-		return NULL;
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return fd;
 
-	*dwflp = dwfl_begin(&offline_callbacks);
-	if (!*dwflp)
-		return NULL;
+	self->dwfl = dwfl_begin(&offline_callbacks);
+	if (!self->dwfl)
+		goto error;
 
-	mod = dwfl_report_offline(*dwflp, "", "", fd);
+	mod = dwfl_report_offline(self->dwfl, "", "", fd);
 	if (!mod)
 		goto error;
 
-	dbg = dwfl_module_getdwarf(mod, bias);
-	if (!dbg) {
+	self->dbg = dwfl_module_getdwarf(mod, &self->bias);
+	if (!self->dbg)
+		goto error;
+
+	return 0;
 error:
-		dwfl_end(*dwflp);
-		*dwflp = NULL;
-	}
-	return dbg;
+	if (self->dwfl)
+		dwfl_end(self->dwfl);
+	else
+		close(fd);
+	memset(self, 0, sizeof(*self));
+
+	return -ENOENT;
 }
 
 #if _ELFUTILS_PREREQ(0, 148)
@@ -189,597 +182,81 @@ static const Dwfl_Callbacks kernel_callbacks = {
 };
 
 /* Get a Dwarf from live kernel image */
-static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr, Dwfl **dwflp,
-					  Dwarf_Addr *bias)
+static int debuginfo__init_online_kernel_dwarf(struct debuginfo *self,
+					       Dwarf_Addr addr)
 {
-	Dwarf *dbg;
-
-	if (!dwflp)
-		return NULL;
-
-	*dwflp = dwfl_begin(&kernel_callbacks);
-	if (!*dwflp)
-		return NULL;
+	self->dwfl = dwfl_begin(&kernel_callbacks);
+	if (!self->dwfl)
+		return -EINVAL;
 
 	/* Load the kernel dwarves: Don't care the result here */
-	dwfl_linux_kernel_report_kernel(*dwflp);
-	dwfl_linux_kernel_report_modules(*dwflp);
+	dwfl_linux_kernel_report_kernel(self->dwfl);
+	dwfl_linux_kernel_report_modules(self->dwfl);
 
-	dbg = dwfl_addrdwarf(*dwflp, addr, bias);
+	self->dbg = dwfl_addrdwarf(self->dwfl, addr, &self->bias);
 	/* Here, check whether we could get a real dwarf */
-	if (!dbg) {
+	if (!self->dbg) {
 		pr_debug("Failed to find kernel dwarf at %lx\n",
 			 (unsigned long)addr);
-		dwfl_end(*dwflp);
-		*dwflp = NULL;
+		dwfl_end(self->dwfl);
+		memset(self, 0, sizeof(*self));
+		return -ENOENT;
 	}
-	return dbg;
+
+	return 0;
 }
 #else
 /* With older elfutils, this just support kernel module... */
-static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr __used, Dwfl **dwflp,
-					  Dwarf_Addr *bias)
+static int debuginfo__init_online_kernel_dwarf(struct debuginfo *self,
+					       Dwarf_Addr addr __used)
 {
-	int fd;
 	const char *path = kernel_get_module_path("kernel");
 
 	if (!path) {
 		pr_err("Failed to find vmlinux path\n");
-		return NULL;
+		return -ENOENT;
 	}
 
 	pr_debug2("Use file %s for debuginfo\n", path);
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		return NULL;
-
-	return dwfl_init_offline_dwarf(fd, dwflp, bias);
+	return debuginfo__init_offline_dwarf(self, path);
 }
 #endif
 
-/* Dwarf wrappers */
-
-/* Find the realpath of the target file. */
-static const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname)
-{
-	Dwarf_Files *files;
-	size_t nfiles, i;
-	const char *src = NULL;
-	int ret;
-
-	if (!fname)
-		return NULL;
-
-	ret = dwarf_getsrcfiles(cu_die, &files, &nfiles);
-	if (ret != 0)
-		return NULL;
-
-	for (i = 0; i < nfiles; i++) {
-		src = dwarf_filesrc(files, i, NULL, NULL);
-		if (strtailcmp(src, fname) == 0)
-			break;
-	}
-	if (i == nfiles)
-		return NULL;
-	return src;
-}
-
-/* Get DW_AT_comp_dir (should be NULL with older gcc) */
-static const char *cu_get_comp_dir(Dwarf_Die *cu_die)
-{
-	Dwarf_Attribute attr;
-	if (dwarf_attr(cu_die, DW_AT_comp_dir, &attr) == NULL)
-		return NULL;
-	return dwarf_formstring(&attr);
-}
-
-/* Get a line number and file name for given address */
-static int cu_find_lineinfo(Dwarf_Die *cudie, unsigned long addr,
-			    const char **fname, int *lineno)
-{
-	Dwarf_Line *line;
-	Dwarf_Addr laddr;
-
-	line = dwarf_getsrc_die(cudie, (Dwarf_Addr)addr);
-	if (line && dwarf_lineaddr(line, &laddr) == 0 &&
-	    addr == (unsigned long)laddr && dwarf_lineno(line, lineno) == 0) {
-		*fname = dwarf_linesrc(line, NULL, NULL);
-		if (!*fname)
-			/* line number is useless without filename */
-			*lineno = 0;
-	}
-
-	return *lineno ?: -ENOENT;
-}
-
-/* Compare diename and tname */
-static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
-{
-	const char *name;
-	name = dwarf_diename(dw_die);
-	return name ? (strcmp(tname, name) == 0) : false;
-}
-
-/* Get callsite line number of inline-function instance */
-static int die_get_call_lineno(Dwarf_Die *in_die)
-{
-	Dwarf_Attribute attr;
-	Dwarf_Word ret;
-
-	if (!dwarf_attr(in_die, DW_AT_call_line, &attr))
-		return -ENOENT;
-
-	dwarf_formudata(&attr, &ret);
-	return (int)ret;
-}
-
-/* Get type die */
-static Dwarf_Die *die_get_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
-{
-	Dwarf_Attribute attr;
-
-	if (dwarf_attr_integrate(vr_die, DW_AT_type, &attr) &&
-	    dwarf_formref_die(&attr, die_mem))
-		return die_mem;
-	else
-		return NULL;
-}
-
-/* Get a type die, but skip qualifiers */
-static Dwarf_Die *__die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
-{
-	int tag;
-
-	do {
-		vr_die = die_get_type(vr_die, die_mem);
-		if (!vr_die)
-			break;
-		tag = dwarf_tag(vr_die);
-	} while (tag == DW_TAG_const_type ||
-		 tag == DW_TAG_restrict_type ||
-		 tag == DW_TAG_volatile_type ||
-		 tag == DW_TAG_shared_type);
-
-	return vr_die;
-}
-
-/* Get a type die, but skip qualifiers and typedef */
-static Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
-{
-	do {
-		vr_die = __die_get_real_type(vr_die, die_mem);
-	} while (vr_die && dwarf_tag(vr_die) == DW_TAG_typedef);
-
-	return vr_die;
-}
-
-static int die_get_attr_udata(Dwarf_Die *tp_die, unsigned int attr_name,
-			      Dwarf_Word *result)
-{
-	Dwarf_Attribute attr;
-
-	if (dwarf_attr(tp_die, attr_name, &attr) == NULL ||
-	    dwarf_formudata(&attr, result) != 0)
-		return -ENOENT;
-
-	return 0;
-}
-
-static bool die_is_signed_type(Dwarf_Die *tp_die)
-{
-	Dwarf_Word ret;
-
-	if (die_get_attr_udata(tp_die, DW_AT_encoding, &ret))
-		return false;
-
-	return (ret == DW_ATE_signed_char || ret == DW_ATE_signed ||
-		ret == DW_ATE_signed_fixed);
-}
-
-static int die_get_byte_size(Dwarf_Die *tp_die)
-{
-	Dwarf_Word ret;
-
-	if (die_get_attr_udata(tp_die, DW_AT_byte_size, &ret))
-		return 0;
-
-	return (int)ret;
-}
-
-static int die_get_bit_size(Dwarf_Die *tp_die)
-{
-	Dwarf_Word ret;
-
-	if (die_get_attr_udata(tp_die, DW_AT_bit_size, &ret))
-		return 0;
-
-	return (int)ret;
-}
-
-static int die_get_bit_offset(Dwarf_Die *tp_die)
-{
-	Dwarf_Word ret;
-
-	if (die_get_attr_udata(tp_die, DW_AT_bit_offset, &ret))
-		return 0;
-
-	return (int)ret;
-}
-
-/* Get data_member_location offset */
-static int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
-{
-	Dwarf_Attribute attr;
-	Dwarf_Op *expr;
-	size_t nexpr;
-	int ret;
-
-	if (dwarf_attr(mb_die, DW_AT_data_member_location, &attr) == NULL)
-		return -ENOENT;
-
-	if (dwarf_formudata(&attr, offs) != 0) {
-		/* DW_AT_data_member_location should be DW_OP_plus_uconst */
-		ret = dwarf_getlocation(&attr, &expr, &nexpr);
-		if (ret < 0 || nexpr == 0)
-			return -ENOENT;
-
-		if (expr[0].atom != DW_OP_plus_uconst || nexpr != 1) {
-			pr_debug("Unable to get offset:Unexpected OP %x (%zd)\n",
-				 expr[0].atom, nexpr);
-			return -ENOTSUP;
-		}
-		*offs = (Dwarf_Word)expr[0].number;
-	}
-	return 0;
-}
-
-/* Return values for die_find callbacks */
-enum {
-	DIE_FIND_CB_FOUND = 0,		/* End of Search */
-	DIE_FIND_CB_CHILD = 1,		/* Search only children */
-	DIE_FIND_CB_SIBLING = 2,	/* Search only siblings */
-	DIE_FIND_CB_CONTINUE = 3,	/* Search children and siblings */
-};
-
-/* Search a child die */
-static Dwarf_Die *die_find_child(Dwarf_Die *rt_die,
-				 int (*callback)(Dwarf_Die *, void *),
-				 void *data, Dwarf_Die *die_mem)
+struct debuginfo *debuginfo__new(const char *path)
 {
-	Dwarf_Die child_die;
-	int ret;
-
-	ret = dwarf_child(rt_die, die_mem);
-	if (ret != 0)
+	struct debuginfo *self = zalloc(sizeof(struct debuginfo));
+	if (!self)
 		return NULL;
 
-	do {
-		ret = callback(die_mem, data);
-		if (ret == DIE_FIND_CB_FOUND)
-			return die_mem;
-
-		if ((ret & DIE_FIND_CB_CHILD) &&
-		    die_find_child(die_mem, callback, data, &child_die)) {
-			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
-			return die_mem;
-		}
-	} while ((ret & DIE_FIND_CB_SIBLING) &&
-		 dwarf_siblingof(die_mem, die_mem) == 0);
-
-	return NULL;
-}
-
-struct __addr_die_search_param {
-	Dwarf_Addr	addr;
-	Dwarf_Die	*die_mem;
-};
-
-static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
-{
-	struct __addr_die_search_param *ad = data;
-
-	if (dwarf_tag(fn_die) == DW_TAG_subprogram &&
-	    dwarf_haspc(fn_die, ad->addr)) {
-		memcpy(ad->die_mem, fn_die, sizeof(Dwarf_Die));
-		return DWARF_CB_ABORT;
+	if (debuginfo__init_offline_dwarf(self, path) < 0) {
+		free(self);
+		self = NULL;
 	}
-	return DWARF_CB_OK;
-}
-
-/* Search a real subprogram including this line, */
-static Dwarf_Die *die_find_real_subprogram(Dwarf_Die *cu_die, Dwarf_Addr addr,
-					   Dwarf_Die *die_mem)
-{
-	struct __addr_die_search_param ad;
-	ad.addr = addr;
-	ad.die_mem = die_mem;
-	/* dwarf_getscopes can't find subprogram. */
-	if (!dwarf_getfuncs(cu_die, __die_search_func_cb, &ad, 0))
-		return NULL;
-	else
-		return die_mem;
-}
-
-/* die_find callback for inline function search */
-static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data)
-{
-	Dwarf_Addr *addr = data;
-
-	if (dwarf_tag(die_mem) == DW_TAG_inlined_subroutine &&
-	    dwarf_haspc(die_mem, *addr))
-		return DIE_FIND_CB_FOUND;
 
-	return DIE_FIND_CB_CONTINUE;
+	return self;
 }
 
-/* Similar to dwarf_getfuncs, but returns inlined_subroutine if exists. */
-static Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
-				      Dwarf_Die *die_mem)
+struct debuginfo *debuginfo__new_online_kernel(unsigned long addr)
 {
-	Dwarf_Die tmp_die;
-
-	sp_die = die_find_child(sp_die, __die_find_inline_cb, &addr, &tmp_die);
-	if (!sp_die)
+	struct debuginfo *self = zalloc(sizeof(struct debuginfo));
+	if (!self)
 		return NULL;
 
-	/* Inlined function could be recursive. Trace it until fail */
-	while (sp_die) {
-		memcpy(die_mem, sp_die, sizeof(Dwarf_Die));
-		sp_die = die_find_child(sp_die, __die_find_inline_cb, &addr,
-					&tmp_die);
-	}
-
-	return die_mem;
-}
-
-/* Walker on lines (Note: line number will not be sorted) */
-typedef int (* line_walk_handler_t) (const char *fname, int lineno,
-				     Dwarf_Addr addr, void *data);
-
-struct __line_walk_param {
-	const char *fname;
-	line_walk_handler_t handler;
-	void *data;
-	int retval;
-};
-
-static int __die_walk_funclines_cb(Dwarf_Die *in_die, void *data)
-{
-	struct __line_walk_param *lw = data;
-	Dwarf_Addr addr;
-	int lineno;
-
-	if (dwarf_tag(in_die) == DW_TAG_inlined_subroutine) {
-		lineno = die_get_call_lineno(in_die);
-		if (lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
-			lw->retval = lw->handler(lw->fname, lineno, addr,
-						 lw->data);
-			if (lw->retval != 0)
-				return DIE_FIND_CB_FOUND;
-		}
-	}
-	return DIE_FIND_CB_SIBLING;
-}
-
-/* Walk on lines of blocks included in given DIE */
-static int __die_walk_funclines(Dwarf_Die *sp_die,
-				line_walk_handler_t handler, void *data)
-{
-	struct __line_walk_param lw = {
-		.handler = handler,
-		.data = data,
-		.retval = 0,
-	};
-	Dwarf_Die die_mem;
-	Dwarf_Addr addr;
-	int lineno;
-
-	/* Handle function declaration line */
-	lw.fname = dwarf_decl_file(sp_die);
-	if (lw.fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
-	    dwarf_entrypc(sp_die, &addr) == 0) {
-		lw.retval = handler(lw.fname, lineno, addr, data);
-		if (lw.retval != 0)
-			goto done;
-	}
-	die_find_child(sp_die, __die_walk_funclines_cb, &lw, &die_mem);
-done:
-	return lw.retval;
-}
-
-static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
-{
-	struct __line_walk_param *lw = data;
-
-	lw->retval = __die_walk_funclines(sp_die, lw->handler, lw->data);
-	if (lw->retval != 0)
-		return DWARF_CB_ABORT;
-
-	return DWARF_CB_OK;
-}
-
-/*
- * Walk on lines inside given PDIE. If the PDIE is subprogram, walk only on
- * the lines inside the subprogram, otherwise PDIE must be a CU DIE.
- */
-static int die_walk_lines(Dwarf_Die *pdie, line_walk_handler_t handler,
-			  void *data)
-{
-	Dwarf_Lines *lines;
-	Dwarf_Line *line;
-	Dwarf_Addr addr;
-	const char *fname;
-	int lineno, ret = 0;
-	Dwarf_Die die_mem, *cu_die;
-	size_t nlines, i;
-
-	/* Get the CU die */
-	if (dwarf_tag(pdie) == DW_TAG_subprogram)
-		cu_die = dwarf_diecu(pdie, &die_mem, NULL, NULL);
-	else
-		cu_die = pdie;
-	if (!cu_die) {
-		pr_debug2("Failed to get CU from subprogram\n");
-		return -EINVAL;
-	}
-
-	/* Get lines list in the CU */
-	if (dwarf_getsrclines(cu_die, &lines, &nlines) != 0) {
-		pr_debug2("Failed to get source lines on this CU.\n");
-		return -ENOENT;
-	}
-	pr_debug2("Get %zd lines from this CU\n", nlines);
-
-	/* Walk on the lines on lines list */
-	for (i = 0; i < nlines; i++) {
-		line = dwarf_onesrcline(lines, i);
-		if (line == NULL ||
-		    dwarf_lineno(line, &lineno) != 0 ||
-		    dwarf_lineaddr(line, &addr) != 0) {
-			pr_debug2("Failed to get line info. "
-				  "Possible error in debuginfo.\n");
-			continue;
-		}
-		/* Filter lines based on address */
-		if (pdie != cu_die)
-			/*
-			 * Address filtering
-			 * The line is included in given function, and
-			 * no inline block includes it.
-			 */
-			if (!dwarf_haspc(pdie, addr) ||
-			    die_find_inlinefunc(pdie, addr, &die_mem))
-				continue;
-		/* Get source line */
-		fname = dwarf_linesrc(line, NULL, NULL);
-
-		ret = handler(fname, lineno, addr, data);
-		if (ret != 0)
-			return ret;
-	}
-
-	/*
-	 * Dwarf lines doesn't include function declarations and inlined
-	 * subroutines. We have to check functions list or given function.
-	 */
-	if (pdie != cu_die)
-		ret = __die_walk_funclines(pdie, handler, data);
-	else {
-		struct __line_walk_param param = {
-			.handler = handler,
-			.data = data,
-			.retval = 0,
-		};
-		dwarf_getfuncs(cu_die, __die_walk_culines_cb, &param, 0);
-		ret = param.retval;
+	if (debuginfo__init_online_kernel_dwarf(self, (Dwarf_Addr)addr) < 0) {
+		free(self);
+		self = NULL;
 	}
 
-	return ret;
-}
-
-struct __find_variable_param {
-	const char *name;
-	Dwarf_Addr addr;
-};
-
-static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
-{
-	struct __find_variable_param *fvp = data;
-	int tag;
-
-	tag = dwarf_tag(die_mem);
-	if ((tag == DW_TAG_formal_parameter ||
-	     tag == DW_TAG_variable) &&
-	    die_compare_name(die_mem, fvp->name))
-		return DIE_FIND_CB_FOUND;
-
-	if (dwarf_haspc(die_mem, fvp->addr))
-		return DIE_FIND_CB_CONTINUE;
-	else
-		return DIE_FIND_CB_SIBLING;
-}
-
-/* Find a variable called 'name' at given address */
-static Dwarf_Die *die_find_variable_at(Dwarf_Die *sp_die, const char *name,
-				       Dwarf_Addr addr, Dwarf_Die *die_mem)
-{
-	struct __find_variable_param fvp = { .name = name, .addr = addr};
-
-	return die_find_child(sp_die, __die_find_variable_cb, (void *)&fvp,
-			      die_mem);
-}
-
-static int __die_find_member_cb(Dwarf_Die *die_mem, void *data)
-{
-	const char *name = data;
-
-	if ((dwarf_tag(die_mem) == DW_TAG_member) &&
-	    die_compare_name(die_mem, name))
-		return DIE_FIND_CB_FOUND;
-
-	return DIE_FIND_CB_SIBLING;
-}
-
-/* Find a member called 'name' */
-static Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
-				  Dwarf_Die *die_mem)
-{
-	return die_find_child(st_die, __die_find_member_cb, (void *)name,
-			      die_mem);
-}
-
-/* Get the name of given variable DIE */
-static int die_get_typename(Dwarf_Die *vr_die, char *buf, int len)
-{
-	Dwarf_Die type;
-	int tag, ret, ret2;
-	const char *tmp = "";
-
-	if (__die_get_real_type(vr_die, &type) == NULL)
-		return -ENOENT;
-
-	tag = dwarf_tag(&type);
-	if (tag == DW_TAG_array_type || tag == DW_TAG_pointer_type)
-		tmp = "*";
-	else if (tag == DW_TAG_subroutine_type) {
-		/* Function pointer */
-		ret = snprintf(buf, len, "(function_type)");
-		return (ret >= len) ? -E2BIG : ret;
-	} else {
-		if (!dwarf_diename(&type))
-			return -ENOENT;
-		if (tag == DW_TAG_union_type)
-			tmp = "union ";
-		else if (tag == DW_TAG_structure_type)
-			tmp = "struct ";
-		/* Write a base name */
-		ret = snprintf(buf, len, "%s%s", tmp, dwarf_diename(&type));
-		return (ret >= len) ? -E2BIG : ret;
-	}
-	ret = die_get_typename(&type, buf, len);
-	if (ret > 0) {
-		ret2 = snprintf(buf + ret, len - ret, "%s", tmp);
-		ret = (ret2 >= len - ret) ? -E2BIG : ret2 + ret;
-	}
-	return ret;
+	return self;
 }
 
-/* Get the name and type of given variable DIE, stored as "type\tname" */
-static int die_get_varname(Dwarf_Die *vr_die, char *buf, int len)
+void debuginfo__delete(struct debuginfo *self)
 {
-	int ret, ret2;
-
-	ret = die_get_typename(vr_die, buf, len);
-	if (ret < 0) {
-		pr_debug("Failed to get type, make it unknown.\n");
-		ret = snprintf(buf, len, "(unknown_type)");
+	if (self) {
+		if (self->dwfl)
+			dwfl_end(self->dwfl);
+		free(self);
 	}
-	if (ret > 0) {
-		ret2 = snprintf(buf + ret, len - ret, "\t%s",
-				dwarf_diename(vr_die));
-		ret = (ret2 >= len - ret) ? -E2BIG : ret2 + ret;
-	}
-	return ret;
 }
 
 /*
@@ -897,6 +374,7 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 	struct probe_trace_arg_ref **ref_ptr = &tvar->ref;
 	Dwarf_Die type;
 	char buf[16];
+	int bsize, boffs, total;
 	int ret;
 
 	/* TODO: check all types */
@@ -906,11 +384,15 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 		return (tvar->type == NULL) ? -ENOMEM : 0;
 	}
 
-	if (die_get_bit_size(vr_die) != 0) {
+	bsize = dwarf_bitsize(vr_die);
+	if (bsize > 0) {
 		/* This is a bitfield */
-		ret = snprintf(buf, 16, "b%d@%d/%zd", die_get_bit_size(vr_die),
-				die_get_bit_offset(vr_die),
-				BYTES_TO_BITS(die_get_byte_size(vr_die)));
+		boffs = dwarf_bitoffset(vr_die);
+		total = dwarf_bytesize(vr_die);
+		if (boffs < 0 || total < 0)
+			return -ENOENT;
+		ret = snprintf(buf, 16, "b%d@%d/%zd", bsize, boffs,
+				BYTES_TO_BITS(total));
 		goto formatted;
 	}
 
@@ -958,10 +440,11 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 		return (tvar->type == NULL) ? -ENOMEM : 0;
 	}
 
-	ret = BYTES_TO_BITS(die_get_byte_size(&type));
-	if (!ret)
+	ret = dwarf_bytesize(&type);
+	if (ret <= 0)
 		/* No size ... try to use default type */
 		return 0;
+	ret = BYTES_TO_BITS(ret);
 
 	/* Check the bitwidth */
 	if (ret > MAX_BASIC_TYPE_BITS) {
@@ -1025,7 +508,7 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			else
 				*ref_ptr = ref;
 		}
-		ref->offset += die_get_byte_size(&type) * field->index;
+		ref->offset += dwarf_bytesize(&type) * field->index;
 		if (!field->next)
 			/* Save vr_die for converting types */
 			memcpy(die_mem, vr_die, sizeof(*die_mem));
@@ -1245,8 +728,7 @@ static int call_probe_finder(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 	/* If no real subprogram, find a real one */
 	if (!sp_die || dwarf_tag(sp_die) != DW_TAG_subprogram) {
-		sp_die = die_find_real_subprogram(&pf->cu_die,
-						  pf->addr, &die_mem);
+		sp_die = die_find_realfunc(&pf->cu_die, pf->addr, &die_mem);
 		if (!sp_die) {
 			pr_warning("Failed to find probe point in any "
 				   "functions.\n");
@@ -1504,28 +986,18 @@ static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
 }
 
 /* Find probe points from debuginfo */
-static int find_probes(int fd, struct probe_finder *pf)
+static int debuginfo__find_probes(struct debuginfo *self,
+				  struct probe_finder *pf)
 {
 	struct perf_probe_point *pp = &pf->pev->point;
 	Dwarf_Off off, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
-	Dwarf *dbg = NULL;
-	Dwfl *dwfl;
-	Dwarf_Addr bias;	/* Currently ignored */
 	int ret = 0;
 
-	dbg = dwfl_init_offline_dwarf(fd, &dwfl, &bias);
-	if (!dbg) {
-		pr_warning("No debug information found in the vmlinux - "
-			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		close(fd);	/* Without dwfl_end(), fd isn't closed. */
-		return -EBADF;
-	}
-
 #if _ELFUTILS_PREREQ(0, 142)
 	/* Get the call frame information from this dwarf */
-	pf->cfi = dwarf_getcfi(dbg);
+	pf->cfi = dwarf_getcfi(self->dbg);
 #endif
 
 	off = 0;
@@ -1544,7 +1016,8 @@ static int find_probes(int fd, struct probe_finder *pf)
 			.data = pf,
 		};
 
-		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
+		dwarf_getpubnames(self->dbg, pubname_search_cb,
+				  &pubname_param, 0);
 		if (pubname_param.found) {
 			ret = probe_point_search_cb(&pf->sp_die, &probe_param);
 			if (ret)
@@ -1553,9 +1026,9 @@ static int find_probes(int fd, struct probe_finder *pf)
 	}
 
 	/* Loop on CUs (Compilation Unit) */
-	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
+	while (!dwarf_nextcu(self->dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		diep = dwarf_offdie(dbg, off + cuhl, &pf->cu_die);
+		diep = dwarf_offdie(self->dbg, off + cuhl, &pf->cu_die);
 		if (!diep)
 			continue;
 
@@ -1582,8 +1055,6 @@ static int find_probes(int fd, struct probe_finder *pf)
 
 found:
 	line_list__free(&pf->lcache);
-	if (dwfl)
-		dwfl_end(dwfl);
 
 	return ret;
 }
@@ -1629,8 +1100,9 @@ static int add_probe_trace_event(Dwarf_Die *sp_die, struct probe_finder *pf)
 }
 
 /* Find probe_trace_events specified by perf_probe_event from debuginfo */
-int find_probe_trace_events(int fd, struct perf_probe_event *pev,
-			    struct probe_trace_event **tevs, int max_tevs)
+int debuginfo__find_trace_events(struct debuginfo *self,
+				 struct perf_probe_event *pev,
+				 struct probe_trace_event **tevs, int max_tevs)
 {
 	struct trace_event_finder tf = {
 			.pf = {.pev = pev, .callback = add_probe_trace_event},
@@ -1645,7 +1117,7 @@ int find_probe_trace_events(int fd, struct perf_probe_event *pev,
 	tf.tevs = *tevs;
 	tf.ntevs = 0;
 
-	ret = find_probes(fd, &tf.pf);
+	ret = debuginfo__find_probes(self, &tf.pf);
 	if (ret < 0) {
 		free(*tevs);
 		*tevs = NULL;
@@ -1739,9 +1211,10 @@ out:
 }
 
 /* Find available variables at given probe point */
-int find_available_vars_at(int fd, struct perf_probe_event *pev,
-			   struct variable_list **vls, int max_vls,
-			   bool externs)
+int debuginfo__find_available_vars_at(struct debuginfo *self,
+				      struct perf_probe_event *pev,
+				      struct variable_list **vls,
+				      int max_vls, bool externs)
 {
 	struct available_var_finder af = {
 			.pf = {.pev = pev, .callback = add_available_vars},
@@ -1756,7 +1229,7 @@ int find_available_vars_at(int fd, struct perf_probe_event *pev,
 	af.vls = *vls;
 	af.nvls = 0;
 
-	ret = find_probes(fd, &af.pf);
+	ret = debuginfo__find_probes(self, &af.pf);
 	if (ret < 0) {
 		/* Free vlist for error */
 		while (af.nvls--) {
@@ -1774,28 +1247,19 @@ int find_available_vars_at(int fd, struct perf_probe_event *pev,
 }
 
 /* Reverse search */
-int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
+int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
+				struct perf_probe_point *ppt)
 {
 	Dwarf_Die cudie, spdie, indie;
-	Dwarf *dbg = NULL;
-	Dwfl *dwfl = NULL;
-	Dwarf_Addr _addr, baseaddr, bias = 0;
+	Dwarf_Addr _addr, baseaddr;
 	const char *fname = NULL, *func = NULL, *tmp;
 	int baseline = 0, lineno = 0, ret = 0;
 
-	/* Open the live linux kernel */
-	dbg = dwfl_init_live_kernel_dwarf(addr, &dwfl, &bias);
-	if (!dbg) {
-		pr_warning("No debug information found in the vmlinux - "
-			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		ret = -EINVAL;
-		goto end;
-	}
-
 	/* Adjust address with bias */
-	addr += bias;
+	addr += self->bias;
+
 	/* Find cu die */
-	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr - bias, &cudie)) {
+	if (!dwarf_addrdie(self->dbg, (Dwarf_Addr)addr - self->bias, &cudie)) {
 		pr_warning("Failed to find debug information for address %lx\n",
 			   addr);
 		ret = -EINVAL;
@@ -1807,7 +1271,7 @@ int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
 	/* Don't care whether it failed or not */
 
 	/* Find a corresponding function (name, baseline and baseaddr) */
-	if (die_find_real_subprogram(&cudie, (Dwarf_Addr)addr, &spdie)) {
+	if (die_find_realfunc(&cudie, (Dwarf_Addr)addr, &spdie)) {
 		/* Get function entry information */
 		tmp = dwarf_diename(&spdie);
 		if (!tmp ||
@@ -1871,8 +1335,6 @@ post:
 		}
 	}
 end:
-	if (dwfl)
-		dwfl_end(dwfl);
 	if (ret == 0 && (fname || func))
 		ret = 1;	/* Found a point */
 	return ret;
@@ -1982,26 +1444,15 @@ static int find_line_range_by_func(struct line_finder *lf)
 	return param.retval;
 }
 
-int find_line_range(int fd, struct line_range *lr)
+int debuginfo__find_line_range(struct debuginfo *self, struct line_range *lr)
 {
 	struct line_finder lf = {.lr = lr, .found = 0};
 	int ret = 0;
 	Dwarf_Off off = 0, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
-	Dwarf *dbg = NULL;
-	Dwfl *dwfl;
-	Dwarf_Addr bias;	/* Currently ignored */
 	const char *comp_dir;
 
-	dbg = dwfl_init_offline_dwarf(fd, &dwfl, &bias);
-	if (!dbg) {
-		pr_warning("No debug information found in the vmlinux - "
-			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		close(fd);	/* Without dwfl_end(), fd isn't closed. */
-		return -EBADF;
-	}
-
 	/* Fastpath: lookup by function name from .debug_pubnames section */
 	if (lr->function) {
 		struct pubname_callback_param pubname_param = {
@@ -2010,7 +1461,8 @@ int find_line_range(int fd, struct line_range *lr)
 		struct dwarf_callback_param line_range_param = {
 			.data = (void *)&lf, .retval = 0};
 
-		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
+		dwarf_getpubnames(self->dbg, pubname_search_cb,
+				  &pubname_param, 0);
 		if (pubname_param.found) {
 			line_range_search_cb(&lf.sp_die, &line_range_param);
 			if (lf.found)
@@ -2020,11 +1472,12 @@ int find_line_range(int fd, struct line_range *lr)
 
 	/* Loop on CUs (Compilation Unit) */
 	while (!lf.found && ret >= 0) {
-		if (dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) != 0)
+		if (dwarf_nextcu(self->dbg, off, &noff, &cuhl,
+				 NULL, NULL, NULL) != 0)
 			break;
 
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		diep = dwarf_offdie(dbg, off + cuhl, &lf.cu_die);
+		diep = dwarf_offdie(self->dbg, off + cuhl, &lf.cu_die);
 		if (!diep)
 			continue;
 
@@ -2058,7 +1511,6 @@ found:
 	}
 
 	pr_debug("path: %s\n", lr->path);
-	dwfl_end(dwfl);
 	return (ret < 0) ? ret : lf.found;
 }
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 605730a..c478b42 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -16,27 +16,42 @@ static inline int is_c_varname(const char *name)
 }
 
 #ifdef DWARF_SUPPORT
+
+#include "dwarf-aux.h"
+
+/* TODO: export debuginfo data structure even if no dwarf support */
+
+/* debug information structure */
+struct debuginfo {
+	Dwarf		*dbg;
+	Dwfl		*dwfl;
+	Dwarf_Addr	bias;
+};
+
+extern struct debuginfo *debuginfo__new(const char *path);
+extern struct debuginfo *debuginfo__new_online_kernel(unsigned long addr);
+extern void debuginfo__delete(struct debuginfo *self);
+
 /* Find probe_trace_events specified by perf_probe_event from debuginfo */
-extern int find_probe_trace_events(int fd, struct perf_probe_event *pev,
-				    struct probe_trace_event **tevs,
-				    int max_tevs);
+extern int debuginfo__find_trace_events(struct debuginfo *self,
+					struct perf_probe_event *pev,
+					struct probe_trace_event **tevs,
+					int max_tevs);
 
 /* Find a perf_probe_point from debuginfo */
-extern int find_perf_probe_point(unsigned long addr,
-				 struct perf_probe_point *ppt);
+extern int debuginfo__find_probe_point(struct debuginfo *self,
+				       unsigned long addr,
+				       struct perf_probe_point *ppt);
 
 /* Find a line range */
-extern int find_line_range(int fd, struct line_range *lr);
+extern int debuginfo__find_line_range(struct debuginfo *self,
+				      struct line_range *lr);
 
 /* Find available variables */
-extern int find_available_vars_at(int fd, struct perf_probe_event *pev,
-				  struct variable_list **vls, int max_points,
-				  bool externs);
-
-#include <dwarf.h>
-#include <elfutils/libdw.h>
-#include <elfutils/libdwfl.h>
-#include <elfutils/version.h>
+extern int debuginfo__find_available_vars_at(struct debuginfo *self,
+					     struct perf_probe_event *pev,
+					     struct variable_list **vls,
+					     int max_points, bool externs);
 
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a9ac050..8e0b5a3 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -247,7 +247,7 @@ struct pyrf_cpu_map {
 static int pyrf_cpu_map__init(struct pyrf_cpu_map *pcpus,
 			      PyObject *args, PyObject *kwargs)
 {
-	static char *kwlist[] = { "cpustr", NULL, NULL, };
+	static char *kwlist[] = { "cpustr", NULL };
 	char *cpustr = NULL;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|s",
@@ -316,7 +316,7 @@ struct pyrf_thread_map {
 static int pyrf_thread_map__init(struct pyrf_thread_map *pthreads,
 				 PyObject *args, PyObject *kwargs)
 {
-	static char *kwlist[] = { "pid", "tid", NULL, NULL, };
+	static char *kwlist[] = { "pid", "tid", NULL };
 	int pid = -1, tid = -1;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ii",
@@ -418,7 +418,9 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 		"wakeup_events",
 		"bp_type",
 		"bp_addr",
-		"bp_len", NULL, NULL, };
+		"bp_len",
+		 NULL
+	};
 	u64 sample_period = 0;
 	u32 disabled = 0,
 	    inherit = 0,
@@ -499,7 +501,7 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 	struct thread_map *threads = NULL;
 	PyObject *pcpus = NULL, *pthreads = NULL;
 	int group = 0, inherit = 0;
-	static char *kwlist[] = {"cpus", "threads", "group", "inherit", NULL, NULL};
+	static char *kwlist[] = { "cpus", "threads", "group", "inherit", NULL };
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist,
 					 &pcpus, &pthreads, &group, &inherit))
@@ -582,8 +584,7 @@ static PyObject *pyrf_evlist__mmap(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
-	static char *kwlist[] = {"pages", "overwrite",
-				  NULL, NULL};
+	static char *kwlist[] = { "pages", "overwrite", NULL };
 	int pages = 128, overwrite = false;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ii", kwlist,
@@ -603,7 +604,7 @@ static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
-	static char *kwlist[] = {"timeout", NULL, NULL};
+	static char *kwlist[] = { "timeout", NULL };
 	int timeout = -1, n;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|i", kwlist, &timeout))
@@ -674,7 +675,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	struct perf_evlist *evlist = &pevlist->evlist;
 	union perf_event *event;
 	int sample_id_all = 1, cpu;
-	static char *kwlist[] = {"cpu", "sample_id_all", NULL, NULL};
+	static char *kwlist[] = { "cpu", "sample_id_all", NULL };
 	int err;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "i|i", kwlist,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f5a8fbd..72458d9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -12,6 +12,7 @@
 #include "session.h"
 #include "sort.h"
 #include "util.h"
+#include "cpumap.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -247,9 +248,14 @@ int perf_session__resolve_callchain(struct perf_session *self,
 	callchain_cursor_reset(&self->callchain_cursor);
 
 	for (i = 0; i < chain->nr; i++) {
-		u64 ip = chain->ips[i];
+		u64 ip;
 		struct addr_location al;
 
+		if (callchain_param.order == ORDER_CALLEE)
+			ip = chain->ips[i];
+		else
+			ip = chain->ips[chain->nr - i - 1];
+
 		if (ip >= PERF_CONTEXT_MAX) {
 			switch (ip) {
 			case PERF_CONTEXT_HV:
@@ -407,20 +413,26 @@ static void perf_event__read_swap(union perf_event *event)
 	event->read.id		 = bswap_64(event->read.id);
 }
 
-static void perf_event__attr_swap(union perf_event *event)
+/* exported for swapping attributes in file header */
+void perf_event__attr_swap(struct perf_event_attr *attr)
+{
+	attr->type		= bswap_32(attr->type);
+	attr->size		= bswap_32(attr->size);
+	attr->config		= bswap_64(attr->config);
+	attr->sample_period	= bswap_64(attr->sample_period);
+	attr->sample_type	= bswap_64(attr->sample_type);
+	attr->read_format	= bswap_64(attr->read_format);
+	attr->wakeup_events	= bswap_32(attr->wakeup_events);
+	attr->bp_type		= bswap_32(attr->bp_type);
+	attr->bp_addr		= bswap_64(attr->bp_addr);
+	attr->bp_len		= bswap_64(attr->bp_len);
+}
+
+static void perf_event__hdr_attr_swap(union perf_event *event)
 {
 	size_t size;
 
-	event->attr.attr.type		= bswap_32(event->attr.attr.type);
-	event->attr.attr.size		= bswap_32(event->attr.attr.size);
-	event->attr.attr.config		= bswap_64(event->attr.attr.config);
-	event->attr.attr.sample_period	= bswap_64(event->attr.attr.sample_period);
-	event->attr.attr.sample_type	= bswap_64(event->attr.attr.sample_type);
-	event->attr.attr.read_format	= bswap_64(event->attr.attr.read_format);
-	event->attr.attr.wakeup_events	= bswap_32(event->attr.attr.wakeup_events);
-	event->attr.attr.bp_type	= bswap_32(event->attr.attr.bp_type);
-	event->attr.attr.bp_addr	= bswap_64(event->attr.attr.bp_addr);
-	event->attr.attr.bp_len		= bswap_64(event->attr.attr.bp_len);
+	perf_event__attr_swap(&event->attr.attr);
 
 	size = event->header.size;
 	size -= (void *)&event->attr.id - (void *)event;
@@ -448,7 +460,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_LOST]		  = perf_event__all64_swap,
 	[PERF_RECORD_READ]		  = perf_event__read_swap,
 	[PERF_RECORD_SAMPLE]		  = perf_event__all64_swap,
-	[PERF_RECORD_HEADER_ATTR]	  = perf_event__attr_swap,
+	[PERF_RECORD_HEADER_ATTR]	  = perf_event__hdr_attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
 	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
@@ -708,9 +720,9 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 	if (!dump_trace)
 		return;
 
-	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 "\n",
+	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
 	       event->header.misc, sample->pid, sample->tid, sample->ip,
-	       sample->period);
+	       sample->period, sample->addr);
 
 	if (session->sample_type & PERF_SAMPLE_CALLCHAIN)
 		callchain__printf(sample);
@@ -1202,9 +1214,10 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 	return NULL;
 }
 
-void perf_session__print_symbols(union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_session *session)
+void perf_session__print_ip(union perf_event *event,
+			    struct perf_sample *sample,
+			    struct perf_session *session,
+			    int print_sym, int print_dso)
 {
 	struct addr_location al;
 	const char *symname, *dsoname;
@@ -1233,32 +1246,83 @@ void perf_session__print_symbols(union perf_event *event,
 			if (!node)
 				break;
 
-			if (node->sym && node->sym->name)
-				symname = node->sym->name;
+			printf("\t%16" PRIx64, node->ip);
+			if (print_sym) {
+				if (node->sym && node->sym->name)
+					symname = node->sym->name;
+				else
+					symname = "";
+
+				printf(" %s", symname);
+			}
+			if (print_dso) {
+				if (node->map && node->map->dso && node->map->dso->name)
+					dsoname = node->map->dso->name;
+				else
+					dsoname = "";
+
+				printf(" (%s)", dsoname);
+			}
+			printf("\n");
+
+			callchain_cursor_advance(cursor);
+		}
+
+	} else {
+		printf("%16" PRIx64, sample->ip);
+		if (print_sym) {
+			if (al.sym && al.sym->name)
+				symname = al.sym->name;
 			else
 				symname = "";
 
-			if (node->map && node->map->dso && node->map->dso->name)
-				dsoname = node->map->dso->name;
+			printf(" %s", symname);
+		}
+
+		if (print_dso) {
+			if (al.map && al.map->dso && al.map->dso->name)
+				dsoname = al.map->dso->name;
 			else
 				dsoname = "";
 
-			printf("\t%16" PRIx64 " %s (%s)\n", node->ip, symname, dsoname);
+			printf(" (%s)", dsoname);
+		}
+	}
+}
 
-			callchain_cursor_advance(cursor);
+int perf_session__cpu_bitmap(struct perf_session *session,
+			     const char *cpu_list, unsigned long *cpu_bitmap)
+{
+	int i;
+	struct cpu_map *map;
+
+	for (i = 0; i < PERF_TYPE_MAX; ++i) {
+		struct perf_evsel *evsel;
+
+		evsel = perf_session__find_first_evtype(session, i);
+		if (!evsel)
+			continue;
+
+		if (!(evsel->attr.sample_type & PERF_SAMPLE_CPU)) {
+			pr_err("File does not contain CPU events. "
+			       "Remove -c option to proceed.\n");
+			return -1;
 		}
+	}
 
-	} else {
-		if (al.sym && al.sym->name)
-			symname = al.sym->name;
-		else
-			symname = "";
+	map = cpu_map__new(cpu_list);
 
-		if (al.map && al.map->dso && al.map->dso->name)
-			dsoname = al.map->dso->name;
-		else
-			dsoname = "";
+	for (i = 0; i < map->nr; i++) {
+		int cpu = map->map[i];
+
+		if (cpu >= MAX_NR_CPUS) {
+			pr_err("Requested CPU %d too large. "
+			       "Consider raising MAX_NR_CPUS\n", cpu);
+			return -1;
+		}
 
-		printf("%16" PRIx64 " %s (%s)", al.addr, symname, dsoname);
+		set_bit(cpu, cpu_bitmap);
 	}
+
+	return 0;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 66d4e14..170601e 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -112,6 +112,7 @@ int perf_session__set_kallsyms_ref_reloc_sym(struct map **maps,
 					     u64 addr);
 
 void mem_bswap_64(void *src, int byte_size);
+void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *self);
 
@@ -167,8 +168,12 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
-void perf_session__print_symbols(union perf_event *event,
+void perf_session__print_ip(union perf_event *event,
 				 struct perf_sample *sample,
-				 struct perf_session *session);
+				 struct perf_session *session,
+				 int print_sym, int print_dso);
+
+int perf_session__cpu_bitmap(struct perf_session *session,
+			     const char *cpu_list, unsigned long *cpu_bitmap);
 
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f44fa54..401e220 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -15,95 +15,6 @@ char * field_sep;
 
 LIST_HEAD(hist_entry__sort_list);
 
-static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
-				       size_t size, unsigned int width);
-static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
-				     size_t size, unsigned int width);
-static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width);
-static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width);
-static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
-				       size_t size, unsigned int width);
-static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width);
-
-struct sort_entry sort_thread = {
-	.se_header	= "Command:  Pid",
-	.se_cmp		= sort__thread_cmp,
-	.se_snprintf	= hist_entry__thread_snprintf,
-	.se_width_idx	= HISTC_THREAD,
-};
-
-struct sort_entry sort_comm = {
-	.se_header	= "Command",
-	.se_cmp		= sort__comm_cmp,
-	.se_collapse	= sort__comm_collapse,
-	.se_snprintf	= hist_entry__comm_snprintf,
-	.se_width_idx	= HISTC_COMM,
-};
-
-struct sort_entry sort_dso = {
-	.se_header	= "Shared Object",
-	.se_cmp		= sort__dso_cmp,
-	.se_snprintf	= hist_entry__dso_snprintf,
-	.se_width_idx	= HISTC_DSO,
-};
-
-struct sort_entry sort_sym = {
-	.se_header	= "Symbol",
-	.se_cmp		= sort__sym_cmp,
-	.se_snprintf	= hist_entry__sym_snprintf,
-	.se_width_idx	= HISTC_SYMBOL,
-};
-
-struct sort_entry sort_parent = {
-	.se_header	= "Parent symbol",
-	.se_cmp		= sort__parent_cmp,
-	.se_snprintf	= hist_entry__parent_snprintf,
-	.se_width_idx	= HISTC_PARENT,
-};
- 
-struct sort_entry sort_cpu = {
-	.se_header      = "CPU",
-	.se_cmp	        = sort__cpu_cmp,
-	.se_snprintf    = hist_entry__cpu_snprintf,
-	.se_width_idx	= HISTC_CPU,
-};
-
-struct sort_dimension {
-	const char		*name;
-	struct sort_entry	*entry;
-	int			taken;
-};
-
-static struct sort_dimension sort_dimensions[] = {
-	{ .name = "pid",	.entry = &sort_thread,	},
-	{ .name = "comm",	.entry = &sort_comm,	},
-	{ .name = "dso",	.entry = &sort_dso,	},
-	{ .name = "symbol",	.entry = &sort_sym,	},
-	{ .name = "parent",	.entry = &sort_parent,	},
-	{ .name = "cpu",	.entry = &sort_cpu,	},
-};
-
-int64_t cmp_null(void *l, void *r)
-{
-	if (!l && !r)
-		return 0;
-	else if (!l)
-		return -1;
-	else
-		return 1;
-}
-
-/* --sort pid */
-
-int64_t
-sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
 static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 {
 	int n;
@@ -125,6 +36,24 @@ static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 	return n;
 }
 
+static int64_t cmp_null(void *l, void *r)
+{
+	if (!l && !r)
+		return 0;
+	else if (!l)
+		return -1;
+	else
+		return 1;
+}
+
+/* --sort pid */
+
+static int64_t
+sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->thread->pid - left->thread->pid;
+}
+
 static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width)
 {
@@ -132,15 +61,50 @@ static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
 			      self->thread->comm ?: "", self->thread->pid);
 }
 
+struct sort_entry sort_thread = {
+	.se_header	= "Command:  Pid",
+	.se_cmp		= sort__thread_cmp,
+	.se_snprintf	= hist_entry__thread_snprintf,
+	.se_width_idx	= HISTC_THREAD,
+};
+
+/* --sort comm */
+
+static int64_t
+sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->thread->pid - left->thread->pid;
+}
+
+static int64_t
+sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
+{
+	char *comm_l = left->thread->comm;
+	char *comm_r = right->thread->comm;
+
+	if (!comm_l || !comm_r)
+		return cmp_null(comm_l, comm_r);
+
+	return strcmp(comm_l, comm_r);
+}
+
 static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
 				     size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%*s", width, self->thread->comm);
 }
 
+struct sort_entry sort_comm = {
+	.se_header	= "Command",
+	.se_cmp		= sort__comm_cmp,
+	.se_collapse	= sort__comm_collapse,
+	.se_snprintf	= hist_entry__comm_snprintf,
+	.se_width_idx	= HISTC_COMM,
+};
+
 /* --sort dso */
 
-int64_t
+static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	struct dso *dso_l = left->ms.map ? left->ms.map->dso : NULL;
@@ -173,9 +137,16 @@ static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
 }
 
+struct sort_entry sort_dso = {
+	.se_header	= "Shared Object",
+	.se_cmp		= sort__dso_cmp,
+	.se_snprintf	= hist_entry__dso_snprintf,
+	.se_width_idx	= HISTC_DSO,
+};
+
 /* --sort symbol */
 
-int64_t
+static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	u64 ip_l, ip_r;
@@ -211,29 +182,16 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 	return ret;
 }
 
-/* --sort comm */
-
-int64_t
-sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
-int64_t
-sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
-{
-	char *comm_l = left->thread->comm;
-	char *comm_r = right->thread->comm;
-
-	if (!comm_l || !comm_r)
-		return cmp_null(comm_l, comm_r);
-
-	return strcmp(comm_l, comm_r);
-}
+struct sort_entry sort_sym = {
+	.se_header	= "Symbol",
+	.se_cmp		= sort__sym_cmp,
+	.se_snprintf	= hist_entry__sym_snprintf,
+	.se_width_idx	= HISTC_SYMBOL,
+};
 
 /* --sort parent */
 
-int64_t
+static int64_t
 sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	struct symbol *sym_l = left->parent;
@@ -252,9 +210,16 @@ static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
 			      self->parent ? self->parent->name : "[other]");
 }
 
+struct sort_entry sort_parent = {
+	.se_header	= "Parent symbol",
+	.se_cmp		= sort__parent_cmp,
+	.se_snprintf	= hist_entry__parent_snprintf,
+	.se_width_idx	= HISTC_PARENT,
+};
+
 /* --sort cpu */
 
-int64_t
+static int64_t
 sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	return right->cpu - left->cpu;
@@ -266,6 +231,28 @@ static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
 }
 
+struct sort_entry sort_cpu = {
+	.se_header      = "CPU",
+	.se_cmp	        = sort__cpu_cmp,
+	.se_snprintf    = hist_entry__cpu_snprintf,
+	.se_width_idx	= HISTC_CPU,
+};
+
+struct sort_dimension {
+	const char		*name;
+	struct sort_entry	*entry;
+	int			taken;
+};
+
+static struct sort_dimension sort_dimensions[] = {
+	{ .name = "pid",	.entry = &sort_thread,	},
+	{ .name = "comm",	.entry = &sort_comm,	},
+	{ .name = "dso",	.entry = &sort_dso,	},
+	{ .name = "symbol",	.entry = &sort_sym,	},
+	{ .name = "parent",	.entry = &sort_parent,	},
+	{ .name = "cpu",	.entry = &sort_cpu,	},
+};
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
@@ -273,15 +260,9 @@ int sort_dimension__add(const char *tok)
 	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
 		struct sort_dimension *sd = &sort_dimensions[i];
 
-		if (sd->taken)
-			continue;
-
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
-		if (sd->entry->se_collapse)
-			sort__need_collapse = 1;
-
 		if (sd->entry == &sort_parent) {
 			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
 			if (ret) {
@@ -294,6 +275,12 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		}
 
+		if (sd->taken)
+			return 0;
+
+		if (sd->entry->se_collapse)
+			sort__need_collapse = 1;
+
 		if (list_empty(&hist_entry__sort_list)) {
 			if (!strcmp(sd->name, "pid"))
 				sort__first_dimension = SORT_PID;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0b91053..77d0388 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -103,20 +103,6 @@ extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
 
 void setup_sorting(const char * const usagestr[], const struct option *opts);
-
-extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
-extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
-extern size_t sort__dso_print(FILE *, struct hist_entry *, unsigned int);
-extern size_t sort__sym_print(FILE *, struct hist_entry *, unsigned int __used);
-extern int64_t cmp_null(void *, void *);
-extern int64_t sort__thread_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__comm_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__comm_collapse(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__dso_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
-int64_t sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right);
-extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
 extern int sort_dimension__add(const char *);
 void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
 			     const char *list_name, FILE *fp);
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index b9a985d..d583638 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -294,3 +294,22 @@ bool strlazymatch(const char *str, const char *pat)
 {
 	return __match_glob(str, pat, true);
 }
+
+/**
+ * strtailcmp - Compare the tail of two strings
+ * @s1: 1st string to be compared
+ * @s2: 2nd string to be compared
+ *
+ * Return 0 if whole of either string is same as another's tail part.
+ */
+int strtailcmp(const char *s1, const char *s2)
+{
+	int i1 = strlen(s1);
+	int i2 = strlen(s2);
+	while (--i1 >= 0 && --i2 >= 0) {
+		if (s1[i1] != s2[i2])
+			return s1[i1] - s2[i2];
+	}
+	return 0;
+}
+
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 35729f4..3403f81 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -183,106 +183,59 @@ int bigendian(void)
 	return *ptr == 0x01020304;
 }
 
-static unsigned long long copy_file_fd(int fd)
+/* unfortunately, you can not stat debugfs or proc files for size */
+static void record_file(const char *file, size_t hdr_sz)
 {
 	unsigned long long size = 0;
-	char buf[BUFSIZ];
-	int r;
-
-	do {
-		r = read(fd, buf, BUFSIZ);
-		if (r > 0) {
-			size += r;
-			write_or_die(buf, r);
-		}
-	} while (r > 0);
-
-	return size;
-}
-
-static unsigned long long copy_file(const char *file)
-{
-	unsigned long long size = 0;
-	int fd;
+	char buf[BUFSIZ], *sizep;
+	off_t hdr_pos = lseek(output_fd, 0, SEEK_CUR);
+	int r, fd;
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0)
 		die("Can't read '%s'", file);
-	size = copy_file_fd(fd);
-	close(fd);
 
-	return size;
-}
-
-static unsigned long get_size_fd(int fd)
-{
-	unsigned long long size = 0;
-	char buf[BUFSIZ];
-	int r;
+	/* put in zeros for file size, then fill true size later */
+	write_or_die(&size, hdr_sz);
 
 	do {
 		r = read(fd, buf, BUFSIZ);
-		if (r > 0)
+		if (r > 0) {
 			size += r;
+			write_or_die(buf, r);
+		}
 	} while (r > 0);
-
-	lseek(fd, 0, SEEK_SET);
-
-	return size;
-}
-
-static unsigned long get_size(const char *file)
-{
-	unsigned long long size = 0;
-	int fd;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0)
-		die("Can't read '%s'", file);
-	size = get_size_fd(fd);
 	close(fd);
 
-	return size;
+	/* ugh, handle big-endian hdr_size == 4 */
+	sizep = (char*)&size;
+	if (bigendian())
+		sizep += sizeof(u64) - hdr_sz;
+
+	if (pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
+		die("writing to %s", output_file);
 }
 
 static void read_header_files(void)
 {
-	unsigned long long size, check_size;
 	char *path;
-	int fd;
+	struct stat st;
 
 	path = get_tracing_file("events/header_page");
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
+	if (stat(path, &st) < 0)
 		die("can't read '%s'", path);
 
-	/* unfortunately, you can not stat debugfs files for size */
-	size = get_size_fd(fd);
-
 	write_or_die("header_page", 12);
-	write_or_die(&size, 8);
-	check_size = copy_file_fd(fd);
-	close(fd);
-
-	if (size != check_size)
-		die("wrong size for '%s' size=%lld read=%lld",
-		    path, size, check_size);
+	record_file(path, 8);
 	put_tracing_file(path);
 
 	path = get_tracing_file("events/header_event");
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
+	if (stat(path, &st) < 0)
 		die("can't read '%s'", path);
 
-	size = get_size_fd(fd);
-
 	write_or_die("header_event", 13);
-	write_or_die(&size, 8);
-	check_size = copy_file_fd(fd);
-	if (size != check_size)
-		die("wrong size for '%s'", path);
+	record_file(path, 8);
 	put_tracing_file(path);
-	close(fd);
 }
 
 static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
@@ -298,7 +251,6 @@ static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
 
 static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 {
-	unsigned long long size, check_size;
 	struct dirent *dent;
 	struct stat st;
 	char *format;
@@ -338,14 +290,8 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 
-		if (ret >= 0) {
-			/* unfortunately, you can not stat debugfs files for size */
-			size = get_size(format);
-			write_or_die(&size, 8);
-			check_size = copy_file(format);
-			if (size != check_size)
-				die("error in size of file '%s'", format);
-		}
+		if (ret >= 0)
+			record_file(format, 8);
 
 		free(format);
 	}
@@ -426,7 +372,7 @@ static void read_event_files(struct tracepoint_path *tps)
 
 static void read_proc_kallsyms(void)
 {
-	unsigned int size, check_size;
+	unsigned int size;
 	const char *path = "/proc/kallsyms";
 	struct stat st;
 	int ret;
@@ -438,17 +384,12 @@ static void read_proc_kallsyms(void)
 		write_or_die(&size, 4);
 		return;
 	}
-	size = get_size(path);
-	write_or_die(&size, 4);
-	check_size = copy_file(path);
-	if (size != check_size)
-		die("error in size of file '%s'", path);
-
+	record_file(path, 4);
 }
 
 static void read_ftrace_printk(void)
 {
-	unsigned int size, check_size;
+	unsigned int size;
 	char *path;
 	struct stat st;
 	int ret;
@@ -461,11 +402,8 @@ static void read_ftrace_printk(void)
 		write_or_die(&size, 4);
 		goto out;
 	}
-	size = get_size(path);
-	write_or_die(&size, 4);
-	check_size = copy_file(path);
-	if (size != check_size)
-		die("error in size of file '%s'", path);
+	record_file(path, 4);
+
 out:
 	put_tracing_file(path);
 }
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index fc78428..0128906 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -238,6 +238,7 @@ char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
 bool strlazymatch(const char *str, const char *pat);
+int strtailcmp(const char *s1, const char *s2);
 unsigned long convert_unit(unsigned long value, char *unit);
 int readn(int fd, void *buf, size_t size);
 
