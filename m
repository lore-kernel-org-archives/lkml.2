Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0KENMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:12:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54142 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0KENMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:12:40 -0400
Date: Fri, 5 Nov 2010 14:12:30 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mxcmmc: Add the ability to bind a regulator to manage
	the MMC card voltage
Message-ID: <20101105131230.GX6017@pengutronix.de>
References: <1288656337.29881.13.camel@realization> <20101102073932.GB6017@pengutronix.de> <1288949275.3072.3.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288949275.3072.3.camel@realization>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:12:01 up 125 days,  4:22, 49 users,  load average: 0.73, 0.33,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 10:27:55AM +0100, Alberto Panizzo wrote:
> On mar, 2010-11-02 at 08:39 +0100, Sascha Hauer wrote:
> > On Tue, Nov 02, 2010 at 01:05:37AM +0100, Alberto Panizzo wrote:
> > > This implementation is based on the pxamci.c driver and it will
> > > be used to support the mx31_3ds machine.
> > > 
> > > Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> > 
> > Looks good to me
> > 
> > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> > 
> 
> Sascha, must this one go to the Chris Ball mmc tree? or can you pick it
> up directly?

Better to pass this via the mmc tree.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
