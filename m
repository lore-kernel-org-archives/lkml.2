Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1LJAFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 19:05:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38885 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1LJAFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 19:05:00 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
Date: Sat, 10 Dec 2011 01:04:59 +0100
Message-ID: <CACRpkdbOo6MhQhWJmT4Q49BjsAU94obKdvvsSQ=KreiL1y_owg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/9 Stephen Warren <swarren@nvidia.com>:

> Uwe Kleine-König wrote at Thursday, December 08, 2011 3:41 PM:
>> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
>
>> +config PINMUX_EFM32
>> +     bool "EFM32 pinmux driver"
>> +     depends on ARCH_EFM32
>> +     default y
>> +     select PINMUX
>
> LinusW,
>
> Since this is the pinctrl not pinmux subsystem now, does it make sense
> to name the driver Kconfig options PINCTRL_FOO and the files pinctrl-
> foo.c? I see that the coh901 driver already does that, and I followed
> that convention in my Tegra pinctrl patches.

Hm, the U300 pinmux is named pinmux-u300.c because it can only do
pinmux. It cannot do anything else. But if it's confusing we can surely
name everything pinctrl-*.

Yours,
Linus Walleij
