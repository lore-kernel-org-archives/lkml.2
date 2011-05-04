Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1EDXv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:51:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:32836 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab1EDXv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:51:56 -0400
Date: Thu, 5 May 2011 01:51:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Dave Kleikamp <dkleikamp@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, paulmck@us.ibm.com
Subject: Re: idle issues running sembench on 128 cpus
In-Reply-To: <m2liymyqjt.fsf@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1105050150360.3005@ionos>
References: <4DC1C95B.4040706@gmail.com> <m2pqnyyva8.fsf@firstfloor.org> <alpine.LFD.2.02.1105050023070.3005@ionos> <20110504230349.GC2925@one.firstfloor.org> <alpine.LFD.2.02.1105050110440.3005@ionos> <20110504234241.GD2925@one.firstfloor.org>
 <alpine.LFD.2.02.1105050144030.3005@ionos> <m2liymyqjt.fsf@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Andi Kleen wrote:

> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > On Thu, 5 May 2011, Andi Kleen wrote:
> >> On Thu, May 05, 2011 at 01:29:49AM +0200, Thomas Gleixner wrote:
> >> > That makes sense, but merging the timeouts race free will be a real
> >> > PITA.
> >> 
> >> For this case one could actually use a spinlock between the siblings.
> >> That shouldn't be a problem as long as it's not a global spinlock.
> >
> > Care to give it a try ?
> 
> Ok, will try tomorrow.
> 
> >> Here's a new patch without the raw. Boots on my Westmere.
> >
> >> +	cpu = raw_smp_processor_id();
> >
> > Hmm. quilt refresh perhaps ? I know that feeling :)
> 
> The scp to copy the patch was too slow. Noticed it later and sent a new
> one.

NP. Happens to hit everybody from time to time :)

Thanks,

	tglx
