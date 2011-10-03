Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab1JCRqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:46:21 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21572 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756159Ab1JCRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:46:15 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/uR3Vc7RPevvXcjcXFrviS
Date: Mon, 3 Oct 2011 10:46:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Bjarne Steinsbo <bsteinsbo@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/30] ARM: omap: add missing __devexit_p() annotations
Message-ID: <20111003174610.GP6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-5-git-send-email-arnd@arndb.de>
 <CAFULf_wevZxWW1RW+r-18R_8=ry2kD6_i5L9NfPd9t8afm5Cog@mail.gmail.com>
 <20111002160926.GB12323@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111002160926.GB12323@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [111002 08:35]:
> On Sun, Oct 02, 2011 at 05:56:07PM +0200, Bjarne Steinsbo wrote:
> > Arnd,
> > 
> > Ref http://www.spinics.net/lists/linux-omap/msg57274.html
> > 
> > Don't get me wrong.  This is not about you "stealing" my patch, or
> > anything like that.  But look also at thread starting at
> > http://www.spinics.net/lists/linux-omap/msg57667.html Also a patch
> > that I have posted previously.  Something is not right with the
> > workflow when bugs are identified, patches are submitted, then
> > ignored, only for someone else to fix the same bug.  Enough said.
> 
> That is where re-sending is important.  Don't throw patches over the wall
> and then forget them - that's precisely how this happens.

Bjarne, sorry for accidentally dropping patches, that's not intentional.

Like Russell said, please follow through with your own patches and
repost and complain until the patches do get merged.

> Consider who has the higher workload, and who ends up dealing with many
> many many emails, and realise that the options for those of us who receive
> patches are either to drop patches, or have an endlessly growing backlog
> of patches when things get busy.
> 
> Unless we drop patches, things can get pretty rediculous - consider the
> effect of a backlog of one month worth of patches would cause...

Tools like patchwork.kernel.org help a bit, and especially the email
subject line containing magic the keyword "fix" might help avoiding
the duplicate work.

Regards,

Tony
