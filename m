Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab1EaGwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 02:52:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40273 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab1EaGwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 02:52:32 -0400
Date: Tue, 31 May 2011 08:52:28 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, kernel@pengutronix.de
Subject: Re: [PATCH] leds: make LEDS_GPIO_REGISTER depend on NEW_LEDS
Message-ID: <20110531065228.GS9907@pengutronix.de>
References: <1306576376.10669.12.camel@phoenix>
 <20110528174733.GF9907@pengutronix.de>
 <BANLkTi=F2Gh=+-8ms0nBf+zdLy+7uEOugg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=F2Gh=+-8ms0nBf+zdLy+7uEOugg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 09:38:34AM +0800, Axel Lin wrote:
> hi Uwe,
> > Below is a patch that fixes the layout problem but keeps the
> > functionality as before and intended.
> >
> > -----8<-----
> > leds: move LEDS_GPIO_REGISTER out of menuconfig NEW_LEDS
> >
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >
> > Commit 4440673a "leds: provide helper to register "leds-gpio" devices"
> > broke the display of the NEW_LEDS menu as it didn't depend on NEW_LEDS
> > and so made "LED drivers" and "LED Triggers" appear at the same level as
> > "LED Support" instead of below it as it was before 4440673a.
> >
> > Moving LEDS_GPIO_REGISTER out of the menuconfig NEW_LEDS fixes this
> > unintended side effect.
> >
> > Reported-by: Axel Lin <axel.lin@gmail.com>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> Your patch looks good.
Richard, thoughts? Andrew, do you take my patch provided that Richard is
OK with it?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
