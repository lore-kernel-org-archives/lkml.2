Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2LDHJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:09:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59209 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2LDHJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <1354160120-1923-1-git-send-email-qingx@marvell.com>
References: <1354160120-1923-1-git-send-email-qingx@marvell.com>
Date: Tue, 4 Dec 2012 15:09:44 +0800
Message-ID: <CAN1soZw-s9jKp3eoLWfOvp_sr0G5FrsVgixR238h5o_8zdKUZQ@mail.gmail.com>
Subject: Re: [PATCH v4 7/7] mfd: max8925: add dts
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Qing Xu <qingx@marvell.com>
Cc: Linux Russell <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, cxie4@marvell.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 11:35 AM, Qing Xu <qingx@marvell.com> wrote:
> From: Qing Xu <qingx@marvell.com>
>
> add max8925 dts support into mmp2 brownstone platform
>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>  arch/arm/boot/dts/mmp2-brownstone.dts |  158 +++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/mmp2.dtsi           |    4 +-
>  2 files changed, 161 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/boot/dts/mmp2-brownstone.dts b/arch/arm/boot/dts/mmp2-brownstone.dts
> index c9b4f27..f03d4f4 100644
> --- a/arch/arm/boot/dts/mmp2-brownstone.dts
> +++ b/arch/arm/boot/dts/mmp2-brownstone.dts
> @@ -29,6 +29,164 @@
>                         };
>                         twsi1: i2c@d4011000 {
>                                 status = "okay";
> +                               pmic: max8925@3c {
> +                                       compatible = "maxim,max8925";
> +                                       reg = <0x3c>;
> +                                       interrupts = <1>;
> +                                       interrupt-parent = <&intcmux4>;
> +                                       interrupt-controller;
> +                                       #interrupt-cells = <1>;
> +                                       tsc-irq = <0>;
> +
> +                                       regulators {
> +                                               SDV1 {
> +                                                       regulator-min-microvolt = <637500>;
> +                                                       regulator-max-microvolt = <1425000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               SDV2 {
> +                                                       regulator-min-microvolt = <650000>;
> +                                                       regulator-max-microvolt = <2225000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               SDV3 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO1 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO2 {
> +                                                       regulator-min-microvolt = <650000>;
> +                                                       regulator-max-microvolt = <2250000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO3 {
> +                                                       regulator-min-microvolt = <650000>;
> +                                                       regulator-max-microvolt = <2250000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO4 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO5 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO6 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO7 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO8 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO9 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO10 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                               };
> +                                               LDO11 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO12 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO13 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO14 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO15 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO16 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO17 {
> +                                                       regulator-min-microvolt = <650000>;
> +                                                       regulator-max-microvolt = <2250000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO18 {
> +                                                       regulator-min-microvolt = <650000>;
> +                                                       regulator-max-microvolt = <2250000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO19 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               LDO20 {
> +                                                       regulator-min-microvolt = <750000>;
> +                                                       regulator-max-microvolt = <3900000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                       };
> +                                       backlight {
> +                                               max8925-dual-string = <0>;
> +                                       };
> +                                       charger {
> +                                               batt-detect = <0>;
> +                                               topoff-threshold = <1>;
> +                                               fast-charge = <7>;
> +                                               no-temp-support = <0>;
> +                                               no-insert-detect = <0>;
> +                                       };
> +                               };
>                         };
>                         rtc: rtc@d4010000 {
>                                 status = "okay";
> diff --git a/arch/arm/boot/dts/mmp2.dtsi b/arch/arm/boot/dts/mmp2.dtsi
> index 80f74e2..76f9cc7 100644
> --- a/arch/arm/boot/dts/mmp2.dtsi
> +++ b/arch/arm/boot/dts/mmp2.dtsi
> @@ -41,7 +41,7 @@
>                                 mrvl,intc-nr-irqs = <64>;
>                         };
>
> -                       intcmux4@d4282150 {
> +                       intcmux4: interrupt-controller@d4282150 {
>                                 compatible = "mrvl,mmp2-mux-intc";
>                                 interrupts = <4>;
>                                 interrupt-controller;
> @@ -196,6 +196,8 @@
>                                 compatible = "mrvl,mmp-twsi";
>                                 reg = <0xd4011000 0x1000>;
>                                 interrupts = <7>;
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
>                                 mrvl,i2c-fast-mode;
>                                 status = "disabled";
>                         };
> --
> 1.7.0.4
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
