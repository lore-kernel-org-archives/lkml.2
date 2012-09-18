Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2IRNCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:02:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51576 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2IRNCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <1347973228-29839-1-git-send-email-stigge@antcom.de>
References: <1347973228-29839-1-git-send-email-stigge@antcom.de>
Date: Tue, 18 Sep 2012 10:02:06 -0300
Message-ID: <CAAAP30F=TTyZtRk+EOK+u0e_5Km=T9ibhvA+4--pA7cfxHjYew@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: LPC32xx: DTS update for devicetree completion of spi-pl022
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-arm-kernel@lists.infradead.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 10:00 AM, Roland Stigge <stigge@antcom.de> wrote:
> spi-pl022 got a further update to its devicetree support, completing properties
> such that no platform data is necessary anymore. This patch adjusts
> lpc32xx.dtsi accordingly.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

>
> ---
> I will do a git pull request for arm-soc.git when the respective change in
> spi-pl022.c is merged.
>
>  arch/arm/boot/dts/lpc32xx.dtsi |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
> +++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
> @@ -91,6 +91,7 @@
>                                 compatible = "arm,pl022", "arm,primecell";
>                                 reg = <0x20084000 0x1000>;
>                                 interrupts = <0x14 0>;
> +                               pl022,bus-id = <0>;
>                         };
>
>                         spi1: spi@20088000 {
> @@ -102,6 +103,7 @@
>                                 compatible = "arm,pl022", "arm,primecell";
>                                 reg = <0x2008c000 0x1000>;
>                                 interrupts = <0x15 0>;
> +                               pl022,bus-id = <1>;
>                         };
>
>                         spi2: spi@20090000 {
