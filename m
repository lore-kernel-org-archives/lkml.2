Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2HUPT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:19:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54181 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab2HUPTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:19:21 -0400
Date: Tue, 21 Aug 2012 17:19:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120821151910.GA5359@gmail.com>
References: <1345028738.31459.82.camel@twins>
 <502BA7DC.7060907@linux.intel.com>
 <1345041548.31459.90.camel@twins>
 <502BB5A3.5000403@linux.intel.com>
 <1345043096.31459.106.camel@twins>
 <502BE38D.9030405@linux.intel.com>
 <20120820080606.GA6931@gmail.com>
 <20120820181651.GA737@srcf.ucam.org>
 <20120821094203.GB12385@gmail.com>
 <20120821113951.GA22436@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821113951.GA22436@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Tue, Aug 21, 2012 at 11:42:04AM +0200, Ingo Molnar wrote:
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > [...] Putting this kind of policy in the kernel is an awful 
> > > idea. [...]
> > 
> > A modern kernel better know what state the system is in: on 
> > battery or on AC power.
> 
> That's a fundamentally uninteresting thing for the kernel to 
> know about. [...]

I disagree.

> [...] AC/battery is just not an important power management 
> policy input when compared to various other things.

Such as?

The thing is, when I use Linux on a laptop then AC/battery is 
*the* main policy input.

> > > [...] It should never be altering policy itself, [...]
> > 
> > The kernel/scheduler simply offers sensible defaults where 
> > it can. User-space can augment/modify/override that in any 
> > which way it wishes to.
> >
> > This stuff has not been properly sorted out in the last 10+ 
> > years since we have battery driven devices, so we might as 
> > well start with the kernel offering sane default behavior 
> > where it can ...
> 
> Userspace has been doing a perfectly reasonable job of 
> determining policy here.

Has it properly switched the scheduler's balancing between 
power-effient and performance-maximizing strategies when for 
example a laptop's AC got unplugged/replugged?

> > > [...] because it'll get it wrong and people will file bugs 
> > > complaining that it got it wrong and the biggest case 
> > > where you *need* to be able to handle switching between 
> > > performance and power optimisations (your rack management 
> > > unit just told you that you're going to have to drop power 
> > > consumption by 20W) is one where the kernel doesn't have 
> > > all the information it needs to do this. So why bother at 
> > > all?
> > 
> > The point is to have a working default mechanism.
> 
> Your suggestions aren't a working default mechanism.

In what way?

Thanks,

	Ingo
