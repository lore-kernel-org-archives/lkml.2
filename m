Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab2EOM0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:26:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33118 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab2EOM03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:26:29 -0400
MIME-Version: 1.0
In-Reply-To: <201205151124.13047.arnd@arndb.de>
References: <1336470214-23407-1-git-send-email-linus.walleij@stericsson.com>
	<201205151124.13047.arnd@arndb.de>
Date: Tue, 15 May 2012 14:26:28 +0200
Message-ID: <CACRpkdZrs=rgfadRCcMYxhwqib96vkRdHCoC-27dyAjEu5Y5Ew@mail.gmail.com>
Subject: Re: [PATCH 00/12] pinctrl for Ux500 and Nomadik family
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 1:24 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> I get build errors with nhk8815_defconfig after this:
>
> arch/arm/mach-nomadik/built-in.o: In function `nhk8815_eth_init':
> /home/arnd/linux-arm/arch/arm/mach-nomadik/board-nhk8815.c:224: undefined reference to `nmk_gpio_set_mode'
> arch/arm/mach-nomadik/built-in.o: In function `nhk8815_i2c_init':
> /home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:46: undefined reference to `nmk_gpio_set_mode'
> /home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:47: undefined reference to `nmk_gpio_set_mode'
> /home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:50: undefined reference to `nmk_gpio_set_mode'
> /home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:51: undefined reference to `nmk_gpio_set_mode'
>
> Here is my suggested fix:

This looks perfect Arnd, thanks for fixing this!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

I plan to migrate also the Nomadik to pinctrl and delete the old open-coded
interfaces in the driver for the next kernel cycle.

Yours,
Linus Walleij
