Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2LCJHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:07:12 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53542 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2LCJHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:07:09 -0500
MIME-Version: 1.0
In-Reply-To: <1354027788.13128.1.camel@phoenix>
References: <1354027788.13128.1.camel@phoenix>
Date: Mon, 3 Dec 2012 14:37:09 +0530
Message-ID: <CAJuYYwRdBdi+gG944ZcJk8xF6hLUD165iX0oLn9HWeyo3od+hA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: exynos5440/samsung: Staticize pcfgs
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2012 20:19, Axel Lin <axel.lin@ingics.com> wrote:
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

Acked-by: Thomas Abraham <thomas.abraham@linaro.org>

Dear Mr. Kim,

Could you please consider this patch in your next pull request for fixes.

Thanks,
Thomas.

[...]
