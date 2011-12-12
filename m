Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1LLOiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:38:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54207 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1LLOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:38:04 -0500
Date: Mon, 12 Dec 2011 15:37:50 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shawn Guo <shawn.guo@freescale.com>, Stephen Warren <swarren@nvidia.com>,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Message-ID: <20111212143750.GA27267@pengutronix.de>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
 <20111209010147.GH7913@S2100-06.ap.freescale.net>
 <4EE18403.30604@nvidia.com>
 <20111209043220.GJ7913@S2100-06.ap.freescale.net>
 <4EE192DC.3080209@nvidia.com>
 <20111209051413.GK7913@S2100-06.ap.freescale.net>
 <20111209110807.GG27267@pengutronix.de>
 <CACRpkdYpq1phHTTLy875xSr-upiW5BmvKMPO_d-niG+-J14t9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYpq1phHTTLy875xSr-upiW5BmvKMPO_d-niG+-J14t9w@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:33:47 up 29 days, 22:20, 65 users,  load average: 0.05, 0.05,
 0.53
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 01:18:43AM +0100, Linus Walleij wrote:
> On Fri, Dec 9, 2011 at 12:08 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > I still think it should be "I'm board Y, please set all my pins up for me"
> 
> This is basically what the current pinmux hog concept does.
> 
> > Drivers should not be bothered with pin muxing *at all*.
> 
> Not if they are simple. Like - set them up once and for all and
> then forget about it.
> 
> It gets problematic when we get to sleep states and the system
> need to reconfigure all pins on say idle or deep sleep.

If you need to reconfigure your pins in deep sleep and you control
the pins in the driver this seems to suggest that your device won't
suspend properly if the driver is not loaded?

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
