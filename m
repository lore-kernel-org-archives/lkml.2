Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0IUQ2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:28:03 -0400
Received: from www.tglx.de ([62.245.132.106]:52599 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab0IUQ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:28:01 -0400
Date: Tue, 21 Sep 2010 18:27:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andres Salomon <dilinger@queued.net>
cc: Ingo Molnar <mingo@elte.hu>, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com, Mitch Bradley <wmb@laptop.org>,
        linux-kernel@vger.kernel.org,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 2/2] x86: of: define irq functions to allow drivers/of/*
 to build on x86
In-Reply-To: <20100921091136.45f5f7fa@debxo>
Message-ID: <alpine.LFD.2.00.1009211826240.2416@localhost6.localdomain6>
References: <20100910060151.6613e9c3@debxo> <20100910172538.GC11284@angua.secretlab.ca> <20100910181458.GA7243@elte.hu> <20100910182135.GG11284@angua.secretlab.ca> <20100920190604.5a2118da@debxo> <alpine.LFD.2.00.1009211144070.2416@localhost6.localdomain6>
 <20100921091136.45f5f7fa@debxo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Andres Salomon wrote:
> On Tue, 21 Sep 2010 11:45:37 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > Any additional comments (ACKs, NACKs, etc) on the patches?  If I
> > > need to rework it (or them), I can certainly make the patch
> > > description longer.
> > 
> > Fine with me, but you could make the "mapping" function an inline as
> > well. While at it, some sensible changelog would be helpful :)
> > 
> > Thanks,
> > 
> > 	tglx
> 
> Hm, inlining it would require some additional x86 #ifdefs in
> include/linux/of_irq.h (where the mapping function is declared).  You'd
> prefer that?

Urgh, no.

      tglx

 
