Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab2D0FaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:30:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65464 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2D0FaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:30:19 -0400
Date: Fri, 27 Apr 2012 13:30:09 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, s.hauer@pengutronix.de, shawn.guo@freescale.com,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, cjb@laptop.org, b20223@freescale.com
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120427053007.GH2234@S2101-09.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335451227-27709-2-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 10:40:25PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The driver has mux and config support while the gpio is still
> not supported.
> For select input setting, the driver will handle it internally
> and do not need user to take care of it.
> 
> The pinctrl-imx core driver will parse the dts file and dynamically
> create the pinmux functions and groups.
> 
> Each IMX SoC pinctrl driver should register pins with a pin register map
> including mux register and config register and select input map to core
> for proper operations.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
Acked-by: Shawn Guo <shawn.guo@linaro.org>
