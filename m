Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1HYMHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 08:07:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46353 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1HYMHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:07:53 -0400
Date: Thu, 25 Aug 2011 14:07:45 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
Message-ID: <20110825120745.GV31404@pengutronix.de>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04B24A3BC0@HQMAIL01.nvidia.com>
 <CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
 <20110825110451.GU31404@pengutronix.de>
 <CACRpkdbV_Hgj=x5J3wYCtPcnZ++xMCqY91J2_i75c0G8OtYk5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbV_Hgj=x5J3wYCtPcnZ++xMCqY91J2_i75c0G8OtYk5A@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:07:17 up 64 days, 17:54, 63 users,  load average: 2.04, 1.84,
 1.96
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 01:58:12PM +0200, Linus Walleij wrote:
> On Thu, Aug 25, 2011 at 1:04 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > Not really. UART2_CTS can't be routed to arbitrary pads, but it can be
> > routed to more than one pad:
> >
> > #define _MX51_PAD_EIM_D16__UART2_CTS            IOMUX_PAD(0x3f0, 0x5c, 3, 0x0000, 0, 0)
> > #define _MX51_PAD_EIM_D25__UART2_CTS            IOMUX_PAD(0x414, 0x80, 4, 0x0000, 0, 0)
> > #define _MX51_PAD_USBH1_DATA0__UART2_CTS        IOMUX_PAD(0x688, 0x288, 1, 0x0000, 0, 0)
> 
> Aha!
> 
> Is it typically a few pads like this, say 2,3,4 alternatives,
> sometimes just one?
> 
> So the actual relation is not 1..1 nor 1...* but 1..<a few>?

Yes.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
