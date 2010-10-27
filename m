Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0J0XoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:44:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33715 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0J0XoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:44:23 -0400
Date: Thu, 28 Oct 2010 01:44:13 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCH] ARM: imx: Add some core definitions for MX53
Message-ID: <20101027234413.GD32583@pengutronix.de>
References: <1288119235-7036-1-git-send-email-Dinh.Nguyen@freescale.com> <20101027082958.GA6797@angua.secretlab.ca> <20101027090921.GB8554@pengutronix.de> <20101027102253.GA7822@angua.secretlab.ca> <20101027132213.GJ6017@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101027132213.GJ6017@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 01:41:18 up 116 days, 14:52, 16 users,  load average: 0.01, 0.11,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 03:22:13PM +0200, Sascha Hauer wrote:
> That's a way we can go but only if the common name is not MX5 or MX5x.
> We've done it with the mx21/27 and it failed when the mx25 came out
> which was completely incompatible.

And even worse, there is also the MX23 and MX28 in the meantime which
are not i.MX at all: they are a design coming from Sigmatel, bought by
Freescale and only named i.MX due to marketing reasons.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
