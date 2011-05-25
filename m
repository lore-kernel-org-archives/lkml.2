Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab1EYQGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:06:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:38753 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab1EYQGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:06:21 -0400
Date: Wed, 25 May 2011 18:06:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Lindgren <tony@atomide.com>
cc: Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
In-Reply-To: <20110525153459.GE27250@atomide.com>
Message-ID: <alpine.LFD.2.02.1105251803120.3078@ionos>
References: <201105181047.17309.arnd@arndb.de> <BANLkTi=xzrLhHTBynWf4huA9EusfaDwPbA@mail.gmail.com> <20110525075902.GH30799@atomide.com> <alpine.LFD.2.00.1105251021550.3207@xanadu.home> <20110525153459.GE27250@atomide.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Tony Lindgren wrote:
> * Nicolas Pitre <nico@fluxnic.net> [110525 07:24]:
> > 
> > No.  We'll start merging stuff once this merge window is over.  In other 
> > words, you are still on your own for the current one.
> 
> OK
>  
> > Also, I want stuff merged in this subarch tree way before the next merge 
> > window opens on a continuous basis, not in a big rush before it opens, 
> > or worse, while it is already open.
> 
> OK that sounds good to me. There's at least one more thing to sort out
> though:
> 
> What do you want to do with with the various for-next branches?
> 
> Do you want to queue things into your tree before hitting for-next?

The stuff which gets pulled in from the various suppliers is
aggregated in a separate for -next branch.

Thanks,

	tglx
