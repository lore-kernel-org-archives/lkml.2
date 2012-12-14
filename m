Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2LNPnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:43:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57055 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2LNPnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:43:49 -0500
MIME-Version: 1.0
In-Reply-To: <1355314904-10174-1-git-send-email-p.zabel@pengutronix.de>
References: <1355314904-10174-1-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 14 Dec 2012 16:43:47 +0100
Message-ID: <CACRpkdZ9X+qhKpJUuKCzpbpH+=mc5LEOpHxzVQEjH0X8zihQ6Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: imx5: fix GPIO_8 pad CAN1_RXCAN configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 1:21 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

> 3 is an invalid value for the CAN1_IPP_IND_CANRX_SELECT_INPUT
> register. Set it to 2, which correctly selects the GPIO_8 pad.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Applied to my fixes branch, unless someone protests now.

Yours,
Linus Walleij
