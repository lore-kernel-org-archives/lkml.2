Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3AJLXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:23:34 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62943 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3AJLXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:23:32 -0500
MIME-Version: 1.0
In-Reply-To: <1357577261-31536-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357577261-31536-1-git-send-email-fabio.baltieri@linaro.org>
Date: Thu, 10 Jan 2013 12:23:32 +0100
Message-ID: <CACRpkdZD1i_tvDf6XFyk5muYjtDziQaMNGK6vvihhFJVztXUjw@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 5:47 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> This patch converts the module to use clk_prepare_enable and
> clk_disable_unprepare variants as required by common clock framework.
>
> Without this the system crash during probe function.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
