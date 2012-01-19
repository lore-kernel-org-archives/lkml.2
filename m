Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2ASNxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 08:53:24 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56985 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2ASNxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 08:53:23 -0500
MIME-Version: 1.0
In-Reply-To: <1326874624-17867-1-git-send-email-zhzhl555@gmail.com>
References: <1326874624-17867-1-git-send-email-zhzhl555@gmail.com>
Date: Thu, 19 Jan 2012 14:53:22 +0100
X-Google-Sender-Auth: 5W650dofBqf57SOlMFCKhTsCwkM
Message-ID: <CAKnu2Mp9pV+aGb1r2q4h=CfOzsKN8Nz3tRbmEQOiRGOZ_Nw91Q@mail.gmail.com>
Subject: Re: [PATCH V3] MIPS: Add RTC support for loongson1B
From: Linus Walleij <linus.walleij@linaro.org>
To: zhzhl555@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, keguang.zhang@gmail.com, wuzhangjin@gmail.com,
        r0bertz@gentoo.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/18  <zhzhl555@gmail.com>:

> From: zhao zhang <zhzhl555@gmail.com>
>
> This patch adds RTC support(TOY counter0) for loongson1B SOC
>
> change log:
> V3:Remove sync instruction.
> V2:Use new module_platform_driver macro.
> V1:Replace __raw_writel/__raw_readl with writel/readl.
>
> Signed-off-by: zhao zhang <zhzhl555@gmail.com>

I think this is looking good now.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

You need Andrew to pick it up though, so send it directly to him
as well.

Yours,
Linus Walleij
