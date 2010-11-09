Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0KIW0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:26:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54163 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab0KIW0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:26:46 -0500
Date: Tue, 9 Nov 2010 23:26:45 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        amit.kucheria@canonical.com, eric@eukrea.com
Subject: Re: [PATCHv3 2/2] ARM: imx: Add mx53 support to common msl
	functions.
Message-ID: <20101109222645.GJ6017@pengutronix.de>
References: <1288972551-21877-1-git-send-email-Dinh.Nguyen@freescale.com> <1288972551-21877-2-git-send-email-Dinh.Nguyen@freescale.com> <20101109220207.GH6017@pengutronix.de> <20101109221213.GC16938@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101109221213.GC16938@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 23:23:45 up 129 days, 13:34, 34 users,  load average: 0.00, 0.79,
	2.40
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:12:13PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> > > -	if (!cpu_is_mx51())
> > > +	if (!cpu_is_mx51() || !cpu_is_mx53())
> > >  		return 0;
> > 
> > The code below runs for every SoC except i.MX51 and i.MX53. This is
> > surely not what you want.
> Hmm, for i.MX51 !cpu_is_mx53() is true, so the return 0 is always taken,
> isn't it? :-)

Gna, I remember I ran in this trap not so long time ago ;)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
