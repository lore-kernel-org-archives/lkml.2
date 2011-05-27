Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1E0LE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 07:04:26 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:14764 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511Ab1E0LEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 07:04:25 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/crxpDjWr05auoRi5Z/yG7
Date: Fri, 27 May 2011 14:04:19 +0300
From: Tony Lindgren <tony@atomide.com>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap updates for 2.6.40
Message-ID: <20110527110416.GG27962@atomide.com>
References: <20110526113905.GG27250@atomide.com>
 <9741DC43-3197-4ECE-A377-FA865A3F6710@dominion.thruhere.net>
 <20110527063304.GA27962@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527063304.GA27962@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [110527 09:29]:
> * Koen Kooi <koen@dominion.thruhere.net> [110526 19:02]:
> > 
> > Op 26 mei 2011, om 13:39 heeft Tony Lindgren het volgende geschreven:
> > 
> > > Hi Linus,
> > > 
> > > Please pull omap updates for this merge window from:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus
> > > 
> > > This contains clean-up to shrink down omap specific code a bit. Also included
> > > are some fixes. But basically no new code at this point.
> > 
> > What about updates to board files? Like adding support for the xM rev C to board-omap3beagle.c.
> 
> Sorry we're doing only code coalescing and fixes for this merge window as
> discussed on LAKML. Otherwise it's hard to see the code coalescing in the
> diffstats, so new code will need to wait a bit.
> 
> I'll take a look and see if we can justify some fix like trivial patches
> like the revision detection patches during the -rc cycle.

Koen, the patch above needs to be refreshed to apply to current mainline
kernel. It also seems to contain some whitespace errors.

Care to refresh it and repost?

Thanks,

Tony
