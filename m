Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab2HTOb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:31:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64915 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2HTObZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:31:25 -0400
MIME-Version: 1.0
In-Reply-To: <1344689809-6223-12-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-12-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 20 Aug 2012 16:31:25 +0200
Message-ID: <CACRpkdaF3OuBLC7odWyH5C_EJT9uFq1rYQMh6=kr8PQjvA68sA@mail.gmail.com>
Subject: Re: [PATCH 11/11] arm: mvebu: add pinctrl support in defconfig
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

> diff --git a/arch/arm/configs/mvebu_defconfig b/arch/arm/configs/mvebu_defconfig
> index 2e86b31..cb07e64 100644
> --- a/arch/arm/configs/mvebu_defconfig
> +++ b/arch/arm/configs/mvebu_defconfig
> @@ -21,6 +21,8 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  CONFIG_SERIAL_8250=y
>  CONFIG_SERIAL_8250_CONSOLE=y
>  CONFIG_SERIAL_OF_PLATFORM=y
> +CONFIG_PINCTRL_ARMADA_370=y
> +CONFIG_PINCTRL_ARMADA_XP=y

If the system is not even booting without pinctrl you should
(IMHO) select these from the machine's Kconfig entry insteaf.

If they boot fine without I'm fine with this ... the arch maintainer
gets to choose anyway.

Yours,
Linus Walleij
