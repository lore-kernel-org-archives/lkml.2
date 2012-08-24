Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2HXGma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 02:42:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38337 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2HXGmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 02:42:25 -0400
Date: Fri, 24 Aug 2012 14:43:00 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sameo@linux.intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, richard.zhao@freescale.com,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
        paul.liu@linaro.org
Subject: Re: [PATCH 1/7] mfd: add imx syscon driver based on regmap
Message-ID: <20120824064257.GA31998@S2101-09.ap.freescale.net>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345619928-15446-2-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 03:18:42PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Add regmap based imx syscon driver.
> This is usually used for access misc bits in registers which does not belong
> to a specific module, for example, IOMUXC GPR and ANATOP.
> With this driver, we provide a standard API for client driver to call to
> access registers which are registered into syscon.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> Currently it's just simply for IMX, however the driver really is not too
> much imx specific.
> If people want, we probably could extend it to support other platforms too.

Right.  I do not see anything IMX specific there.  We should probably
at least give the driver a generic name from day one.

-- 
Regards,
Shawn
