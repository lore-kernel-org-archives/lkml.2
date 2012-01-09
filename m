Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab2AIJeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:34:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46649 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2AIJeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:34:05 -0500
Date: Mon, 9 Jan 2012 10:33:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, shawn.guo@linaro.org,
        kernel@pengutronix.de, eric.miao@linaro.org, patches@linaro.org
Subject: Re: [PATCH v4 0/2] mx-sdma: memory barrier fix
Message-ID: <20120109093358.GN5446@pengutronix.de>
References: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:33:30 up 57 days, 17:20, 25 users,  load average: 0.00, 0.04,
 0.24
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 10:44:20PM +0800, Richard Zhao wrote:
> Changes in v4:
>  - convert all _raw_readl/_raw_writel to readl/writel.
> 
> Changes in v3:
>  - use writel instead of explicitly call wmb.
> 
> Changes in v2:
>  - add "let sdma_run_channel call sdma_enable_channel"

Both

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
