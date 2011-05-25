Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1EYPfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:35:07 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:34261 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754890Ab1EYPfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:35:06 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+KWaNfVGc73Hd2zdz2IbFG
Date: Wed, 25 May 2011 08:34:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Message-ID: <20110525153459.GE27250@atomide.com>
References: <201105181047.17309.arnd@arndb.de>
 <BANLkTi=xzrLhHTBynWf4huA9EusfaDwPbA@mail.gmail.com>
 <20110525075902.GH30799@atomide.com>
 <alpine.LFD.2.00.1105251021550.3207@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1105251021550.3207@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre <nico@fluxnic.net> [110525 07:24]:
> 
> No.  We'll start merging stuff once this merge window is over.  In other 
> words, you are still on your own for the current one.

OK
 
> Also, I want stuff merged in this subarch tree way before the next merge 
> window opens on a continuous basis, not in a big rush before it opens, 
> or worse, while it is already open.

OK that sounds good to me. There's at least one more thing to sort out
though:

What do you want to do with with the various for-next branches?

Do you want to queue things into your tree before hitting for-next?

Tony
