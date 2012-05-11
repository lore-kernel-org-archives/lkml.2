Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475Ab2EKQQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:16:24 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61753 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab2EKQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:16:22 -0400
MIME-Version: 1.0
Date: Fri, 11 May 2012 18:16:21 +0200
Message-ID: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
Subject: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Vincent Guittot <vincent.guittot@linaro.org>
To: paulmck@linux.vnet.ibm.com, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com, peterz@infradead.org,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, amit.kucheria@linaro.org
Cc: linux-kernel@vger.kernel.org, linaro-sched-sig@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a request-for-participation in a micro conference during the
next Linux Plumber Conference (29-31st Aug).
It'll require critical mass measured in talk submissions in the
general area of scheduler and task management.

If you're working on improving the the scheduler policy used to place
a task on a CPU to suit your HW, we are inviting your participation
and request you to submit a proposal to present your problem (e.g.
power-efficiency) or a solution to solve said problem that should be
considered by upstream developers.

We've interacted with the people in To: list before in our quest to
better understand how the scheduler works and we're hoping you all
will consider participating in the micro-conf to help guide what kinds
of ideas are likely to make it upstream.

If you have ongoing work or ideas in the the following areas we're
especially interested in hearing from you:
 1. Consolidation of statistics with other frameworks (cpuidle,
cpufreq, scheduler all seem to track their own statistics related to
load, idleness, etc. Can this be converted to a library that is
useable by all?)
 2. Replacement for task consolidation on fewer CPUs aka. replacement
for sched_mc
 3. Improvement in the placement of activity beside tasks: timer,
workqueue, IO, interruption
 4. Instrumentation to calculate the compute capacity available on
active cores and its utilization by a given workload

We are thinking of organising the micro-conf as a Q & A session where
a participant would state a problem and then there would be
brainstorming on if this is indeed a problem and is so, how to achieve
a solution. In other words, 20-30 minute slots of each Q & A

1. Problem statements with specific examples on why changing the
default scheduler policy is desired
2. For each problem, if it is deemed not possible to accomplish easily
today, brainstorming on what an acceptable solution would look like
(frameworks to build upon, interfaces to use, related work in the
area, key people to involve, etc.)

Please email us if you will be attending the conference and interested
in talking about this problem space.

Regards,
Amit & Vincent
