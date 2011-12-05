Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1LENJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:09:36 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41266 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab1LENJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:09:35 -0500
MIME-Version: 1.0
In-Reply-To: <1322999384-7886-1-git-send-email-b29396@freescale.com>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
Date: Mon, 5 Dec 2011 14:09:34 +0100
Message-ID: <CACRpkdaayt=VuUz2XrkYgGJWFzW3hwJZDP+vHWTf9vLYRY4q5w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@freescale.com, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 4, 2011 at 12:49 PM, Dong Aisheng <b29396@freescale.com> wrote:

> ---
> This patch series shows the basic idea of driver design. There're still
> some TODOes like adding more pinmux functions and gpio support.
> The patch is here for request for comments on the driver design
> and other might exist issues.
>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Shawn Guo <shanw.guo@freescale.com>

Dong, this is looking real good from pinctrl subsystem point of view.

Thanks!
Linus Walleij
