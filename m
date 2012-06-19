Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2FSQOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:14:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34012 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2FSQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:14:05 -0400
Message-ID: <4FE0A546.1010707@linaro.org>
Date: Tue, 19 Jun 2012 17:13:58 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, arnd@arndb.de, linus.walleij@linaro.org,
        lrg@ti.com, swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] ARM: dts: db8500: add node property "regulator-compatible"
 regulator node
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com> <1340116099-17629-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340116099-17629-4-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/12 15:28, Laxman Dewangan wrote:
> Device's regulator matches their hardware counterparts with the
> property "regulator-compatible" of each child regulator node in
> place of the child node.
> Add the property "regulator-compatible" for each regulator with
> their name.
>
> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> ---
> Changes from V1:
>   - This is new change in V2.
>
>   arch/arm/boot/dts/db8500.dtsi |  128 +++++++++++++++++++++++++++++++----------
>   1 files changed, 97 insertions(+), 31 deletions(-)
>
> diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
> index 4ad5160..9548f80 100644
> --- a/arch/arm/boot/dts/db8500.dtsi
> +++ b/arch/arm/boot/dts/db8500.dtsi
> @@ -203,107 +203,149 @@
>
>   			db8500-prcmu-regulators {
>   				compatible = "stericsson,db8500-prcmu-regulator";
> +				#address-cells =<1>;
> +				#size-cells =<0>;

Why are these and the reg properties required?

>   				// DB8500_REGULATOR_VAPE
> -				db8500_vape_reg: db8500_vape {
> +				db8500_vape_reg: regulator@0 {
> +					reg =<0>;
> +					regulator-compatible = "db8500_vape";
>   					regulator-name = "db8500-vape";
>   					regulator-always-on;
>   				};

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
