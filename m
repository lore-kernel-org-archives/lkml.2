Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0E0Nfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:35:41 -0400
Received: from www.tglx.de ([62.245.132.106]:54298 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab0E0Nfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:35:39 -0400
Date: Thu, 27 May 2010 15:35:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Mickler <florian@mickler.org>
cc: Vitaly Wool <vitalywool@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527071100.3a38bbac@schatten.dmk.lab>
Message-ID: <alpine.LFD.2.00.1005271530240.3032@localhost.localdomain>
References: <20100526171106.0e44a736@schatten.dmk.lab> <alpine.LFD.2.00.1005261829540.2995@localhost.localdomain> <20100526190204.5efe4d59@lxorguk.ukuu.org.uk> <20100526215606.2a747c61@schatten.dmk.lab> <AANLkTil3OdarNjeIuzWqM59x4ysFqJrMeiUZzceC_r7P@mail.gmail.com>
 <20100527071100.3a38bbac@schatten.dmk.lab>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Florian Mickler wrote:

> On Wed, 26 May 2010 22:03:37 +0200
> Vitaly Wool <vitalywool@gmail.com> wrote:
> 
> > On Wed, May 26, 2010 at 9:56 PM, Florian Mickler <florian@mickler.org> wrote:
> > 
> > > Your approach definitely sounds better than the current solution.
> > > What about mapping suspend blocker functionality later on, when this
> > > interface exists, on to this new approach and deprecating it?
> > 
> > What about coming back after some while with the appropriate solution
> > when it's ready instead of stubbornly pushing crap?
> > 
> > ~Vitaly
> 
> Because quite frankly, for a good part of linux users, suspend blockers
> is already in the kernel. It's just an historical mistake that they are
> not in the linux kernel's hosted on kernel.org. 

No, it's not a historical mistake. It's a technical decision _NOT_ to
merge crap. If we would accept every crappy patch which gets shipped
in large quantities as a defacto part of the kernel we would have a
completely unmaintainable mess since years.

> So why don't we do what we always do? Improve existing interfaces step
> by step? 

Exactly, that's what we are going to do. We improve and extend
existing interfaces step by step, but not by creating a horrible and
unmaintainable mess in the frist place which we can never get rid of
anymore.

> Top Down approaches fail from time to time. Also it is not clear, that
> that proposed interface works for the use cases. This has to be proven
> by providing an implementation. 

Nobody prevents you to sit down and start with a prove of concept
implementation.

Thanks,

	tglx
