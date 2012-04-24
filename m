Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2DXJCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:02:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43304 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2DXJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:02:23 -0400
MIME-Version: 1.0
In-Reply-To: <1334933916-12971-1-git-send-email-b29396@freescale.com>
References: <1334933916-12971-1-git-send-email-b29396@freescale.com>
Date: Tue, 24 Apr 2012 11:02:23 +0200
Message-ID: <CACRpkdah8Mr2riXGJXZ2VEYXdORyLznPYG0s-O05vYiGYjQcdw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 4:58 PM, Dong Aisheng <b29396@freescale.com> wrote:

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

I'm pretty happy with this driver and would love to merge it.

However it'd be nice to have someone else ACK it first.
Someone like Sascha or Shawn would work fine :D

Yours,
Linus Walleij
