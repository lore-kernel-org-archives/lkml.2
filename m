Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0J3OQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:16:49 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51131 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751142Ab0J3OQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:16:47 -0400
Date: Sat, 30 Oct 2010 10:16:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: loic.minier@canonical.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Steve Langasek <steve.langasek@canonical.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: LTTng Mainlining Roadmap
Message-ID: <20101030141644.GA17206@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:55:11 up 37 days, 17:57,  4 users,  load average: 0.13, 0.14,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Here is an updated roadmap for the LTTng mainlining. As you will notice, the
plan is not exactly to push the LTTng code into the Linux kernel as is, but
rather to extract LTTng pieces one by one (it's already modular, so it is quite
straightforward) and push them to mainline as individual pieces.

This is the approach I have taken for the Tracepoints, which led to very good
results. I plan to do the same for the Generic Ring Buffer Library, Trace
Clocks, kernel state dump... these can all be splitted into serparate mainlining
efforts.

The new official URL for the LTTng roadmap is:

http://lttng.org/roadmap

FYI, I fixed the ARM PMU reservation in LTTng yesterday afternoon and made a new
release. So it should now play along nicely with perf counters.

Feedback is welcome,

Thanks!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
