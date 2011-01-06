Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1AFKXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:23:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49208 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1AFKXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:23:15 -0500
Date: Thu, 6 Jan 2011 11:23:10 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Julien Boibessot <julien.boibessot@free.fr>
Cc: linux-arm-kernel@lists.infradead.org, liu.y.victor@gmail.com,
        B02280@freescale.com, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2] i.MX51 Framebuffer support
Message-ID: <20110106102310.GF26009@pengutronix.de>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
 <4D246C54.9060503@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D246C54.9060503@free.fr>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:21:01 up 2 days, 19:28, 25 users,  load average: 0.11, 0.16,
 0.18
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 02:04:20PM +0100, Julien Boibessot wrote:
> Hello,
> 
> Sascha Hauer a écrit :
> > The following series adds i.MX51 framebuffer support based on the IPUv3. It
> > is not perfect but I decided it is good enough to open it for a wider audience
> > and collect first reviews. I tested this on a babbage board using both outputs
> > (VGA/DVI) with different resolutions up to 1680x1050 and different colour depths.
> > I also tested it on one custom board using a fixed display setting.
> >   
> This driver is also working fine for me on a custom i.MX51 board with a
> 800x480 18 bits TFT LCD (16bpp mode).
> 
> The only strange thing I noticed was a kind of uggly sprite/artefact
> (32x32, I would say) appearing at the same time as the Linux console. I
> think it may be related to a hardware cursor badly (?) initialised, but
> I didn't find a fix yet.
> It disappears when I launch a graphical application (Qt or SDL).

It may be the penguin, but I remember a similar report also talkling
about hardware cursors. I can't reproduce this. You could search for
cursor in the IPU section of the manual and play with the corresponding
registers.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
