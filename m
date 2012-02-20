Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2BTVZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:25:48 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41067 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753741Ab2BTVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:25:47 -0500
Date: Mon, 20 Feb 2012 16:25:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        tiwg@multicore-association.org
Subject: [RELEASE] LTTng 2.0 Release Candidates
Message-ID: <20120220212544.GA11708@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:22:16 up 454 days,  2:25,  6 users,  load average: 0.12, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a highly efficient
full system tracing solution toolchain. It is composed of several
components to allow tracing of the kernel, of userspace, trace viewing
and analysis and trace streaming. LTTng is open source software.

The LTTng toolchain is now entering Release Candidate cycle, which
means that we commit to stable APIs and ABIs (no breakage,
extension-only) across the entire 2.x series, and feature-freeze (no
extension) for the 2.0 series.

We plan to release LTTng 2.0 final on March 20, 2012.

For the entire RC time-frame the latest packages under section "Download
Toolchain Source Packages" from the following URL should be used:

  http://lttng.org/lttng2.0

As a side-note, the babeltrace project, used for viewing/parsing CTF
traces, is entering its prerelease cycle, with version 1.0.0-pre1.

Project website: http://lttng.org
Download link: http://lttng.org/lttng2.0
(please refer to the README files for installation instructions and
lttng-tools doc/quickstart.txt for usage information)

Key Features:

- Efficient synchronized User-space and Kernel tracing using the same
  time-source provides view of correlated kernel and user-space events.
- LTTng 2.0 kernel modules build against a vanilla or distribution
  kernel, without need for additional patches,
- Tracepoints, detailed syscall tracing (fast strace replacement),
  CPU Performance Monitoring Unit (PMU) counters, dynamic address/symbol
  probing (kprobes) and function call/return tracing (kretprobes support),
- Have the ability to attach "context" information to events in the
  trace (e.g. any PMU counter, pid, ppid, tid, comm name, etc).
  All the extra information fields to be collected with events are
  optional, specified on a per-tracing-session basis (except for
  timestamp and event id, which are mandatory).
- Allows non-root users part of the "tracing" group to perform kernel
  and userspace tracing.
- Allows multiple tracing sessions to be active concurrently, each with
  its own instrumentation set.
- Integrated interface for both kernel and userspace tracing,
- Produces CTF (Common Trace Format) natively,
  (http://www.efficios.com/ctf)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
