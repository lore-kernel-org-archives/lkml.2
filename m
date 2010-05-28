Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0E1NjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:39:25 -0400
Received: from thunk.org ([69.25.196.29]:38484 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab0E1NjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:39:23 -0400
Date: Fri, 28 May 2010 09:39:00 -0400
From: tytso@mit.edu
To: Igor Stoppa <igor.stoppa@nokia.com>
Cc: ext Brian Swetland <swetland@google.com>,
       ext Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528133900.GG26177@thunk.org>
Mail-Followup-To: tytso@mit.edu, Igor Stoppa <igor.stoppa@nokia.com>,
	ext Brian Swetland <swetland@google.com>,
	ext Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Florian Mickler <florian@mickler.org>,
	Linux PM <linux-pm@lists.linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
	"Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
References: <20100527220949.GB10602@srcf.ucam.org>
 <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
 <20100527223605.GB11364@srcf.ucam.org>
 <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
 <20100528043114.GC26177@thunk.org>
 <20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
 <20100528114123.GA22947@srcf.ucam.org>
 <4BFFB681.1000105@nokia.com>
 <AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
 <4BFFC5DF.5030504@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFFC5DF.5030504@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 04:32:15PM +0300, Igor Stoppa wrote:
> 
> What I consider plain wrong i to claim that since there are this
> many units out, some code should be merged.
> A company needs to cut corners sometimes when making a product but
> this should not affect upstream code.

Linus will disagree with you there.  Linus *has* merged code on the
basis that it is shipping in distributions, regardless of the fact
that some developers objected to it.  Sometimes "perfect" should not
be the enemy of "good enough" shipping code.

For example, I used to point out that we shipped PCMCIA code in
mainline that had a 10% chance of crashing the system if you ejected
the card.  NetBSD was proud to say that their code was so iron-clad
and well designed that it always did the right thing, even if you
ejected while it was busily passing network traffic.  Unfortunately,
NetBSD had working PCMCIA support 3 years later than Linux.  So it
used to be that we were the technical pragmatists (and Linus
fortunately, still very much is the pragmatists, while others were the
hard-line perfectionists.  It seems to me we've started getting some
of the NetBSD attitude infecting LKML, and IMHO, that's unfortunate.

We've rewritten our networking stack, 3 or 4 times, depending on how
you count.  And sometimes shipping in products counts for a lot.  It
doesn't count for everything, and it isn't a get-out-of-jail card, for
sure.  But if it's a hard problem, and we have something that's good
enough, maybe the right call is to merge it now, and we'll rework
things to make something better and more general later.  Ultimately
that's a call only Linus can make.

If everyone agrees we're making progress, and we can let this 100+
mail thread keep going.  But if anyone feels that we are spinning
endlessly without making forward progress (which is after all the same
criteria the OOM killer uses, no? :-), people should remember that
sometimes Linus *has* ended arguments that have gone on too long by
making a "merge or kill" decision.

						- Ted
