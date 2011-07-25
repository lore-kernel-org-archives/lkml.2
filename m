Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab1GYR7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:59:33 -0400
Received: from mail.openrapids.net ([64.15.138.104]:38051 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153Ab1GYR7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:59:31 -0400
Date: Mon, 25 Jul 2011 13:59:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 2.0 prerelease 1
Message-ID: <20110725175927.GA6943@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:25:16 up 243 days, 22:28,  3 users,  load average: 0.02, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a highly efficient
full system tracing solution toolchain. It is composed of several
components to allow tracing of the kernel, of userspace, trace viewing
and analysis and trace streaming. LTTng is open source software.

New Features:

- LTTng 2.0 kernel modules build against a vanilla or distribution
  kernel, without need for additional patches.
- Produces CTF (Common Trace Format) natively,
  (http://www.efficios.com/ctf)
- Tracepoints, Function tracer, CPU Performance Monitoring Unit (PMU)
  counters and kprobes support,
- Integrated interface for both kernel and userspace tracing,
- Have the ability to attach "context" information to events in the
  trace (e.g. any PMU counter, pid, ppid, tid, comm name, etc).
  All the extra information fields to be collected with events are
  optional, specified on a per-tracing-session basis (except for
  timestamp and event id, which are mandatory).
- Allows non-root users part of the "tracing" group to perform kernel
  and userspace tracing.
- Allows multiple tracing sessions to be active concurrently, each with
  its own instrumentation set.

You can get a the current release "bundle" (recommanded set of packages)
at the following URL:

http://lttng.org/bundles/20110725/

Refer to the README files for installation instructions and lttng-tools
doc/quickstart.txt for usage information and examples.
(http://git.lttng.org/?p=lttng-tools.git;a=blob_plain;f=doc/quickstart.txt)

Please note that the LTTng-UST 2.0 (user-space tracing counterpart of
LTTng 2.0) is still in active development and not released yet. Only
text-dump output of the binary traces is available at this moment
through the Babeltrace tool (LTTV is not supported yet). Tracing from
the "tracing" group currently produces traces owned by "root"; this
known problem will be fixed in the next prerelease. This release has
been tested on vanilla Linux kernels, Debian kernels, Ubuntu kernels,
and Fedora kernels on the version range 2.6.38, 2.6.39 and 3.0 (on x86
32/64-bit, and powerpc 32-bit at the moment, build tested on ARM).

Feedback is welcome!

Thanks,

Mathieu

Project website: http://lttng.org
Download link: http://lttng.org/lttng2.0

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
