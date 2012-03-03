Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2CCSOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 13:14:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55131 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2CCSOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 13:14:40 -0500
Date: Sat, 3 Mar 2012 19:14:37 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Estevam Fabio-R49496 <r49496@freescale.com>
Subject: Re: [PATCH 4/4] ARM i.MX 3ds debugboard: register a dummy regulator
 for the smsc911x device
Message-ID: <20120303181437.GJ26642@pengutronix.de>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
 <1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
 <20120303163733.GC3071@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120303163733.GC3071@opensource.wolfsonmicro.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:05:30 up 112 days,  1:52, 15 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 04:37:34PM +0000, Mark Brown wrote:
> On Sat, Mar 03, 2012 at 12:40:04PM +0100, Sascha Hauer wrote:
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  arch/arm/plat-mxc/3ds_debugboard.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> applied, though with at least this board you clearly do have a sensible
> regulator setup already and are just adding in a few extra regulators to
> fill out things which for some reason aren't supplied by the PMIC.  It's
> quite surprising that things like what look like the I/O reference
> voltage are supplied elsewhere.

This debug board is used with four different baseboards and one of them
indeed has regulator support in mainline. The regulator for the smsc911x
though is not software controllable on any of these boards. In the end
it's a debug board, energy efficiency might not be really important in
such a case.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
