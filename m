Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab0JUNG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:06:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab0JUNGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:06:24 -0400
Date: Thu, 21 Oct 2010 15:05:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events changes for v2.6.37
Message-ID: <20101021130559.GA1068@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
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
Akinobu Mita (2):
      lockup_detector: Convert cpu notifier to return encapsulate errno value
      lockup_detector: Remove unused panic_notifier

Anand Gadiyar (2):
      oprofile: include platform_device.h to fix build break
      oprofile: fix linker errors

Andi Kleen (1):
      perf, gcc-4.6: Fix set but unused variable

Arnaldo Carvalho de Melo (9):
      perf ui browser: Abstract some more slang operations
      perf ui browser: Return the exit key in all browsers
      perf ui browser: Add routines to compactly specify exit keys
      perf tools: Add --tui and --stdio to choose the UI
      perf hists: Fix hist_entry__init_have_children
      perf hists browser: replace rb_first() != NULL by !RB_EMPTY_ROOT()
      perf hists browser: Init the has_children fields just once
      perf hists browser: Introduce "expand/collapse all callchains" action
      perf ui browser: Don't use windows, slang is enough

Borislav Petkov (1):
      tracing: Fix function-graph build warning on 32-bit

Cyrill Gorcunov (1):
      perf, x86, Pentium4: Add RAW events verification

David S. Miller (1):
      jump label: Add sparc64 support

Frederic Weisbecker (11):
      perf: Drop unappropriate tests on arch callchains
      perf: Generalize callchain_store()
      perf: Generalize some arch callchain code
      perf: Factorize callchain context handling
      perf: Fix race in callchains
      perf: Humanize the number of contexts
      perf: Keep track of the max depth of a callchain
      perf: Rename append_callchain into callchain_append
      perf: Support for callchains merge
      irq: Fix circular headers dependency
      x86: Barf when vmalloc and kmemcheck faults happen in NMI

Heiko Carstens (1):
      [S390] hardirq: remove pointless header file includes

Ingo Molnar (2):
      jump label: Fix GCC feature check when distcc is used
      perf, ARM: Fix sysfs bits removal build failure

Jason Baron (8):
      jump label: Make dynamic no-op selection available outside of ftrace
      jump label: Make text_poke_early() globally visible
      jump label: Base patch for jump label
      jump label: Initialize workqueue tracepoints *before* they are registered
      jump label: Add jump_label_text_reserved() to reserve jump points
      jump label: Tracepoint support for jump labels
      jump label: Convert dynamic debug to use jump labels
      jump label: x86 support

Jean Pihet (1):
      tracing, perf: Add more power related events

Jiri Olsa (6):
      tracing: Add funcgraph-irq option for function graph tracer.
      oprofile, x86: Using struct stack_frame for 64bit processes dump
      oprofile, x86: Adding backtrace dump for 32bit process in compat mode
      tracing: Add proper check for irq_depth routines
      tracing: Make graph related irqs/preemptsoff functions global
      tracing: Graph support for wakeup tracer

John Reiser (1):
      ftrace: Add C version of recordmcount compile time code

Kirill A. Shutemov (1):
      perf tools: add test for strlcpy()

Koki Sanagi (3):
      netdev: Add tracepoints to netdev layer
      skb: Add tracepoints to freeing skb
      perf: Add a script to show packets processing

Lai Jiangshan (1):
      irq: Add tracepoint to softirq_raise

Li Zefan (1):
      tracing: Clean up seqfile code for format file

Lin Ming (1):
      perf: Remove unused variable

Masami Hiramatsu (5):
      kprobes: Update document about irq disabled state in kprobe handler
      kprobes: Fix selftest to clear flags field for reusing probes
      stopmachine: Define __stop_machine when CONFIG_STOP_MACHINE=n
      x86: Use __stop_machine() in text_poke_smp()
      kconfig/x86: Add HAVE_TEXT_POKE_SMP config for stop_machine dependency

Matt Fleming (8):
      perf, sh: Fix patch merge foul-up
      perf: Add helper function to return number of counters
      perf: New helper function for pmu name
      oprofile: Make op_name_from_perf_id() global
      ARM: oprofile: Rename op_arm to oprofile_perf
      ARM: oprofile: Move non-ARM code into separate init/exit
      oprofile: Abstract the perf-events backend
      sh: oprofile: Use perf-events oprofile backend

Matt Helsley (3):
      hw breakpoints: Fix pid namespace bug
      perf events: Split out task search into helper
      perf events: Clean up pid passing

Michael Cree (1):
      alpha: Fix HW performance counters to be stopped properly

Namhyung Kim (6):
      perf, tracing: add missing __percpu markups
      kprobes: Remove redundant address check
      kprobes: Verify jprobe entry point
      kprobes: Make functions static
      kprobes: Remove __dummy_buf
      kprobes: Add sparse context annotations

Neil Horman (1):
      napi: Convert trace_napi_poll to TRACE_EVENT

Paul Mackerras (1):
      perf, powerpc: Fix power_pmu_event_init to not use event->ctx

Peter Zijlstra (39):
      perf: Remove superfluous return values from perf_callchain_*()
      perf: Deconstify struct pmu
      perf: Register PMU implementations
      perf: Unindent labels
      perf: Reduce perf_disable() usage
      perf: Per PMU disable
      perf: Default PMU ops
      perf: Shrink hw_perf_event
      perf: Rework the PMU methods
      perf: Remove the sysfs bits
      perf: Separate find_get_context() from event initialization
      perf: Remove the swevent hash-table from the cpu context
      perf: Per cpu-context rotation timer
      perf: Per-pmu-per-cpu contexts
      perf: Move some code around
      perf: Clean up perf_event_context allocation
      perf: Multiple task contexts
      perf: Provide a separate task context for swevents
      perf: Optimize context ops
      perf: Fix up delayed_put_task_struct()
      perf: Ensure we call add_event_to_ctx() with the right locks held
      perf: Fix perf_init_event()
      perf: Sanitize the RCU logic
      perf: Fix free_event()
      perf: Complete software pmu grouping
      perf: Fix perf_event_exit_cpu_context()
      perf: Undo the per cpu-context timer stuff
      percpu: Add {get,put}_cpu_ptr
      perf: Avoid RCU vs preemption assumptions
      irq_work: Add generic hardirq context callbacks
      perf: Fix group moving
      perf: Fix task refcount bugs
      perf: Find task before event alloc
      perf, hw_breakpoint: Fix crash in hw_breakpoint creation
      jump_label: Use more consistent naming
      jump_label: Add atomic_t interface
      perf: Use jump_labels to optimize the scheduler hooks
      perf: Optimize sw events
      jump_label: Add COND_STMT(), reducer wrappery

Robert Richter (12):
      oprofile, arm: initialize perf_event pointers with NULL
      oprofile, x86: Simplify init/exit functions
      oprofile, ARM: Use oprofile_arch_exit() to cleanup on failure
      oprofile, ARM: Rework op_create_counter()
      oprofile, ARM: Remove some goto statements
      oprofile: Remove duplicate code around __oprofilefs_create_file()
      oprofile, ARM: Release resources on failure
      oprofile, ARM: Remove some goto statements
      oprofile, ARM: Rework op_create_counter()
      oprofile, ARM: Use oprofile_arch_exit() to cleanup on failure
      oprofile: disable write access to oprofilefs while profiler is running
      oprofile: make !CONFIG_PM function stubs static inline

Srikar Dronamraju (1):
      perf symbols: List symbols in a dso in ascending name order

Stephane Eranian (7):
      perf_events: Fix BTS interrupt handling to avoid being dazed by NMI (v2)
      watchdog: Avoid kernel crash when disabling watchdog
      perf_events: Fix broken event grouping
      perf_events: Fix invalid pointer when pid is invalid
      perf_events: Fix bogus context time tracking
      perf_events: Fix bogus AMD64 generic TLB events
      perf_events: Fix transaction recovery in group_sched_in()

Steven Rostedt (20):
      tracing/lockdep: Fix dependency of TRACE_IRQFLAGS
      ring-buffer: Place duplicate expression into a single function
      tracing: Do not reset *pos in set_ftrace_filter
      tracing: Replace typecasted void pointer in set_ftrace_filter code
      tracing: Keep track of set_ftrace_filter position and allow lseek again
      tracing: Fix reading of set_ftrace_filter across lists
      tracing: Do not trace in irq when funcgraph-irq option is zero
      tracing: Remove leftover FTRACE_ENABLE/DISABLE_MCOUNT enums
      jump label: Remove duplicate structure for x86
      jump label/x86/sparc64: Remove !CC_OPTIMIZE_FOR_SIZE config conditions
      ftrace/x86: Add support for C version of recordmcount
      ftrace: Remove duplicate code for 64 and 32 bit in recordmcount.c
      ftrace: Rename config option HAVE_C_MCOUNT_RECORD to HAVE_C_RECORDMCOUNT
      ftrace: Do not process kernel/trace/ftrace.o with C recordmcount program
      ftrace: Use objtree for C version of recordmcount
      tracing: Use one prologue for the wakeup tracer function tracers
      tracing: Use one prologue for the preempt irqs off tracer function tracers
      tracing: Remove parent recording in latency tracer graph options
      ftrace: Remove recursion between recordmcount and scripts/mod/empty
      tracing: Fix compile issue for trace_sched_wakeup.c

Tom Zanussi (1):
      perf tools: Fix linking errors with --as-needed flag

Tony Luck (1):
      [IA64] Move local_softirq_pending() definition

Will Deacon (2):
      oprofile: don't call arch exit code from init code on failure
      ARM: oprofile: fix and simplify init/exit functions

matt mooney (1):
      tracing/trivial: Remove cast from void*


 Documentation/kprobes.txt                         |    8 +-
 Makefile                                          |   11 +
 arch/Kconfig                                      |    3 +
 arch/alpha/Kconfig                                |    1 +
 arch/alpha/include/asm/perf_event.h               |    5 -
 arch/alpha/kernel/perf_event.c                    |  128 +-
 arch/alpha/kernel/time.c                          |   30 +-
 arch/arm/Kconfig                                  |    1 +
 arch/arm/include/asm/perf_event.h                 |   12 -
 arch/arm/kernel/perf_event.c                      |  212 +-
 arch/arm/oprofile/Makefile                        |    4 +
 arch/arm/oprofile/common.c                        |  311 +---
 arch/frv/Kconfig                                  |    1 +
 arch/frv/lib/Makefile                             |    2 +-
 arch/frv/lib/perf_event.c                         |   19 -
 arch/ia64/include/asm/hardirq.h                   |   11 +-
 arch/parisc/Kconfig                               |    1 +
 arch/parisc/include/asm/perf_event.h              |    3 +-
 arch/powerpc/Kconfig                              |    1 +
 arch/powerpc/include/asm/paca.h                   |    2 +-
 arch/powerpc/kernel/perf_callchain.c              |   86 +-
 arch/powerpc/kernel/perf_event.c                  |  166 +-
 arch/powerpc/kernel/perf_event_fsl_emb.c          |  148 +-
 arch/powerpc/kernel/time.c                        |   42 +-
 arch/s390/Kconfig                                 |    1 +
 arch/s390/include/asm/hardirq.h                   |    4 -
 arch/s390/include/asm/perf_event.h                |    3 +-
 arch/sh/Kconfig                                   |   14 +
 arch/sh/include/asm/perf_event.h                  |    7 -
 arch/sh/kernel/perf_callchain.c                   |   50 +-
 arch/sh/kernel/perf_event.c                       |  159 +-
 arch/sh/oprofile/Makefile                         |    4 +
 arch/sh/oprofile/common.c                         |  115 +-
 arch/sh/oprofile/op_impl.h                        |   33 -
 arch/sparc/Kconfig                                |    3 +
 arch/sparc/include/asm/jump_label.h               |   32 +
 arch/sparc/include/asm/perf_event.h               |    4 -
 arch/sparc/kernel/Makefile                        |    2 +
 arch/sparc/kernel/jump_label.c                    |   47 +
 arch/sparc/kernel/module.c                        |    6 +
 arch/sparc/kernel/pcr.c                           |    8 +-
 arch/sparc/kernel/perf_event.c                    |  240 +-
 arch/x86/Kconfig                                  |    8 +
 arch/x86/include/asm/alternative.h                |   11 +
 arch/x86/include/asm/entry_arch.h                 |    4 +-
 arch/x86/include/asm/hardirq.h                    |    2 +-
 arch/x86/include/asm/hw_irq.h                     |    2 +-
 arch/x86/include/asm/irq_vectors.h                |    4 +-
 arch/x86/include/asm/jump_label.h                 |   37 +
 arch/x86/include/asm/perf_event_p4.h              |   52 +-
 arch/x86/kernel/Makefile                          |    3 +-
 arch/x86/kernel/alternative.c                     |   71 +-
 arch/x86/kernel/cpu/perf_event.c                  |  280 +--
 arch/x86/kernel/cpu/perf_event_amd.c              |    4 +-
 arch/x86/kernel/cpu/perf_event_intel.c            |    8 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c         |   13 +-
 arch/x86/kernel/cpu/perf_event_p4.c               |  292 ++-
 arch/x86/kernel/entry_64.S                        |    6 +-
 arch/x86/kernel/ftrace.c                          |   63 +-
 arch/x86/kernel/irq.c                             |    8 +-
 arch/x86/kernel/irq_work.c                        |   30 +
 arch/x86/kernel/irqinit.c                         |    6 +-
 arch/x86/kernel/jump_label.c                      |   50 +
 arch/x86/kernel/kprobes.c                         |   14 +-
 arch/x86/kernel/module.c                          |    3 +
 arch/x86/kernel/setup.c                           |    6 +
 arch/x86/mm/fault.c                               |    4 +
 arch/x86/mm/kmemcheck/kmemcheck.c                 |    2 +
 arch/x86/oprofile/backtrace.c                     |   70 +-
 arch/x86/oprofile/nmi_int.c                       |    9 +-
 drivers/oprofile/oprof.c                          |   32 +-
 drivers/oprofile/oprof.h                          |    2 +-
 drivers/oprofile/oprofile_files.c                 |    7 +-
 drivers/oprofile/oprofile_perf.c                  |  328 +++
 drivers/oprofile/oprofilefs.c                     |   54 +-
 include/asm-generic/hardirq.h                     |    2 +-
 include/asm-generic/vmlinux.lds.h                 |   10 +
 include/linux/dynamic_debug.h                     |   39 +-
 include/linux/ftrace_event.h                      |    8 +-
 include/linux/interrupt.h                         |    8 +-
 include/linux/irq_work.h                          |   20 +
 include/linux/jump_label.h                        |   74 +
 include/linux/jump_label_ref.h                    |   44 +
 include/linux/module.h                            |    5 +-
 include/linux/oprofile.h                          |    7 +
 include/linux/percpu.h                            |    9 +
 include/linux/perf_event.h                        |  212 ++-
 include/linux/sched.h                             |    9 +-
 include/linux/stop_machine.h                      |   10 +-
 include/linux/tracepoint.h                        |    5 +-
 include/trace/events/irq.h                        |   26 +-
 include/trace/events/napi.h                       |   25 +-
 include/trace/events/net.h                        |   82 +
 include/trace/events/power.h                      |   90 +-
 include/trace/events/skb.h                        |   17 +
 init/Kconfig                                      |    8 +
 kernel/Makefile                                   |    4 +-
 kernel/exit.c                                     |    4 +-
 kernel/hw_breakpoint.c                            |   75 +-
 kernel/irq_work.c                                 |  164 ++
 kernel/jump_label.c                               |  429 ++++
 kernel/kprobes.c                                  |   26 +-
 kernel/module.c                                   |    6 +
 kernel/perf_event.c                               | 2672 ++++++++++++---------
 kernel/sched.c                                    |    2 +-
 kernel/test_kprobes.c                             |   12 +-
 kernel/timer.c                                    |    7 +-
 kernel/trace/Kconfig                              |    5 +
 kernel/trace/ftrace.c                             |  127 +-
 kernel/trace/ring_buffer.c                        |   21 +-
 kernel/trace/trace.c                              |    2 +-
 kernel/trace/trace.h                              |    4 +
 kernel/trace/trace_event_perf.c                   |   28 +-
 kernel/trace/trace_events.c                       |   55 +-
 kernel/trace/trace_functions_graph.c              |  209 ++-
 kernel/trace/trace_irqsoff.c                      |  152 +-
 kernel/trace/trace_sched_wakeup.c                 |  256 ++-
 kernel/trace/trace_workqueue.c                    |   10 +-
 kernel/tracepoint.c                               |   14 +-
 kernel/watchdog.c                                 |   41 +-
 lib/Kconfig.debug                                 |    8 +-
 lib/dynamic_debug.c                               |   42 +-
 net/core/datagram.c                               |    1 +
 net/core/dev.c                                    |    8 +
 net/core/net-traces.c                             |    1 +
 net/core/skbuff.c                                 |    1 +
 scripts/Makefile                                  |    1 +
 scripts/Makefile.build                            |   10 +
 scripts/Makefile.lib                              |   11 +-
 scripts/basic/Makefile                            |    2 +-
 scripts/basic/hash.c                              |   64 -
 scripts/gcc-goto.sh                               |    5 +
 scripts/recordmcount.c                            |  363 +++
 scripts/recordmcount.h                            |  366 +++
 tools/perf/Documentation/perf-annotate.txt        |   11 +-
 tools/perf/Documentation/perf-report.txt          |    7 +
 tools/perf/Makefile                               |   30 +-
 tools/perf/builtin-annotate.c                     |   26 +-
 tools/perf/builtin-report.c                       |   14 +-
 tools/perf/feature-tests.mak                      |   11 +
 tools/perf/scripts/python/bin/netdev-times-record |    8 +
 tools/perf/scripts/python/bin/netdev-times-report |    5 +
 tools/perf/scripts/python/netdev-times.py         |  464 ++++
 tools/perf/util/cache.h                           |    2 +
 tools/perf/util/callchain.c                       |   98 +-
 tools/perf/util/callchain.h                       |   27 +-
 tools/perf/util/hist.c                            |    4 +-
 tools/perf/util/path.c                            |    3 +-
 tools/perf/util/sort.h                            |    2 +-
 tools/perf/util/symbol.c                          |   14 +
 tools/perf/util/symbol.h                          |    1 +
 tools/perf/util/ui/browser.c                      |  117 +-
 tools/perf/util/ui/browser.h                      |    9 +-
 tools/perf/util/ui/browsers/annotate.c            |   38 +-
 tools/perf/util/ui/browsers/hists.c               |  327 ++-
 tools/perf/util/ui/browsers/map.c                 |   32 +-
 tools/perf/util/ui/util.c                         |    4 +-
 tools/perf/util/util.h                            |   13 -
 158 files changed, 7202 insertions(+), 3408 deletions(-)
 delete mode 100644 arch/frv/lib/perf_event.c
 delete mode 100644 arch/sh/oprofile/op_impl.h
 create mode 100644 arch/sparc/include/asm/jump_label.h
 create mode 100644 arch/sparc/kernel/jump_label.c
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/irq_work.c
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 drivers/oprofile/oprofile_perf.c
 create mode 100644 include/linux/irq_work.h
 create mode 100644 include/linux/jump_label.h
 create mode 100644 include/linux/jump_label_ref.h
 create mode 100644 include/trace/events/net.h
 create mode 100644 kernel/irq_work.c
 create mode 100644 kernel/jump_label.c
 delete mode 100644 scripts/basic/hash.c
 create mode 100644 scripts/gcc-goto.sh
 create mode 100644 scripts/recordmcount.c
 create mode 100644 scripts/recordmcount.h
 create mode 100644 tools/perf/scripts/python/bin/netdev-times-record
 create mode 100644 tools/perf/scripts/python/bin/netdev-times-report
 create mode 100644 tools/perf/scripts/python/netdev-times.py

 [ full patch snipped due to lkml size limits ]
