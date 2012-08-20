Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2HTO36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:29:58 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50868 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab2HTO34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:29:56 -0400
MIME-Version: 1.0
In-Reply-To: <1344689809-6223-11-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-11-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 20 Aug 2012 16:29:55 +0200
Message-ID: <CACRpkda+X5-GtsMJ07TA7UBbbk1W+pJzTtQjQJ8VPD9z_5UoDQ@mail.gmail.com>
Subject: Re: [PATCH 10/11] arm: mvebu: enable PINCTRL usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>
> Now that we have a proper pinctrl driver for Marvell EBU platforms,
> enable PINCTRL support in ARCH_MVEBU.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

(...)
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 361f513..95317a9 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -573,6 +573,7 @@ config ARCH_MVEBU
>         select GENERIC_IRQ_CHIP
>         select IRQ_DOMAIN
>         select COMMON_CLK
> +       select PINCTRL
>         help
>           Support for the Marvell SoC Family with device tree support

So this symbol collects all the DT-migrated platforms?

Probably OK but want to figure out if the PLAT_NOMADIK symbol
is applicable.

Yours,
Linus Walleij
