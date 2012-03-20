Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab2CTW6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:58:11 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58623 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759266Ab2CTW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:58:09 -0400
Date: Tue, 20 Mar 2012 18:58:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Cc: Jake Edge <jake@lwn.net>
Subject: [RELEASE] LTTng 2.0 stable
Message-ID: <20120320225806.GA4452@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:41:02 up 483 days,  3:44,  6 users,  load average: 0.18, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello World,

We proudly announce the first stable release of LTTng 2.0, after 2 years
R&D from the LTTng team. As always, we warmly welcome feedback, comments
and ideas from our large user community, already familiar with the 0.x
versions. LTTng 2.0 will be in the upcoming Ubuntu 12.04 LTS.

Some will be pleased to notice the new version names, describing the
best Quebec beer brews we have tasted.

LTTng, the Linux Trace Toolkit Next Generation, is a highly efficient
full system tracing solution toolchain. It is composed of several
components to allow tracing of the kernel, of userspace, for combined
trace viewing and analysis. LTTng is open source software.

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

Changelog:

- Please refer to the individual project Changelog files for details.

Project website: http://lttng.org
Download link: http://lttng.org/download
(please refer to the README files for installation instructions and
lttng-tools doc/quickstart.txt for usage information)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
