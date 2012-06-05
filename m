Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2FEMra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:47:30 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59601 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2FEMr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <1338261195-17924-1-git-send-email-festevam@gmail.com>
References: <1338261195-17924-1-git-send-email-festevam@gmail.com>
Date: Tue, 5 Jun 2012 14:47:25 +0200
Message-ID: <CACRpkdanXpYUkF3RiAdSQAJW4OTJk=yjVkABT1fOqd_C_rr1rA@mail.gmail.com>
Subject: Re: [PATCH] dummies
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 5:13 AM, Fabio Estevam <festevam@gmail.com> wrote:

> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> For mxs_defconfig and imx_v6_v7_defconfig targets, the following
> build error is observed:
>
> drivers/pinctrl/core.c:87:6: error: redefinition of 'pinctrl_provide_dummies'
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Shawn can you ACK/NACK this patch?

Yours,
Linus Walleij
