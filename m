Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935312Ab0KQVz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:55:56 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:49672 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933027Ab0KQVzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:55:55 -0500
X-Greylist: delayed 1438 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2010 16:55:54 EST
Message-ID: <1290029498.4ce449ba1679d@www.imp.polymtl.ca>
Date: Wed, 17 Nov 2010 16:31:38 -0500
From: Douglas Santos <douglas.santos@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: ltt-dev@lists.casi.polymtl.ca, David Sharp <dhsharp@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>
Subject: Benchmarks of kernel tracing options 2 (ftrace, lttng and perf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.3
X-Originating-IP: 132.207.72.44
X-Poly-FromMTA: (imp-4-3.polymtl.ca [132.207.4.78]) at Wed, 17 Nov 2010 21:31:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a response to a benchmark, submitted a few weeks ago, comparing kernel
tracing options.
http://lkml.org/lkml/2010/10/28/422

We followed the methodology described in the link bellow,
but using the shellscripts posted there to reproduce autotest scripts.
http://lkml.org/lkml/2010/10/28/261

We disabled the extra syscall tracing on lttng, for a fair comparison.
http://lkml.org/lkml/2010/10/28/290

Average results with tracing "on":

lttng:  220 ns
ftrace: 260 ns
perf:   740 ns


E5405 system
kernel 2.6.36

-lttng 0.239 + 0.19.2modules + sys_getuid tracepoint + sys_getuid probe
 + remove syscall_trace

-ftrace and perf + sys_getuid tracepoint

