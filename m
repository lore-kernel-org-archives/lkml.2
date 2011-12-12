Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1LLP33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:29:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38187 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1LLP31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:29:27 -0500
Date: Mon, 12 Dec 2011 16:29:20 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Message-ID: <20111212152920.GY4585@pengutronix.de>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
 <20111209010147.GH7913@S2100-06.ap.freescale.net>
 <4EE18403.30604@nvidia.com>
 <20111209043220.GJ7913@S2100-06.ap.freescale.net>
 <4EE192DC.3080209@nvidia.com>
 <20111209051413.GK7913@S2100-06.ap.freescale.net>
 <20111209110807.GG27267@pengutronix.de>
 <CACRpkdYpq1phHTTLy875xSr-upiW5BmvKMPO_d-niG+-J14t9w@mail.gmail.com>
 <20111212143750.GA27267@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111212143750.GA27267@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 03:37:50PM +0100, Sascha Hauer wrote:
> On Sat, Dec 10, 2011 at 01:18:43AM +0100, Linus Walleij wrote:
> > On Fri, Dec 9, 2011 at 12:08 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > 
> > > I still think it should be "I'm board Y, please set all my pins up for me"
> > 
> > This is basically what the current pinmux hog concept does.
> > 
> > > Drivers should not be bothered with pin muxing *at all*.
> > 
> > Not if they are simple. Like - set them up once and for all and
> > then forget about it.
> > 
> > It gets problematic when we get to sleep states and the system
> > need to reconfigure all pins on say idle or deep sleep.
> 
> If you need to reconfigure your pins in deep sleep and you control
> the pins in the driver this seems to suggest that your device won't
> suspend properly if the driver is not loaded?
If the pins have to be inactive (for some definition of inactive) for
sleep it should work well without the driver loaded, shouldn't it?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
