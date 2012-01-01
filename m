Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2AAOCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:02:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63585 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab2AAOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:02:13 -0500
MIME-Version: 1.0
In-Reply-To: <1324402840-32451-4-git-send-email-b29396@freescale.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-4-git-send-email-b29396@freescale.com>
Date: Sun, 1 Jan 2012 15:02:13 +0100
Message-ID: <CACRpkdZ3iTwLUsrvYL8_YaWf-DF9OF8Hc3o=XLza60iuomQn2Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, cjb@laptop.org,
        w.sang@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 6:40 PM, Dong Aisheng <b29396@freescale.com> wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> The driver contains the initial support for imx53 and
> imx6q.

Looks real good from a pinctrl point of view.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Now I guess it's that patch 2/5 that is at the heart of how we proceed
with this. I guess this patch depends on 2/5?

Yours,
Linus Walleij
