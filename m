Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2IRLxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:53:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38125 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab2IRLxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <1347951240-11548-1-git-send-email-richard.zhao@freescale.com>
References: <1347951240-11548-1-git-send-email-richard.zhao@freescale.com>
Date: Tue, 18 Sep 2012 13:53:38 +0200
Message-ID: <CACRpkdZE28oxRgaWob_tSYM1dc7jr09FzWqERhd_GfmcV_LmzA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: imx: remove duplicated const
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, dong.aisheng@linaro.org,
        shawn.guo@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 8:54 AM, Richard Zhao
<richard.zhao@freescale.com> wrote:

> fix smatch warning:
> drivers/pinctrl/pinctrl-imx.c:435:21: warning: duplicate const
>
> Signed-off-by: Richard Zhao <richard.zhao@freescale.com>

Patch applied with Dong's ACK!

Thank you for running smatch, BTW much appreciated.

Yours,
Linus Walleij
