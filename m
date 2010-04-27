Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0D0QMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:12:19 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:57052 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab0D0QMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:12:16 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX183SHg4H8GsupjbpEbHFV16
Date: Tue, 27 Apr 2010 09:12:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] omap fixes for v2.6.34-rc5
Message-ID: <20100427161217.GB7225@atomide.com>
References: <20100426190005.GJ7225@atomide.com>
 <alpine.LFD.2.00.1004270831430.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004270831430.3739@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [100427 08:28]:
> 
> On Mon, 26 Apr 2010, Tony Lindgren wrote:
> > 
> > Please pull omap fixes from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus
> 
> I pulled it this time, but I'm starting to get really irritated with you.
> 
> These look like real fixes, but quite frankly, by -rc5, that IS NOT 
> ENOUGH. 
> 
> They need to be _regressions_, not just cleanups and fixes for things that 
> have never worked. And this is starting to be a pattern with the omap 
> tree: you're not honoring the merge window properly.
> 
> Just "it's a bug-fix" or "it's deleting unused code" is not enough. The 
> point of the late -rc series is to fix problems from the merge window, not 
> add new changes. I realize that you think that all the new changes are 
> obviously good, but the fact is, bugs happen even in "obvious bug-fixes". 
> 
> And that's why we have the rule about late-rc pulls being about 
> _regressions_ and/or major oopses/security issues. Not just random 
> development that are meant to improve things.

OK point taken. I should have dealt with this earlier. Will only queue
regressions after -rc3 or so.

Regards,

Tony
