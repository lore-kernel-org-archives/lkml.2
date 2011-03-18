Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1CRLNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:13:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42627 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1CRLN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:13:29 -0400
Date: Fri, 18 Mar 2011 12:13:19 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110318111319.GB27124@pengutronix.de>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110318101512.GA15375@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Fri, Mar 18, 2011 at 10:15:12AM +0000, Russell King - ARM Linux wrote:
> On Thu, Mar 17, 2011 at 07:50:36PM -0700, Linus Torvalds wrote:
> > The pure amount of crazy churn is annoying in itself,
> > but when I then get these "independent" pull requests from four
> > different people, and they touch the same files, that indicates that
> > something is wrong.
> 
> I have already complained to Uwe and Sascha about the IMX/MXC conflicts.
> It already struck me that there's something seriously wrong at
> pengutronix.com as both Uwe and Sascha work in the same area, yet don't
> coordinate their efforts.  It seems to me that Uwe is completely
> independent of everyone else.
I feel blamed wrongly here. My part of the "crazy churn" in
v2.6.38..$todayslinus/master is that I touched drivers/net/Kconfig[1] and
arch/arm/mach-mxs/gpio.c[2]. The former went in via the net tree; the
latter via Russell's tree with Sascha's Ack. Please correct me if I'm
wrong but I think this was the correct thing to do. I don't know how
that qualifies as "completely independent of everyone else".

IMHO the cooperation between Sascha and me works fine. In fact nearly
all[3] of my patches that touch imx related things under arch/arm/ go in
via Sascha's tree.

Best regards
Uwe

[1] 085e79e (net/fec: consolidate all i.MX options to CONFIG_ARM)
[2] bf0c111 (ARM: 6744/1: mxs: irq_data conversion)
[3] Some exceptions I found are:
	bf0c111 ARM: 6744/1: mxs: irq_data conversion
	4df772d ARM: 6322/1: imx/pca100: Fix name of spi platform data
	868003c ARM: 6280/1: imx: Fix build failure when including <mach/gpio.h> without <linux/spinlock.h>
    All of these are OK IMHO.


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
