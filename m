Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab1LNRky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:40:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1LNRkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:40:51 -0500
MIME-Version: 1.0
In-Reply-To: <1323878622-26602-1-git-send-email-b29396@freescale.com>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
Date: Wed, 14 Dec 2011 18:40:51 +0100
Message-ID: <CACRpkdbNOLBxsbAnnYSNiPaQ3EAj6eQ9=C8jJDb+jKP3GdjRcg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] pinctrl: imx: add pinnmux support
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 5:03 PM, Dong Aisheng <b29396@freescale.com> wrote:

> For DT support, there's still one issue that for pinmux_map,
> since it's board specific, i wonder if it can be parsed by pinctrl
> subsystem via dt rather than by each driver.

That is definately how it should be done. Seems like a good
idea to me.

> but pinctrl still does not supported that, i still only called
> it in mach-imx6q.c which seems not a correct place.

Don't worry that pinctrl does not support it - patch pinctrl core!

Just make a separate patch which patches drivers/pinctrl/pinmux.c
to ass the device tree parsing you need from the core, and we'll
review it.

I am by far too incompetent in device tree mechanisms to do
that myself, I have never worked much on device tree.

Thanks,
Linus Walleij
