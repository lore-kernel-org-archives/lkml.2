Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030700Ab2CNHN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:13:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030647Ab2CNHNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:13:25 -0400
Date: Wed, 14 Mar 2012 08:13:07 +0100
From: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: Re: [PATCH v1 2/5] mmc: mxs-mmc: add dt probe support
Message-ID: <20120314071307.GK3852@pengutronix.de>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <201203140658.25854.marek.vasut@gmail.com>
 <20120314065512.GB25735@shlinux2.ap.freescale.net>
 <201203140809.22676.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203140809.22676.marek.vasut@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:11:52 up 122 days, 14:58, 26 users,  load average: 0.01, 0.02,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 08:09:22AM +0100, Marek Vasut wrote:
> Dear Dong Aisheng,
> 
> > On Wed, Mar 14, 2012 at 01:58:25PM +0800, Marek Vasut wrote:
> > > Dear Dong Aisheng,
> > > 
> > > > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > ........
> > 
> > > > +static const struct of_device_id mxs_mmc_dt_ids[] = {
> > > > +	{ .compatible = "fsl,imx23-mmc", .data = NULL, },
> > > > +	{ .compatible = "fsl,imx28-mmc", .data = NULL, },
> > > 
> > > Do you really need two distinct ones here?
> > 
> > Hmm, my original purpose is to put soc difference data in .data
> > to remove cpu_is_* function calls in the driver later.
> > Do you think if any issue?
> > 
> 
> Well, what's the difference between the interfaces on mx233 and mx28? Is it 
> something that can't be encoded otherwise? I think they're not so different.

They differ in the register layout. Matching two different compatible
strings is the right way here I think.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
