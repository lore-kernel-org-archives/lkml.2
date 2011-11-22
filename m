Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab1KVJrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:47:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51993 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1KVJrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:47:45 -0500
MIME-Version: 1.0
In-Reply-To: <1321864620-8925-1-git-send-email-zhzhl555@gmail.com>
References: <1321864620-8925-1-git-send-email-zhzhl555@gmail.com>
Date: Tue, 22 Nov 2011 10:47:45 +0100
Message-ID: <CACRpkda_M0voVTFAHUU8XaMrpgTfac2fiQY7-RhkwZ_BHYT+0w@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Add RTC support for loongson1B
From: Linus Walleij <linus.walleij@linaro.org>
To: zhzhl555@gmail.com
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, keguang.zhang@gmail.com, wuzhangjin@gmail.com,
        r0bertz@gentoo.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 9:37 AM,  <zhzhl555@gmail.com> wrote:

> From: zhao zhang <zhzhl555@gmail.com>
>
> This patch add RTC support(TOY counter0) for loongson1B
> Signed-off-by: zhao zhang <zhzhl555@gmail.com>
(...)
> +       __raw_writel(v, SYS_TOYWRITE0);

Why are you using __raw_* accessors everywhere?
Is something wrong with just writel()/readl() on loongson?

When I look in arch/mips/include/asm/io.h they actually
seem to be #defined to their __raw_* counterparts anyway
so it cannot hurt.

Yours,
Linus Walleij
