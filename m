Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2LAXG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 18:06:57 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51284 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2LAXG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 18:06:56 -0500
MIME-Version: 1.0
In-Reply-To: <1354027788.13128.1.camel@phoenix>
References: <1354027788.13128.1.camel@phoenix>
Date: Sun, 2 Dec 2012 00:06:54 +0100
Message-ID: <CACRpkdaz3XmrOxAWqk-gC4sXYhy=v4SJ2FTkUHBW8QCSRzOAig@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: exynos5440/samsung: Staticize pcfgs
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 3:49 PM, Axel Lin <axel.lin@ingics.com> wrote:

> I got below build error with random config if CONFIG_PINCTRL_SAMSUNG=y &&
> CONFIG_PINCTRL_EXYNOS5440=y.
>
> Fix the build error by making pcfgs static.
>
>   LD      drivers/pinctrl/built-in.o
> drivers/pinctrl/pinctrl-exynos5440.o: In function `.LANCHOR0':
> pinctrl-exynos5440.c:(.data+0x54): multiple definition of `pcfgs'
> drivers/pinctrl/pinctrl-samsung.o:pinctrl-samsung.c:(.data+0x54): first defined here
> make[2]: *** [drivers/pinctrl/built-in.o] Error 1
> make[1]: *** [drivers/pinctrl] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

I'm not handling the Samsung drivers for this merge window.
Samsung guys, can you please pick up this patch?

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
