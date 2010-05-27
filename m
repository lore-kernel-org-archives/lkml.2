Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab0E0FLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:11:11 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60507 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab0E0FLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:11:08 -0400
Date: Thu, 27 May 2010 07:11:00 +0200
From: Florian Mickler <florian@mickler.org>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527071100.3a38bbac@schatten.dmk.lab>
In-Reply-To: <AANLkTil3OdarNjeIuzWqM59x4ysFqJrMeiUZzceC_r7P@mail.gmail.com>
References: <20100526171106.0e44a736@schatten.dmk.lab>
	<alpine.LFD.2.00.1005261829540.2995@localhost.localdomain>
	<20100526190204.5efe4d59@lxorguk.ukuu.org.uk>
	<20100526215606.2a747c61@schatten.dmk.lab>
	<AANLkTil3OdarNjeIuzWqM59x4ysFqJrMeiUZzceC_r7P@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 22:03:37 +0200
Vitaly Wool <vitalywool@gmail.com> wrote:

> On Wed, May 26, 2010 at 9:56 PM, Florian Mickler <florian@mickler.org> wrote:
> 
> > Your approach definitely sounds better than the current solution.
> > What about mapping suspend blocker functionality later on, when this
> > interface exists, on to this new approach and deprecating it?
> 
> What about coming back after some while with the appropriate solution
> when it's ready instead of stubbornly pushing crap?
> 
> ~Vitaly

Because quite frankly, for a good part of linux users, suspend blockers
is already in the kernel. It's just an historical mistake that they are
not in the linux kernel's hosted on kernel.org. 
So why don't we do what we always do? Improve existing interfaces step
by step? 

Top Down approaches fail from time to time. Also it is not clear, that
that proposed interface works for the use cases. This has to be proven
by providing an implementation. 

Cheers,
Flo
