Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab2IKNqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:46:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2IKNqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:46:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 12/16] ARM: nomadik: move platform_data definitions
Date: Tue, 11 Sep 2012 13:46:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Andreas Westin <andreas.westin@stericsson.com>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-12-git-send-email-arnd@arndb.de> <CACRpkdb5Tkb5xGzuU=Mw9amfG+218dyzQaQsRZKm9cws71Vd9w@mail.gmail.com>
In-Reply-To: <CACRpkdb5Tkb5xGzuU=Mw9amfG+218dyzQaQsRZKm9cws71Vd9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209111346.40228.arnd@arndb.de>
X-Provags-ID: V02:K0:lX1D5rOtdL8EyRg2CsEXJjZsbWB0Hu3w4izlLACfm44
 AqrfIQOxtVoV4zTEC3BwBEjec72wBGmK/mnG6Irgp9pbpj96xE
 E+EH4ghzx81+BAXbhfDnCQl+NmrLaDmzRpTnYxkXVxbbF+s9WP
 Qcj2pTLqozIJwh4LIF3/mpZknLlj8rZgVLeSyuMMbO0/c+iKEd
 7m5rziqaC3izVdAOZB2MVmw7GfIMgudxTohSsEArmm5DzKhbvK
 egjpZZhCg7oCzqcDXzKFfslhnLRqfRn1Fnwu9ntW763JDoUnbx
 PC/4zlmr3p6/V6JLOzpy+B69KoC1A8mzyKniMMJO5tMEsJV6U7
 xjl40KoRxgyqeFgLFwWM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2012, Linus Walleij wrote:
> On Tue, Sep 11, 2012 at 5:59 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> >  arch/arm/mach-nomadik/board-nhk8815.c                                |    2 +-
> >  arch/arm/mach-u300/core.c                                            |    2 +-
> >  arch/arm/mach-ux500/board-mop500.c                                   |    2 +-
> >  arch/arm/mach-ux500/cpu-db8500.c                                     |    2 +-
> >  arch/arm/mach-ux500/devices-common.h                                 |    2 +-
> >  arch/arm/mach-ux500/usb.c                                            |    2 +-
> >  drivers/crypto/ux500/cryp/cryp_core.c                                |    2 +-
> >  drivers/crypto/ux500/hash/hash_core.c                                |    2 +-
> >  drivers/input/keyboard/nomadik-ske-keypad.c                          |    2 +-
> >  drivers/mtd/nand/nomadik_nand.c                                      |    2 +-
> >  drivers/pinctrl/pinctrl-coh901.c                                     |    2 +-
> >  drivers/usb/musb/ux500_dma.c                                         |    2 +-
> >  .../include/mach => include/linux/platform_data}/crypto-ux500.h      |    0
> >  .../plat/ske.h => include/linux/platform_data/keypad-nomadik-ske.h   |    0
> >  .../mach/nand.h => include/linux/platform_data/mtd-nomadik-nand.h    |    0
> >  .../mach/gpio-u300.h => include/linux/platform_data/pinctrl-coh901.h |    0
> 
> I sent a patch for moving gpio-u300.h like this in commit
> 651728507140246e9cf4e809f1877cb2eddbc84e
> that is already in linux-next, is this the same patch or
> another one?

This my older patch that I did before the mini summit, but had not sent
out yet. It's probably best if I just drop this part of the patch.

	Arnd
