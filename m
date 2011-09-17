Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1IQI5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 04:57:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60948 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab1IQI5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 04:57:17 -0400
Date: Sat, 17 Sep 2011 10:57:15 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] mfd wm8350: rename static gpio_set_debounce()
Message-ID: <20110917085715.GA5139@pengutronix.de>
References: <20110810080549.GX31404@pengutronix.de>
 <20110822101330.GL4607@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110822101330.GL4607@sortiz-mobl>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:53:15 up 87 days, 14:40, 11 users,  load average: 0.49, 0.27,
 0.16
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Mon, Aug 22, 2011 at 12:13:30PM +0200, Samuel Ortiz wrote:
> On Wed, Aug 10, 2011 at 10:05:49AM +0200, Sascha Hauer wrote:
> > 
> > The kernel already has a function with this name declared
> > in asm-generic/gpio.h. So if this header leaks into wm8350/gpio.c
> > we get
> > 
> > drivers/mfd/wm8350-gpio.c:40:12: error: conflicting types for 'gpio_set_debounce'
> > include/asm-generic/gpio.h:156:12: note: previous declaration of 'gpio_set_debounce' was here
> > 
> > Fix this by adding a wm8350_ prefix to the function.
> Thanks for the fix, I applied this patch to both of my branches.
> I'll send a pull request for the MFD fixes soon.

Ping... could you try to move this forward?

The kernel doesn't compile for mx3_defconfig since more than 6 weeks now
because of this patch :-(

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
