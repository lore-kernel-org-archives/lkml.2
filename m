Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab2EXGqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:46:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56167 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2EXGqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:46:49 -0400
Date: Thu, 24 May 2012 08:46:35 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, marc@cpdesign.com.au,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524064635.GP3710@pengutronix.de>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
 <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
 <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
 <20120523084945.GA4085@opensource.wolfsonmicro.com>
 <20120523164203.GA7843@S2100-06.ap.freescale.net>
 <CAOMZO5AOsdHqZ2Rth_m_BLEvHyLrJGEeXzmZZX=HyfeQZ7WTYw@mail.gmail.com>
 <20120524004851.GB7843@S2100-06.ap.freescale.net>
 <CAOMZO5A-LbgPFTbizK-NghboTs9rGWN2LnmQHEQEdo5Bhxtohg@mail.gmail.com>
 <20120524063859.GD7843@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120524063859.GD7843@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 24, 2012 at 02:39:00PM +0800, Shawn Guo wrote:
> On Thu, May 24, 2012 at 01:07:43AM -0300, Fabio Estevam wrote:
> > I am trying to understand why mx31pdk still fails.
> > 
> So different from imx51-babbage which uses MC13892, mx31pdk uses
> MC13783?  But both chips should have the same regmap, right?
They are similar. One difference is the protocol used. MC13783 only
speaks spi, MC13892 can do both, spi and i2c. Does someone has a working
MC13892 that uses spi?

For debugging I'd instrument the spi driver to log and compare what is
read and written to the data registers before and after the introduction
of the regmap stuff.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
