Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab0GWVQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 17:16:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39222 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab0GWVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 17:16:19 -0400
Date: Fri, 23 Jul 2010 22:16:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 08/11] ARM: omap: move get_fbmem_region() to .init.text
Message-ID: <20100723211605.GF750@n2100.arm.linux.org.uk>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de> <1279915120-4373-8-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1279915120-4373-8-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 09:58:31PM +0200, Uwe Kleine-König wrote:
> get_fbmem_region() is only called by omapfb_reserve_sdram() and
> omapfb_reserve_sram() that both live in .init.text.  So get_fbmem_region
> can go there, too.

NAK.
