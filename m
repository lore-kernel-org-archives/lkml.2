Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2FKQY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:24:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39827 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2FKQYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:24:54 -0400
Message-ID: <4FD61BD2.8050802@gmail.com>
Date: Mon, 11 Jun 2012 11:24:50 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH] ARM: Fix dts files w/ status property: "disable" -> "disabled"
References: <1339427460-23007-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1339427460-23007-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 10:11 AM, Roland Stigge wrote:
> This patches fixes some status = "disable" strings to "disabled", the correct
> way of disabling nodes in the devicetree.
> 
> lpc32xx.dtsi is fixed separately in the LPC32xx patch set due to the many
> changes there.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> 
> ---
> Applies to v3.5-rc2
> 
>  arch/arm/boot/dts/omap3-beagle.dts |    4 +--
>  arch/arm/boot/dts/omap4-panda.dts  |    6 ++---
>  arch/arm/boot/dts/omap4-sdp.dts    |    4 +--
>  arch/arm/boot/dts/tegra20.dtsi     |   36 +++++++++++++++++------------------
>  arch/arm/boot/dts/tegra30.dtsi     |   38 ++++++++++++++++++-------------------
>  5 files changed, 44 insertions(+), 44 deletions(-)
> 
> --- linux-2.6.orig/arch/arm/boot/dts/omap3-beagle.dts
> +++ linux-2.6/arch/arm/boot/dts/omap3-beagle.dts
> @@ -61,9 +61,9 @@
>  };
>  
>  &mmc2 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc3 {
> -	status = "disable";
> +	status = "disabled";
>  };
> --- linux-2.6.orig/arch/arm/boot/dts/omap4-panda.dts
> +++ linux-2.6/arch/arm/boot/dts/omap4-panda.dts
> @@ -74,15 +74,15 @@
>  };
>  
>  &mmc2 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc3 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc4 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc5 {
> --- linux-2.6.orig/arch/arm/boot/dts/omap4-sdp.dts
> +++ linux-2.6/arch/arm/boot/dts/omap4-sdp.dts
> @@ -147,11 +147,11 @@
>  };
>  
>  &mmc3 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc4 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc5 {
> --- linux-2.6.orig/arch/arm/boot/dts/tegra20.dtsi
> +++ linux-2.6/arch/arm/boot/dts/tegra20.dtsi
> @@ -72,7 +72,7 @@
>  		reg = <0x70002800 0x200>;
>  		interrupts = <0 13 0x04>;
>  		nvidia,dma-request-selector = <&apbdma 2>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	tegra_i2s2: i2s@70002a00 {
> @@ -80,7 +80,7 @@
>  		reg = <0x70002a00 0x200>;
>  		interrupts = <0 3 0x04>;
>  		nvidia,dma-request-selector = <&apbdma 1>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	serial@70006000 {
> @@ -88,7 +88,7 @@
>  		reg = <0x70006000 0x40>;
>  		reg-shift = <2>;
>  		interrupts = <0 36 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	serial@70006040 {
> @@ -96,7 +96,7 @@
>  		reg = <0x70006040 0x40>;
>  		reg-shift = <2>;
>  		interrupts = <0 37 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	serial@70006200 {
> @@ -104,7 +104,7 @@
>  		reg = <0x70006200 0x100>;
>  		reg-shift = <2>;
>  		interrupts = <0 46 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	serial@70006300 {
> @@ -112,7 +112,7 @@
>  		reg = <0x70006300 0x100>;
>  		reg-shift = <2>;
>  		interrupts = <0 90 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	serial@70006400 {
> @@ -120,7 +120,7 @@
>  		reg = <0x70006400 0x100>;
>  		reg-shift = <2>;
>  		interrupts = <0 91 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	i2c@7000c000 {
> @@ -129,7 +129,7 @@
>  		interrupts = <0 38 0x04>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	i2c@7000c400 {
> @@ -138,7 +138,7 @@
>  		interrupts = <0 84 0x04>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	i2c@7000c500 {
> @@ -147,7 +147,7 @@
>  		interrupts = <0 92 0x04>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	i2c@7000d000 {
> @@ -156,7 +156,7 @@
>  		interrupts = <0 53 0x04>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	pmc {
> @@ -190,7 +190,7 @@
>  		interrupts = <0 20 0x04>;
>  		phy_type = "utmi";
>  		nvidia,has-legacy-mode;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	usb@c5004000 {
> @@ -198,7 +198,7 @@
>  		reg = <0xc5004000 0x4000>;
>  		interrupts = <0 21 0x04>;
>  		phy_type = "ulpi";
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	usb@c5008000 {
> @@ -206,35 +206,35 @@
>  		reg = <0xc5008000 0x4000>;
>  		interrupts = <0 97 0x04>;
>  		phy_type = "utmi";
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	sdhci@c8000000 {
>  		compatible = "nvidia,tegra20-sdhci";
>  		reg = <0xc8000000 0x200>;
>  		interrupts = <0 14 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	sdhci@c8000200 {
>  		compatible = "nvidia,tegra20-sdhci";
>  		reg = <0xc8000200 0x200>;
>  		interrupts = <0 15 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	sdhci@c8000400 {
>  		compatible = "nvidia,tegra20-sdhci";
>  		reg = <0xc8000400 0x200>;
>  		interrupts = <0 19 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	sdhci@c8000600 {
>  		compatible = "nvidia,tegra20-sdhci";
>  		reg = <0xc8000600 0x200>;
>  		interrupts = <0 31 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	pmu {
> --- linux-2.6.orig/arch/arm/boot/dts/tegra30.dtsi
> +++ linux-2.6/arch/arm/boot/dts/tegra30.dtsi
> @@ -82,7 +82,7 @@
>  		reg = <0x70006000 0x40>;
>  		reg-shift = <2>;
>  		interrupts = <0 36 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	serial@70006040 {
> @@ -90,7 +90,7 @@
>  		reg = <0x70006040 0x40>;
>  		reg-shift = <2>;
>  		interrupts = <0 37 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	serial@70006200 {
> @@ -98,7 +98,7 @@
>  		reg = <0x70006200 0x100>;
>  		reg-shift = <2>;
>  		interrupts = <0 46 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	serial@70006300 {
> @@ -106,7 +106,7 @@
>  		reg = <0x70006300 0x100>;
>  		reg-shift = <2>;
>  		interrupts = <0 90 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	serial@70006400 {
> @@ -114,7 +114,7 @@
>  		reg = <0x70006400 0x100>;
>  		reg-shift = <2>;
>  		interrupts = <0 91 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	i2c@7000c000 {
> @@ -123,7 +123,7 @@
>  		interrupts = <0 38 0x04>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	i2c@7000c400 {
> @@ -132,7 +132,7 @@
>  		interrupts = <0 84 0x04>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	i2c@7000c500 {
> @@ -141,7 +141,7 @@
>  		interrupts = <0 92 0x04>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	i2c@7000c700 {
> @@ -150,7 +150,7 @@
>  		interrupts = <0 120 0x04>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	i2c@7000d000 {
> @@ -159,7 +159,7 @@
>  		interrupts = <0 53 0x04>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	pmc {
> @@ -201,35 +201,35 @@
>  			compatible = "nvidia,tegra30-i2s";
>  			reg = <0x70080300 0x100>;
>  			nvidia,ahub-cif-ids = <4 4>;
> -			status = "disable";
> +			status = "disabled";
>  		};
>  
>  		tegra_i2s1: i2s@70080400 {
>  			compatible = "nvidia,tegra30-i2s";
>  			reg = <0x70080400 0x100>;
>  			nvidia,ahub-cif-ids = <5 5>;
> -			status = "disable";
> +			status = "disabled";
>  		};
>  
>  		tegra_i2s2: i2s@70080500 {
>  			compatible = "nvidia,tegra30-i2s";
>  			reg = <0x70080500 0x100>;
>  			nvidia,ahub-cif-ids = <6 6>;
> -			status = "disable";
> +			status = "disabled";
>  		};
>  
>  		tegra_i2s3: i2s@70080600 {
>  			compatible = "nvidia,tegra30-i2s";
>  			reg = <0x70080600 0x100>;
>  			nvidia,ahub-cif-ids = <7 7>;
> -			status = "disable";
> +			status = "disabled";
>  		};
>  
>  		tegra_i2s4: i2s@70080700 {
>  			compatible = "nvidia,tegra30-i2s";
>  			reg = <0x70080700 0x100>;
>  			nvidia,ahub-cif-ids = <8 8>;
> -			status = "disable";
> +			status = "disabled";
>  		};
>  	};
>  
> @@ -237,28 +237,28 @@
>  		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
>  		reg = <0x78000000 0x200>;
>  		interrupts = <0 14 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	sdhci@78000200 {
>  		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
>  		reg = <0x78000200 0x200>;
>  		interrupts = <0 15 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	sdhci@78000400 {
>  		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
>  		reg = <0x78000400 0x200>;
>  		interrupts = <0 19 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	sdhci@78000600 {
>  		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
>  		reg = <0x78000600 0x200>;
>  		interrupts = <0 31 0x04>;
> -		status = "disable";
> +		status = "disabled";
>  	};
>  
>  	pmu {
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

