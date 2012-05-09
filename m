Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2EIHZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:25:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60986 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EIHZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:25:01 -0400
Date: Wed, 9 May 2012 09:24:53 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Chen Peter-B29397 <B29397@freescale.com>
Cc: Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] usb: fsl_mxc_udc.c: add workaround for ENGcm09152
 for i.MX25
Message-ID: <20120509072453.GH27341@pengutronix.de>
References: <1336461510-30190-1-git-send-email-eric@eukrea.com>
 <F281D0F91ED19E4D8E63A7504E8A649803B91ED2@039-SN2MPN1-022.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F281D0F91ED19E4D8E63A7504E8A649803B91ED2@039-SN2MPN1-022.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:23:54 up 178 days, 15:11, 39 users,  load average: 0.15, 0.06,
 0.33
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 02:59:52AM +0000, Chen Peter-B29397 wrote:
>  
> > 
> > this patch gives the possibility to workaround bug ENGcm09152
> > on i.MX25 when the hardware workaround is also implemented on
> > the board.
> > It covers the workaround described on page 42 of the following Errata,
> > titled "USB: UTMI_USBPHY VBUS input impedance implementation error" :
> > http://cache.freescale.com/files/dsp/doc/errata/IMX25CE.pdf
> > 
> 
> The two patches are ok, I am not sure if sascha is ok for these two
> as there is cpu_is_xxx code although it is bug fix.

I am ok with these patches. I think we should try hard and merge the
drivers, but this shouldn't be a reason to block bug fixes.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
