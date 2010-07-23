Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0GWVPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 17:15:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39209 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0GWVPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 17:15:51 -0400
Date: Fri, 23 Jul 2010 22:15:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 06/11] ARM: omap: move omapfb_reserve_sdram() to
	.init.text
Message-ID: <20100723211535.GD750@n2100.arm.linux.org.uk>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de> <1279915120-4373-6-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1279915120-4373-6-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 09:58:29PM +0200, Uwe Kleine-König wrote:
> omapfb_reserve_sdram() is only called by omap1_map_common_io() and
> _omap2_map_common_io() that both live in .init.text.  So this is save
> for omapfb_reserve_sdram(), too.

NAK.  This clashes with the memblock stuff.
