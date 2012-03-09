Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2CIRoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:44:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44688 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2CIRoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:44:17 -0500
Date: Fri, 9 Mar 2012 18:44:11 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
Subject: Re: [PATCH v3 00/13] dmaengine: imx-dma: merge dma arch code into
 dmaengine.
Message-ID: <20120309174411.GI3852@pengutronix.de>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:43:32 up 118 days,  1:30, 14 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 04:20:36PM +0100, Javier Martin wrote:
> The following series have to be applied on top of the following patches:
> [PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
> [PATCH v3 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
> 
> As discussed with Vinod and Sascha, the file 'arch/arm/mach-imx/dma-v1.c'
> is deprecated and no new patches are accepted for it.
> 
> This series merges this code into the imx-dma.c dmaengine driver.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
