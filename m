Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1I3QIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:08:34 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45669 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752176Ab1I3QId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:08:33 -0400
Date: Fri, 30 Sep 2011 12:08:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 2.0 prerelease bundle 20110930
Message-ID: <20110930160830.GA1658@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:57:57 up 310 days, 21:01,  6 users,  load average: 0.75, 1.14,
	1.14
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
- Tracepoints, detailed syscall tracing (fast strace replacement),
  Function tracer, CPU Performance Monitoring Unit (PMU) counters and
  kprobes support,
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

You can get a the current release "bundle" (recommanded set of packages)
at the following URL:

http://lttng.org/bundles/

Project website: http://lttng.org
Download link: http://lttng.org/lttng2.0
(please refer to the README files for installation instructions and
lttng-tools doc/quickstart.txt for usage information)

A notable addition to this new bundle is support for detailed system
call tracing for x86-32 and x86-64.

Please contact the ltt-dev@lists.casi.polymtl.ca mailing list if you
have questions. I will be on vacation from Oct. 1st 2011 to Oct. 16th,
2011, which will delay answer to emails.

Enjoy!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
