Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2FEMsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:48:43 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40105 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab2FEMsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:48:41 -0400
MIME-Version: 1.0
In-Reply-To: <1338261278-17962-1-git-send-email-festevam@gmail.com>
References: <1338261278-17962-1-git-send-email-festevam@gmail.com>
Date: Tue, 5 Jun 2012 14:48:40 +0200
Message-ID: <CACRpkdb78NY=RmC7bXOKzmBkDHU=DdcJOvDY2uyQ0OPN_v5Rwg@mail.gmail.com>
Subject: Re: [PATCH] drivers: pinctrl: Remove redefinition of 'pinctrl_provide_dummies'
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawn.guo@linaro.org>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 5:14 AM, Fabio Estevam <festevam@gmail.com> wrote:

> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> For mxs_defconfig and imx_v6_v7_defconfig targets, the following
> build error is observed:
>
> drivers/pinctrl/core.c:87:6: error: redefinition of 'pinctrl_provide_dummies'
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Shawn, have a look at this too...

Fabio, please use subject:
pinctrl: mxs: foo

Yours,
Linus Walleij
