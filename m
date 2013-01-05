Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3AEPf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 10:35:28 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52078 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3AEPfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 10:35:25 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
Date: Sat, 5 Jan 2013 07:35:25 -0800
Message-ID: <CAOesGMiTZvLJ6cXwMFsFc6pBGoLUEkV+WMrDOqqCcs_TEnTtUw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add GPIO driver for Allwinner SoCs
From: Olof Johansson <olof@lixom.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 4, 2013 at 8:45 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> This patch adds support for the GPIOs for the Allwinner SoCs supported so
> far.
>
> It comes on top of my previous pinctrl patchset, and has been tested on a
> A13-Olinuxino from Olimex.
>
> Thanks,
> Maxime
>
> Maxime Ripard (2):
>   ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
>   ARM: sunxi: Add the GPIOs node to the device tree
>
>  .../devicetree/bindings/gpio/gpio-sunxi.txt        |   77 ++++++++++
>  arch/arm/boot/dts/sun5i-a13.dtsi                   |   51 +++++++
>  drivers/gpio/Kconfig                               |    6 +
>  drivers/gpio/Makefile                              |    1 +
>  drivers/gpio/gpio-sunxi.c                          |  150 ++++++++++++++++++++
>  drivers/pinctrl/pinctrl-sunxi.c                    |  106 ++++++++++++++
>  drivers/pinctrl/pinctrl-sunxi.h                    |    6 +-

I haven't looked closely at the patch yet, but this is a case where it
makes sense to merge the gpio/pinctrl patch through Linus/Grant's
tree, and merge the dtsi update through arm-soc -- while you need
both, nothing is broken by having just one or the other, so taking the
separate merge paths are fine.

Linus, Grant, sound ok to you?

-Olof
