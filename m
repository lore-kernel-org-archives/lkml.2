Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab1ADB3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 20:29:36 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57986 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1ADB3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 20:29:34 -0500
Date: Mon, 3 Jan 2011 18:29:31 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: John Bonesio <bones@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, jdl@jdl.com,
        glikely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        david@gibson.dropbear.id.au
Subject: Re: [PATCH 3/5] powerpc/5200: dts: remove unused properties
Message-ID: <20110104012931.GC27839@angua.secretlab.ca>
References: <20101117232520.25947.37475.stgit@riker>
 <20101117232838.25947.81482.stgit@riker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117232838.25947.81482.stgit@riker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:28:39PM -0800, John Bonesio wrote:
> This patch remove unused properties in dts files in preparation of refactoring
> the dts files for MPC5200b based boards.
> 
> Signed-off-by: John Bonesio <bones@secretlab.ca>

Applied, thanks.

g.

> ---
> 
>  arch/powerpc/boot/dts/cm5200.dts    |    2 --
>  arch/powerpc/boot/dts/lite5200b.dts |    3 ---
>  arch/powerpc/boot/dts/media5200.dts |    2 --
>  arch/powerpc/boot/dts/motionpro.dts |    2 --
>  arch/powerpc/boot/dts/pcm030.dts    |    2 --
>  arch/powerpc/boot/dts/pcm032.dts    |    2 --
>  6 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/powerpc/boot/dts/cm5200.dts b/arch/powerpc/boot/dts/cm5200.dts
> index 9369dcd..d549897 100644
> --- a/arch/powerpc/boot/dts/cm5200.dts
> +++ b/arch/powerpc/boot/dts/cm5200.dts
> @@ -230,8 +230,6 @@
>  			reg = <0 0 0x2000000>;
>  			bank-width = <2>;
>  			device-width = <2>;
> -			#size-cells = <1>;
> -			#address-cells = <1>;
>  		};
>  	};
>  };
> diff --git a/arch/powerpc/boot/dts/lite5200b.dts b/arch/powerpc/boot/dts/lite5200b.dts
> index a74b790..c0a4e45 100644
> --- a/arch/powerpc/boot/dts/lite5200b.dts
> +++ b/arch/powerpc/boot/dts/lite5200b.dts
> @@ -174,7 +174,6 @@
>  
>  		psc@2000 {		// PSC1
>  			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
> -			cell-index = <0>;
>  			reg = <0x2000 0x100>;
>  			interrupts = <2 1 0>;
>  		};
> @@ -198,7 +197,6 @@
>  		// PSC4 in uart mode example
>  		//serial@2600 {		// PSC4
>  		//	compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
> -		//	cell-index = <3>;
>  		//	reg = <0x2600 0x100>;
>  		//	interrupts = <2 11 0>;
>  		//};
> @@ -206,7 +204,6 @@
>  		// PSC5 in uart mode example
>  		//serial@2800 {		// PSC5
>  		//	compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
> -		//	cell-index = <4>;
>  		//	reg = <0x2800 0x100>;
>  		//	interrupts = <2 12 0>;
>  		//};
> diff --git a/arch/powerpc/boot/dts/media5200.dts b/arch/powerpc/boot/dts/media5200.dts
> index a70ef68..e027f45 100644
> --- a/arch/powerpc/boot/dts/media5200.dts
> +++ b/arch/powerpc/boot/dts/media5200.dts
> @@ -185,8 +185,6 @@
>  		// PSC6 in uart mode
>  		console: psc@2c00 {		// PSC6
>  			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
> -			cell-index = <5>;
> -			port-number = <0>;  // Logical port assignment
>  			reg = <0x2c00 0x100>;
>  			interrupts = <2 4 0>;
>  		};
> diff --git a/arch/powerpc/boot/dts/motionpro.dts b/arch/powerpc/boot/dts/motionpro.dts
> index f6261ea..3ab4666 100644
> --- a/arch/powerpc/boot/dts/motionpro.dts
> +++ b/arch/powerpc/boot/dts/motionpro.dts
> @@ -277,8 +277,6 @@
>  			reg = <0 0 0x01000000>;
>  			bank-width = <2>;
>  			device-width = <2>;
> -			#size-cells = <1>;
> -			#address-cells = <1>;
>  		};
>  	};
>  };
> diff --git a/arch/powerpc/boot/dts/pcm030.dts b/arch/powerpc/boot/dts/pcm030.dts
> index 3a4f554..f3e30bb 100644
> --- a/arch/powerpc/boot/dts/pcm030.dts
> +++ b/arch/powerpc/boot/dts/pcm030.dts
> @@ -196,7 +196,6 @@
>  
>  		psc@2400 { /* PSC3 in UART mode */
>  			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
> -			cell-index = <2>;
>  			reg = <0x2400 0x100>;
>  			interrupts = <2 3 0>;
>  		};
> @@ -207,7 +206,6 @@
>  
>  		psc@2c00 { /* PSC6 in UART mode */
>  			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
> -			cell-index = <5>;
>  			reg = <0x2c00 0x100>;
>  			interrupts = <2 4 0>;
>  		};
> diff --git a/arch/powerpc/boot/dts/pcm032.dts b/arch/powerpc/boot/dts/pcm032.dts
> index 17596c7..e0f2702 100644
> --- a/arch/powerpc/boot/dts/pcm032.dts
> +++ b/arch/powerpc/boot/dts/pcm032.dts
> @@ -196,7 +196,6 @@
>  
>  		psc@2400 { /* PSC3 in UART mode */
>  			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
> -			cell-index = <2>;
>  			reg = <0x2400 0x100>;
>  			interrupts = <2 3 0>;
>  		};
> @@ -207,7 +206,6 @@
>  
>  		psc@2c00 { /* PSC6 in UART mode */
>  			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
> -			cell-index = <5>;
>  			reg = <0x2c00 0x100>;
>  			interrupts = <2 4 0>;
>  		};
> 
