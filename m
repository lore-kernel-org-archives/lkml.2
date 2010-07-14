Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0GNNWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:22:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45385 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab0GNNV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:21:59 -0400
Date: Wed, 14 Jul 2010 15:20:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Brown <davidb@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: ARM defconfig files
Message-ID: <20100714132046.GA18343@pengutronix.de>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <201007121605.32462.davidb@codeaurora.org> <AANLkTimho3rcoCZZ2PlC3B3KIZZhsEiTnTk-__n1q_Dy@mail.gmail.com> <201007121634.04427.davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201007121634.04427.davidb@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 04:34:04PM -0700, David Brown wrote:
> On Monday 12 July 2010 16:18:01 Linus Torvalds wrote:
> 
> > 2010/7/12 David Brown <davidb@codeaurora.org>:
> > >
> > > Do you have scripts or tools that you did this with, or is a manual
> > > process.  We're about to add several new (ARM) targets, and it'd be
> > > nice to be able to make small defconfigs for those targets as well.
> > 
> > Uwe posted it earlier in this thread as an attachement, and I put the
> > python script into the merge commit message too. And we should
> > probably put it somewhere in scripts too, and/or make a 'make' target
> > to create the small config files.
> > 
> > I pushed it all out, and tagged it as -rc5.
> 
> Got it, thanks.  I just pulled a bit soon.
> 
> It seems a bit brute force, probably not something I can make part of
> our regular build process, but I can definitely run it before sending
> patches out.
> 
> I wonder if there's a more efficient way of doing it that doesn't
> involve invoking make for each line of the file.  It at least
> shouldn't be necessary to actually build the kernel each time.
Note that no kernel is built at all, only the config is regenerated once
for each line.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
