Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab2EOMqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:46:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab2EOMqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:46:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 00/12] pinctrl for Ux500 and Nomadik family
Date: Tue, 15 May 2012 12:46:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Olof Johansson <olof@lixom.net>
References: <1336470214-23407-1-git-send-email-linus.walleij@stericsson.com> <201205151124.13047.arnd@arndb.de> <CACRpkdZrs=rgfadRCcMYxhwqib96vkRdHCoC-27dyAjEu5Y5Ew@mail.gmail.com>
In-Reply-To: <CACRpkdZrs=rgfadRCcMYxhwqib96vkRdHCoC-27dyAjEu5Y5Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151246.45384.arnd@arndb.de>
X-Provags-ID: V02:K0:RSNz4Zu2ek41sAw0Ir75Fwo2u1Oz/MzCdeWx4efCMjG
 JZQitOXgnreAPNjHTjtD0A8u3zStFGOWHx8DBiGY+1Dn5GH4o0
 1BGGxXo7/c7tJZZWeONQhvZJypiu8jH6WWyRLDehD2qsS5Emqx
 wLkSj2OQuqWGhJ6MR6YhsIaqD4fhQ1RzJ13p6inmpPzx9yaVgg
 TP5BXNfVcyY8kUraby3pYj/v1iIQuXlb6FDyieh7z9fl5qqx4O
 uGf6fEb5xl8NTaHwFH2ndEW7vJmL80vK5T0aN5e7a8JcdwS9vQ
 EQjHNnATK6TXdnh4IP4Yoe7/lTRWW05Olv/iVOmRGIkRQ2uo+c
 J7Hkp5uUBEsXJx+uyrX0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2012, Linus Walleij wrote:
> On Tue, May 15, 2012 at 1:24 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > I get build errors with nhk8815_defconfig after this:
> >
> > arch/arm/mach-nomadik/built-in.o: In function `nhk8815_eth_init':
> > /home/arnd/linux-arm/arch/arm/mach-nomadik/board-nhk8815.c:224: undefined reference to `nmk_gpio_set_mode'
> > arch/arm/mach-nomadik/built-in.o: In function `nhk8815_i2c_init':
> > /home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:46: undefined reference to `nmk_gpio_set_mode'
> > /home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:47: undefined reference to `nmk_gpio_set_mode'
> > /home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:50: undefined reference to `nmk_gpio_set_mode'
> > /home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:51: undefined reference to `nmk_gpio_set_mode'
> >
> > Here is my suggested fix:
> 
> This looks perfect Arnd, thanks for fixing this!
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Ok, applied to next/pinctrl.

On a more general note, how shall we go about merging pinctrl stuff in the
upcoming merge window? We've got a bunch of changes in arm-soc now that depend
on your pinctrl/devel branch, and I want to get as many of my own patches
merged upstream early.

One option would be that you just try to be very early with sending your
branch and arm-soc goes directly after that, another option would be that
we send a pull request for your tree along with the stuff that depends on
it, with your permission.

> I plan to migrate also the Nomadik to pinctrl and delete the old open-coded
> interfaces in the driver for the next kernel cycle.

Sounds good.

	Arnd
