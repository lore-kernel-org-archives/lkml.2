Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783Ab2EKQ1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:27:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15811 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932Ab2EKQ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:26:59 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=15HzAesF1WAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=HEwoa2qr2k38QsvW2pIA:9 a=hVD4OWBw5Fj9b9YfMG8A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336753616.14207.258.camel@gandalf.stny.rr.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Juri Lelli <juri.lelli@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com, peterz@infradead.org,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, tglx@linutronix.de,
        amit.kucheria@linaro.org, linux-kernel@vger.kernel.org,
        linaro-sched-sig@lists.linaro.org
Date: Fri, 11 May 2012 12:26:56 -0400
In-Reply-To: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not really specific to HW, but Juri Lelli has been working on a deadline
scheduler. Perhaps his work may be of interest.

-- Steve


On Fri, 2012-05-11 at 18:16 +0200, Vincent Guittot wrote:
> This is a request-for-participation in a micro conference during the
> next Linux Plumber Conference (29-31st Aug).
> It'll require critical mass measured in talk submissions in the
> general area of scheduler and task management.
> 
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


