Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2HHNB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:01:28 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42943 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab2HHNB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <1344430493-5304-7-git-send-email-arnd@arndb.de>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
	<1344430493-5304-7-git-send-email-arnd@arndb.de>
Date: Wed, 8 Aug 2012 10:01:26 -0300
Message-ID: <CAOMZO5CZ7mJd89cN_S0KBS74mc5qTzvrfRbmHVX3nmEakx19ow@mail.gmail.com>
Subject: Re: [PATCH 6/6] ARM: imx: gpmi-nand depends on mxs-dma
From: Fabio Estevam <festevam@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, Aug 8, 2012 at 9:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> It is not currently possible to build the gpmi-nand driver without
> also building the mxs-dma driver. Clarify this Kconfig and enable
> both in the defconfig file so we can build it again with both enabled.
>
> drivers/built-in.o: In function `gpmi_dma_filter':
> clk-fixed-factor.c:(.text+0xafc18): undefined reference to `mxs_dma_is_apbh'
> make[1]: *** [vmlinux] Error 1
> make: *** [sub-make] Error 2
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <kernel@pengutronix.de>

I have already sent a fix for this to the mtd list:
https://patchwork.kernel.org/patch/1236551/

Regards,

Fabio Estevam
