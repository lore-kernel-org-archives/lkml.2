Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab2EOAyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:54:04 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57357 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab2EOAyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:54:02 -0400
Date: Mon, 14 May 2012 17:53:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: smuckle@quicinc.com, khilman@ti.com, Robin.Randhawa@arm.com,
        suresh.b.siddha@intel.com, thebigcorporation@gmail.com,
        venki@google.com, peterz@infradead.org, panto@antoniou-consulting.com,
        mingo@elte.hu, paul.brett@intel.com, pdeschrijver@nvidia.com,
        pjt@google.com, efault@gmx.de, fweisbec@gmail.com, geoff@infradead.org,
        rostedt@goodmis.org, tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel@vger.kernel.org, linaro-sched-sig@lists.linaro.org
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Message-ID: <20120515005303.GA9729@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051500-1780-0000-0000-000005944998
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000275; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00139233; UDB=6.00032302; UTC=2012-05-15
 00:53:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 06:16:21PM +0200, Vincent Guittot wrote:
> This is a request-for-participation in a micro conference during the
> next Linux Plumber Conference (29-31st Aug).
> It'll require critical mass measured in talk submissions in the
> general area of scheduler and task management.

Hello, Vincent,

I still cannot claim any particular scheduler expertise, but would be
happy to act as moderator, if you would like.

							Thanx, Paul

> If you're working on improving the the scheduler policy used to place
> a task on a CPU to suit your HW, we are inviting your participation
> and request you to submit a proposal to present your problem (e.g.
> power-efficiency) or a solution to solve said problem that should be
> considered by upstream developers.
> 
> We've interacted with the people in To: list before in our quest to
> better understand how the scheduler works and we're hoping you all
> will consider participating in the micro-conf to help guide what kinds
> of ideas are likely to make it upstream.
> 
> If you have ongoing work or ideas in the the following areas we're
> especially interested in hearing from you:
>  1. Consolidation of statistics with other frameworks (cpuidle,
> cpufreq, scheduler all seem to track their own statistics related to
> load, idleness, etc. Can this be converted to a library that is
> useable by all?)
>  2. Replacement for task consolidation on fewer CPUs aka. replacement
> for sched_mc
>  3. Improvement in the placement of activity beside tasks: timer,
> workqueue, IO, interruption
>  4. Instrumentation to calculate the compute capacity available on
> active cores and its utilization by a given workload
> 
> We are thinking of organising the micro-conf as a Q & A session where
> a participant would state a problem and then there would be
> brainstorming on if this is indeed a problem and is so, how to achieve
> a solution. In other words, 20-30 minute slots of each Q & A
> 
> 1. Problem statements with specific examples on why changing the
> default scheduler policy is desired
> 2. For each problem, if it is deemed not possible to accomplish easily
> today, brainstorming on what an acceptable solution would look like
> (frameworks to build upon, interfaces to use, related work in the
> area, key people to involve, etc.)
> 
> Please email us if you will be attending the conference and interested
> in talking about this problem space.
> 
> Regards,
> Amit & Vincent
> 

