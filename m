Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab1LERBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:01:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36950 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab1LERBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:01:13 -0500
MIME-Version: 1.0
In-Reply-To: <20111204161123.GS27267@pengutronix.de>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
	<1322999384-7886-2-git-send-email-b29396@freescale.com>
	<20111204161123.GS27267@pengutronix.de>
Date: Mon, 5 Dec 2011 18:01:12 +0100
Message-ID: <CACRpkdZ0aNj-BsdtD2R-bEWQfMzsOMNbdh6ryVtgwET3Ry7xXA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        shawn.guo@freescale.com, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 4, 2011 at 5:11 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

> I don't think that this grouping of pads to their functions makes
> sense. On i.MX every pad is muxed independently and not in groups.
> Which pins belong to which function is board specific and not SoC
> specific.

True, Dong can this be moved to the imx pinctrl platform data
and passed in from arch/arm/[plat|mach]-* board files instead?
That is probably where it belongs today.

I know that this data is in drivers/pinctrl for the U300 and SIRF,
but that is because they only have one single board variant.

Yours,
Linus Walleij
