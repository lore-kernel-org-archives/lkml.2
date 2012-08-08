Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2HHLEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:04:21 -0400
Received: from mail.x86-64.org ([217.9.48.20]:40797 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab2HHLES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:04:18 -0400
Date: Wed, 8 Aug 2012 13:04:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, mingo@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: do_IRQ: 1.55 No irq handler for vector (irq -1)
Message-ID: <20120808110414.GB16636@aftab.osrc.amd.com>
References: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
 <tip-332afa656e76458ee9cf0f0d123016a0658539e4@git.kernel.org>
 <20120807153149.GI3732@erda.amd.com>
 <20120807154134.GA7456@aftab.osrc.amd.com>
 <1344356662.2041.48.camel@sbsiddha-desk.sc.intel.com>
 <87pq72a951.fsf@xmission.com>
 <20120807205717.GC11226@aftab.osrc.amd.com>
 <1344379147.27383.29.camel@sbsiddha-desk.sc.intel.com>
 <20120808085837.GL3732@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808085837.GL3732@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 10:58:37AM +0200, Robert Richter wrote:
> On 07.08.12 15:39:07, Suresh Siddha wrote:
> > Boris, Robert, can you check if the below patch makes both of your
> > systems happy again (essentially not allowing the vector to change for
> > legacy irq's, which also allows the RTE to be set correctly in the smp
> > case etc)? Based on your results and some more thinking, I will send a
> > detailed patch with changelog tomorrow.
> > 
> >  arch/x86/kernel/apic/io_apic.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> Suresh,
> 
> with your patch applied the sata device works fine and the system
> boots, no issues seen.

Ditto,

the do_IRQ issue of missing an irq handler for vector 55 is gone too on
my box.

I'm pretty sure you can add our Tested-by:'s to the official patch.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
