Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab2BJAvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:51:43 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48070 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752843Ab2BJAvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:51:42 -0500
Date: Thu, 9 Feb 2012 19:51:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: [RELEASE] LTTng 2.0 prerelease bundle 20120209
Message-ID: <20120210005139.GB10613@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:49:12 up 443 days,  5:52,  1 user,  load average: 0.01, 0.08,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a highly efficient
full system tracing solution toolchain. It is composed of several
components to allow tracing of the kernel, of userspace, trace viewing
and analysis and trace streaming. LTTng is open source software.

You can get a the current release "bundle" (recommanded set of packages)
at the following URL:

http://lttng.org/bundles/

Project website: http://lttng.org
Download link: http://lttng.org/lttng2.0
(please refer to the README files for installation instructions and
lttng-tools doc/quickstart.txt for usage information)

Key Features:

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
