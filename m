Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab1AaH6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:58:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54669 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab1AaH6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:58:07 -0500
Date: Mon, 31 Jan 2011 08:58:03 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: arden jay <arden.jay@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Hemanth V <hemanthv@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [RFC] add pwmlib support
Message-ID: <20110131075803.GI9041@pengutronix.de>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
 <20110129213821.0e51dc32@endymion.delvare>
 <20110129215141.GA3493@pengutronix.de>
 <AANLkTi=ppKZ96T3_1nYisHG9705OCHgZqkLnu2f47zq5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ppKZ96T3_1nYisHG9705OCHgZqkLnu2f47zq5@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:55:49 up 15 days, 18:02, 14 users,  load average: 0.46, 0.40,
 0.20
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 11:49:32AM +0800, arden jay wrote:
> Sorry, I'm confused about this.
> If it is for backlight control, why it don't go through led_class?

PWMs are not limited to backlight. As Jean pointed out they can be used
for fans (or more generally motors) aswell. Have a look at
drivers/leds/leds-pwm.c, it is a user of this pwm API.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
