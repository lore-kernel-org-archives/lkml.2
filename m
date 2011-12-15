Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab1LOM6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 07:58:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57227 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1LOM6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 07:58:12 -0500
Date: Thu, 15 Dec 2011 13:58:05 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Massive log spam loading modules on ARM after 3.2-rc5
 (regression)
Message-ID: <20111215125805.GF24496@pengutronix.de>
References: <20111214215133.GA7780@elliptictech.com>
 <20111215092633.GD24496@pengutronix.de>
 <20111215094733.GI14542@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111215094733.GI14542@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Thu, Dec 15, 2011 at 09:47:33AM +0000, Russell King - ARM Linux wrote:
> > Can you provide me your .config please? I cannot reproduce your problems
> > with modprobe on an i.MX28 based tx28 machine.
> > 
> > Russell, maybe this makes you a bit less annoyed?
> 
> Why should it?
If you consider my statement to relate to your "And wtf wasn't it
tested with modules?" it might convince you that my testing included
modules, too.

Assuming that the fix I send to Nick solves his problem, this problem
only affects the last function before and first function after the .idx
section and that only in approx. one out of two cases. (And additionally
for me the unwinder isn't used on modprobe.) So I still think my testing
was OK.

> 1. Your change is totally unaffected by whether XIP is being used or not,
>    so this is irrelevant.
> 2. You plainly said in your previous message (and I quote) "IMHO this is
>    merge window material even though it has "fix" in the title.".
> 
> The fact of the matter is that you _never_ said that you didn't consider
> your patch -rc material - and that alone is what I'm complaining at you
> about.  It is _YOUR_ responsibility to indicate where a patch should be
> applied.  You failed to do that.
I don't think that it makes sense to continue arguing here. If you have
to name someone to Linus who is responsible for this regression, feel
free to say my name. (Ah, I see he's on Cc: ...)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
