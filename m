Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2EAXNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:13:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53301 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab2EAXNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <1335529578-14507-2-git-send-email-b29396@freescale.com>
References: <1335529578-14507-1-git-send-email-b29396@freescale.com>
	<1335529578-14507-2-git-send-email-b29396@freescale.com>
Date: Wed, 2 May 2012 01:07:20 +0200
Message-ID: <CACRpkdZce7fZ=3cWLwWXzJ30P_LoLYKXdU411zr38RNkQs0+wA@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] pinctrl: pinctrl-imx: add imx pinctrl core driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, s.hauer@pengutronix.de, shawn.guo@freescale.com,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 2:26 PM, Dong Aisheng <b29396@freescale.com> wrote:

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
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Thanks, applied.

Yours,
Linus Walleij
