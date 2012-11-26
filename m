Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2KZIvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:51:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48399 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2KZIvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:51:04 -0500
Date: Mon, 26 Nov 2012 09:51:01 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Pavel Pisa <ppisa@pikron.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 18/24] MAINTAINERS: remove drivers/mmc/host/imxmmc.*
Message-ID: <20121126085101.GZ10369@pengutronix.de>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
 <1353716808-16375-19-git-send-email-cesarb@cesarb.net>
 <201211240918.42930.ppisa@pikron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211240918.42930.ppisa@pikron.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:50:32 up 156 days, 2 min, 33 users,  load average: 6.26, 2.08,
 1.76
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Sat, Nov 24, 2012 at 09:18:42AM +0100, Pavel Pisa wrote:
> On Saturday 24 November 2012 01:26:42 Cesar Eduardo Barros wrote:
> > This driver was removed by commit 6187fee (mmc: remove imxmmc driver).
> >
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Pavel Pisa <ppisa@pikron.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> > ---
> >  MAINTAINERS | 6 ------
> >  1 file changed, 6 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index fc646ef..cac8e49 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -4905,12 +4905,6 @@ F:	Documentation/video4linux/meye.txt
> >  F:	drivers/media/pci/meye/
> >  F:	include/uapi/linux/meye.h
> >
> > -MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
> > -M:	Pavel Pisa <ppisa@pikron.com>
> > -L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > -S:	Maintained
> > -F:	drivers/mmc/host/imxmmc.*
> > -
> >  MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
> >  M:	Jiri Slaby <jirislaby@gmail.com>
> >  S:	Maintained
> 
> Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> 
> I have still the hardware but have lack resources to keep with current
> kernel development for that old HW. We plan to switch to newer i.MX
> hardware - hopefully with more bug free MMC/SD support, because MX1
> has taken me yer a year of fighting with its bugs (on Linux and RTEMS
> as well).

They are bug free enough to work ;)

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
