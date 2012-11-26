Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2KZTE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:04:56 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38462 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab2KZTEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:04:54 -0500
Date: Mon, 26 Nov 2012 11:03:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, pjt@google.com,
        paul.mckenney@linaro.org, tglx@linutronix.de, tj@kernel.org,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH V2 Resend 0/4] Create sched_select_cpu() and use it for
 workqueues and timers
Message-ID: <20121126190354.GJ2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1352196505.git.viresh.kumar@linaro.org>
 <CAKohponTxs983vVQV=6Q8zyesC1W1FhFkzfmpAVeEwU-cQXohA@mail.gmail.com>
 <1353948027.6276.38.camel@gandalf.local.home>
 <20121126170358.GE2474@linux.vnet.ibm.com>
 <1353951352.6276.43.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353951352.6276.43.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112619-7182-0000-0000-00000359FCF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 12:35:52PM -0500, Steven Rostedt wrote:
> On Mon, 2012-11-26 at 09:03 -0800, Paul E. McKenney wrote:
> 
> 
> > If I understand correctly (though also suffering turkey OD), the idea is
> > to offload work to more energy-efficient CPUs.
> 
> This is determined by a CPU that isn't running the idle task? Is it
> because a CPU that just woke up may be running at a lower freq, and thus
> not as efficient? But pushing off to another CPU may cause cache misses
> as well. Wouldn't that also be a factor in efficiencies, if a CPU is
> stalled waiting for memory to be loaded?

Two different microarchitectures -- same instruction set (at user level,
anyway), but different power/performance characteristics.  One set is
optimized for performance, the other for energy efficiency.  For example,
ARM's big.LITTLE architecture.

> I should also ask the obvious. Has these patches shown real world
> efficiencies or is this just a theory? Do these patches actually improve
> battery life when applied?

I must defer to Viresh on this one.

							Thanx, Paul

> Just asking.
> 
> -- Steve
> 
> 

