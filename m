Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0GXIvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 04:51:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36116 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0GXIvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:51:21 -0400
Date: Sat, 24 Jul 2010 10:51:12 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 06/11] ARM: omap: move omapfb_reserve_sdram() to
	.init.text
Message-ID: <20100724085112.GA694@pengutronix.de>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de> <1279915120-4373-6-git-send-email-u.kleine-koenig@pengutronix.de> <20100723211535.GD750@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100723211535.GD750@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 10:15:35PM +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 23, 2010 at 09:58:29PM +0200, Uwe Kleine-König wrote:
> > omapfb_reserve_sdram() is only called by omap1_map_common_io() and
> > _omap2_map_common_io() that both live in .init.text.  So this is save
> > for omapfb_reserve_sdram(), too.
> 
> NAK.  This clashes with the memblock stuff.
OK, I will recheck after .36-rc1.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
