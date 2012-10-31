Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2JaLoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:44:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53485 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab2JaLnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:43:55 -0400
Message-ID: <50910EEA.7000904@ti.com>
Date: Wed, 31 Oct 2012 12:43:38 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: <tony@atomide.com>, <anilkumar@ti.com>, <rob.herring@calxeda.com>,
        <hvaibhav@ti.com>, <afzal@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v3] ARM: dts: AM33xx: Add SPI node
References: <1351680669-20718-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1351680669-20718-1-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 11:51 AM, Philip, Avinash wrote:
> Add McSPI data node to AM33XX device tree file. The McSPI module (and so
> as the driver) is reused from OMAP4.
> 
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> Tested-by: Matt Porter <mporter@ti.com>
> ---

Applied in for_3.8/dts

Thanks,
Benoit

> Changes since v2:
>         - Commit message corrected.
> 	- Rebase on top of for_3.8/dts
> 
> Changes since v1:
>         - Corrected reg offset in reg DT entry.
> 
> :100644 100644 97a7bd3... 6e04789... M	arch/arm/boot/dts/am33xx.dtsi
>  arch/arm/boot/dts/am33xx.dtsi |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 97a7bd3..6e04789 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -299,5 +299,29 @@
>  				      76>;
>  			ti,hwmods = "rtc";
>  		};
> +
> +		spi0: spi@48030000 {
> +			compatible = "ti,omap4-mcspi";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0x48030000 0x400>;
> +			interrupt-parent = <&intc>;
> +			interrupt = <65>;
> +			ti,spi-num-cs = <2>;
> +			ti,hwmods = "spi0";
> +			status = "disabled";
> +		};
> +
> +		spi1: spi@481a0000 {
> +			compatible = "ti,omap4-mcspi";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0x481a0000 0x400>;
> +			interrupt-parent = <&intc>;
> +			interrupt = <125>;
> +			ti,spi-num-cs = <2>;
> +			ti,hwmods = "spi1";
> +			status = "disabled";
> +		};
>  	};
>  };
> 

