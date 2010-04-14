Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab0DNGve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:51:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43735 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab0DNGvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:51:32 -0400
Date: Wed, 14 Apr 2010 08:51:31 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       amit.kucheria@canonical.com, linux@arm.linux.org.uk,
       grant.likely@secretlab.ca, Herring Robert-RA7055 <RA7055@freescale.com>,
       linux-arm-kernel@lists.infradead.org, bryan.wu@canonical.com,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc4 1/8] mx5: Add registration of GPIOs for MX51
	Babbage board.
Message-ID: <20100414065131.GD7882@pengutronix.de>
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com> <20100413164532.GM30801@buzzloop.caiaq.de> <86A0E76937111F4C92FABEC0A2098851046C7A62@az33exm21>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86A0E76937111F4C92FABEC0A2098851046C7A62@az33exm21>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:47:45 up 24 days, 19:37, 16 users,  load average: 1.72, 2.66,
	3.08
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 12:36:07PM -0700, Nguyen Dinh-R00091 wrote:
> > +
> > +#ifdef MXC_GPIO_SPLIT_IRQ_2
> 
> Where is that macro defined?
> [Dinh-FSL] - This macro is optional so that the interrupts can be broken
> up into 2 sets.

What's the purpose of doing so?

Such compile time depencies are not a good idea since the board may want
to decide whether to split the interrupts or not. Note that we support
kernels for more than one board.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
