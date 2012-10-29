Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992Ab2J2VOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:14:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52687 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760480Ab2J2VOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:14:06 -0400
Date: Mon, 29 Oct 2012 22:13:59 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/2] ARM: mach-imx: imx53.dtsi: pinctl update
Message-ID: <20121029211359.GZ1641@pengutronix.de>
References: <1351164400-27940-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351164400-27940-1-git-send-email-stigge@antcom.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:12:44 up 128 days, 12:24, 50 users,  load average: 0.24, 0.30,
 0.37
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 01:26:39PM +0200, Roland Stigge wrote:
> This patch supplements pinctl support on i.MX53.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Shawn, probably better when you take this patch as it's quite likely
that you collect other patches to this file.

Sascha

> ---
>  arch/arm/boot/dts/imx53.dtsi |   46 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> --- linux-2.6.orig/arch/arm/boot/dts/imx53.dtsi
> +++ linux-2.6/arch/arm/boot/dts/imx53.dtsi
> @@ -316,6 +316,24 @@
>  					};
>  				};
>  
> +				can1 {
> +					pinctrl_can1_1: can1grp-1 {
> +						fsl,pins = <
> +							847 0x80000000  /* MX53_PAD_PATA_INTRQ__CAN1_TXCAN */
> +							853 0x80000000  /* MX53_PAD_PATA_DIOR__CAN1_RXCAN */
> +						>;
> +					};
> +				};
> +
> +				can2 {
> +					pinctrl_can2_1: can2grp-1 {
> +						fsl,pins = <
> +							67  0x80000000  /* MX53_PAD_KEY_COL4__CAN2_TXCAN */
> +							74  0x80000000  /* MX53_PAD_KEY_ROW4__CAN2_RXCAN */
> +						>;
> +					};
> +				};
> +
>  				i2c1 {
>  					pinctrl_i2c1_1: i2c1grp-1 {
>  						fsl,pins = <
> @@ -334,6 +352,15 @@
>  					};
>  				};
>  
> +				i2c3 {
> +					pinctrl_i2c3_1: i2c3grp-1 {
> +						fsl,pins = <
> +							1102 0xc0000000	/* MX53_PAD_GPIO_6__I2C3_SDA */
> +							1130 0xc0000000	/* MX53_PAD_GPIO_5__I2C3_SCL */
> +						>;
> +					};
> +				};
> +
>  				uart1 {
>  					pinctrl_uart1_1: uart1grp-1 {
>  						fsl,pins = <
> @@ -369,6 +396,25 @@
>  						>;
>  					};
>  				};
> +
> +				uart4 {
> +					pinctrl_uart4_1: uart4grp-1 {
> +						fsl,pins = <
> +							11 0x1c5	/* MX53_PAD_KEY_COL0__UART4_TXD_MUX */
> +							18 0x1c5	/* MX53_PAD_KEY_ROW0__UART4_RXD_MUX */
> +						>;
> +					};
> +				};
> +
> +				uart5 {
> +					pinctrl_uart5_1: uart5grp-1 {
> +						fsl,pins = <
> +							24 0x1c5	/* MX53_PAD_KEY_COL1__UART5_TXD_MUX */
> +							31 0x1c5	/* MX53_PAD_KEY_ROW1__UART5_RXD_MUX */
> +						>;
> +					};
> +				};
> +
>  			};
>  
>  			uart1: serial@53fbc000 {
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
