Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab2LTR6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:58:10 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50090 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2LTR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:57:58 -0500
MIME-Version: 1.0
In-Reply-To: <1355821932-15799-2-git-send-email-fabio.baltieri@linaro.org>
References: <1355821932-15799-1-git-send-email-fabio.baltieri@linaro.org>
	<1355821932-15799-2-git-send-email-fabio.baltieri@linaro.org>
Date: Thu, 20 Dec 2012 18:57:57 +0100
Message-ID: <CACRpkdZyMWtx1s1mrNebPgJfn69tpDJmCR-w39puoxCci+vmWw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: ux500: add pinctrl address resources
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 10:12 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Current nmk_pinctrl driver is not PRCMU dependent anymore, so it needs
> its own DT address resources to work properly, as done for
> platform_device in:
>
> f482833 ARM: ux500: add PRCM register base for pinctrl
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Applied these two to the pinctrl fixes with one alteration:

> +               pinctrl@80157000 {
> +                       reg = <0x80157000 0x2000>;
>                         compatible = "stericsson,nmk_pinctrl";

I inserted a comment here like this:

                pinctrl@80157000 {
+                       // This is actually the PRCMU base address
                        reg = <0x80157000 0x2000>;

Yours,
Linus Walleij
