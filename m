Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0KJRJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:09:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42690 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab0KJRJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:09:15 -0500
Date: Wed, 10 Nov 2010 18:09:12 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: amit.kucheria@canonical.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, eric@eukrea.com,
        u.kleine-koenig@pengutronix.de,
        Nguyen Dinh-R00091 <R00091@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 1/2] ARM: imx: Add core definitions for MX53
Message-ID: <20101110170912.GC8950@pengutronix.de>
References: <1288972551-21877-1-git-send-email-Dinh.Nguyen@freescale.com> <20101109214607.GG6017@pengutronix.de> <86A0E76937111F4C92FABEC0A20988510523D224@az33exm21> <20101110164640.GV6017@pengutronix.de> <AANLkTinmXin65ReWsUf02ia7FMvHfeqkVeaGu6Usmdw5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinmXin65ReWsUf02ia7FMvHfeqkVeaGu6Usmdw5@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:07:40 up 130 days,  8:18, 40 users,  load average: 0.12, 0.13,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 03:04:27PM -0200, Fabio Estevam wrote:
> On Wed, Nov 10, 2010 at 2:46 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> ...
> 
> >> Agreed, but I was unsure how to proceed with adding clock code for mx53.
> >> Should I merge mx53 clock code into clock-mx51 and rename clock-mx51?
> >
> > Yes, to something like clock-mx51-mx53.c
> >
> 
> Or maybe clock-mx5x.c would be more generic.
> 
> This way when any other MX5x processor gets added we don't need to
> change the file name again.

This can happen with mx5x also when the next MX5x is incompatible like
we had with i.MX2x when i.MX25 came out. Anyway, in this case I don't
care much.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
