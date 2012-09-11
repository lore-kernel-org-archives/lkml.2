Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2IKNbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:31:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46337 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2IKNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:31:13 -0400
MIME-Version: 1.0
In-Reply-To: <1347368390-31252-12-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
	<1347368390-31252-1-git-send-email-arnd@arndb.de>
	<1347368390-31252-12-git-send-email-arnd@arndb.de>
Date: Tue, 11 Sep 2012 06:31:11 -0700
Message-ID: <CACRpkdb5Tkb5xGzuU=Mw9amfG+218dyzQaQsRZKm9cws71Vd9w@mail.gmail.com>
Subject: Re: [PATCH 12/16] ARM: nomadik: move platform_data definitions
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Westin <andreas.westin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 5:59 AM, Arnd Bergmann <arnd@arndb.de> wrote:

>  arch/arm/mach-nomadik/board-nhk8815.c                                |    2 +-
>  arch/arm/mach-u300/core.c                                            |    2 +-
>  arch/arm/mach-ux500/board-mop500.c                                   |    2 +-
>  arch/arm/mach-ux500/cpu-db8500.c                                     |    2 +-
>  arch/arm/mach-ux500/devices-common.h                                 |    2 +-
>  arch/arm/mach-ux500/usb.c                                            |    2 +-
>  drivers/crypto/ux500/cryp/cryp_core.c                                |    2 +-
>  drivers/crypto/ux500/hash/hash_core.c                                |    2 +-
>  drivers/input/keyboard/nomadik-ske-keypad.c                          |    2 +-
>  drivers/mtd/nand/nomadik_nand.c                                      |    2 +-
>  drivers/pinctrl/pinctrl-coh901.c                                     |    2 +-
>  drivers/usb/musb/ux500_dma.c                                         |    2 +-
>  .../include/mach => include/linux/platform_data}/crypto-ux500.h      |    0
>  .../plat/ske.h => include/linux/platform_data/keypad-nomadik-ske.h   |    0
>  .../mach/nand.h => include/linux/platform_data/mtd-nomadik-nand.h    |    0
>  .../mach/gpio-u300.h => include/linux/platform_data/pinctrl-coh901.h |    0

I sent a patch for moving gpio-u300.h like this in commit
651728507140246e9cf4e809f1877cb2eddbc84e
that is already in linux-next, is this the same patch or
another one?

>  .../mach/usb.h => include/linux/platform_data/usb-musb-ux500.h       |    0
>  17 files changed, 12 insertions(+), 12 deletions(-)
>  rename {arch/arm/mach-ux500/include/mach => include/linux/platform_data}/crypto-ux500.h (100%)
>  rename arch/arm/plat-nomadik/include/plat/ske.h => include/linux/platform_data/keypad-nomadik-ske.h (100%)
>  rename arch/arm/mach-nomadik/include/mach/nand.h => include/linux/platform_data/mtd-nomadik-nand.h (100%)
>  rename arch/arm/mach-u300/include/mach/gpio-u300.h => include/linux/platform_data/pinctrl-coh901.h (100%)
>  rename arch/arm/mach-ux500/include/mach/usb.h => include/linux/platform_data/usb-musb-ux500.h (100%)

For the rest, Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
