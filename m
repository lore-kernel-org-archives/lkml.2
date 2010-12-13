Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0LMLnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:43:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47724 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab0LMLne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:43:34 -0500
Date: Mon, 13 Dec 2010 12:43:32 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Liu Ying <liu.y.victor@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 9/9] ARM i.MX51 babbage: Add framebuffer support
Message-ID: <20101213114332.GF6017@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <1291902441-24712-10-git-send-email-s.hauer@pengutronix.de> <AANLkTi=vT8pX1QQ6DjzQatceO-tQb3Zu90CRAVi2DcpZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=vT8pX1QQ6DjzQatceO-tQb3Zu90CRAVi2DcpZ@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:39:03 up 163 days,  2:49, 46 users,  load average: 2.23, 2.14,
	2.02
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 09:37:38AM +0800, Liu Ying wrote:
> Hello, Sascha,
> 
> I have following 3 comments to this patch:
> 1) I think DISP1_DATx pins need not be set specially, as they keep the
> default register values.

We do not want to depend on default register values in the Linux Kernel.

> 2) Please define 'MX51_PAD_DI_GP4__IPU_DI2_PIN15' in
> arch/arm/plat-mxc/include/mach/iomux-mx51.h, and rename the pin to be
> 'MX51_PAD_DI_GP4__DI2_PIN15', as we name it according to the MX51
> iomux reference manual.

I'm not sure. Normally it's good practice to code the unit into the
name. Otherwise we end up with names like MX51_PAD_xyz__TX which could
be the tx pin of just about any unit.


> 3) It is better to exchange the following two lines or just remove the
> first line:
> +       gpio_set_value(GPIO_DVI_RESET, 0);
> +       gpio_direction_output(GPIO_DVI_RESET, 0);

ok.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
