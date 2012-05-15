Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2EOICL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:02:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54544 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766Ab2EOICI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
Date: Tue, 15 May 2012 10:02:06 +0200
Message-ID: <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org
Cc: paulmck@linux.vnet.ibm.com, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 May 2012 18:16, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> This is a request-for-participation in a micro conference during the
> next Linux Plumber Conference (29-31st Aug).
> It'll require critical mass measured in talk submissions in the
> general area of scheduler and task management.
>
>
> If you have ongoing work or ideas in the the following areas we're
> especially interested in hearing from you:
>  1. Consolidation of statistics with other frameworks (cpuidle,
> cpufreq, scheduler all seem to track their own statistics related to
> load, idleness, etc. Can this be converted to a library that is
> useable by all?)
>  2. Replacement for task consolidation on fewer CPUs aka. replacement
> for sched_mc

Peter,

Would you like to present the ongoing work around the load balance
policy and the replacement for sched_mc during the scheduler
micro-conf ?

Regards,
Vincent
