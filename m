Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1HOV3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:29:00 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54975 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1HOV27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:28:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] video/atmel_lcdfb: Fix build failure/typo for avr32 defconfig
Date: Mon, 15 Aug 2011 23:29:05 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <1313429190-29275-1-git-send-email-peterhuewe@gmx.de> <201108151943.08347.PeterHuewe@gmx.de> <20110815212659.GA18198@pengutronix.de>
In-Reply-To: <20110815212659.GA18198@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108152329.06329.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 August 2011 23:26:59 Wolfram Sang wrote:
> On Mon, Aug 15, 2011 at 07:43:07PM +0200, Peter Hüwe wrote:
> > Am Montag 15 August 2011, 19:31:27 schrieb Laurent Pinchart:
> > > Thanks for the patch. I've already submitted the same patch
> > > (https://patchwork.kernel.org/patch/990792/) nearly a month ago to the
> > > linux- fbdev mailing list. Paul, can you please pick it up ?
> > 
> > Ah okay, didn't see it. I usually look on the lkml if the problem was
> > already fixed lately but somehow missed your patch.
> > 
> > Since you've done exactly what my patch did you get my
> > Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
> 
> This bug was spotted during the review phase, too:
> 
> https://patchwork.kernel.org/patch/878382/
> 
> Dunno if the wrong patch was picked up or the follow up patch never came
> around. Doesn't matter:

I've sent a v3 but v2 was picked up. I've then sent a fix on top of v2, but it 
hasn't made it through (yet).

> Acked-by: Wolfram Sang <w.sang@pengutronix.de>

-- 
Regards,

Laurent Pinchart
