Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab1ADBaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 20:30:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39301 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1ADBaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 20:30:03 -0500
Date: Mon, 3 Jan 2011 18:29:59 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: John Bonesio <bones@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, jdl@jdl.com,
        glikely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        david@gibson.dropbear.id.au
Subject: Re: [PATCH 4/5] powerpc/5200: dts: Change combatible strings on
 localbus
Message-ID: <20110104012959.GD27839@angua.secretlab.ca>
References: <20101117232520.25947.37475.stgit@riker>
 <20101117232847.25947.60171.stgit@riker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117232847.25947.60171.stgit@riker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:28:47PM -0800, John Bonesio wrote:
> This patch changes some incorrect compatible strings on the local plus bus node
> in dts files for MPC5200b based systems.
> 
> Signed-off-by: John Bonesio <bones@secretlab.ca>
> ---

Applied, thanks.

g.

> 
>  arch/powerpc/boot/dts/cm5200.dts    |    2 +-
>  arch/powerpc/boot/dts/digsy_mtc.dts |    2 +-
>  arch/powerpc/boot/dts/media5200.dts |    2 +-
>  arch/powerpc/boot/dts/motionpro.dts |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/boot/dts/cm5200.dts b/arch/powerpc/boot/dts/cm5200.dts
> index d549897..22f7233 100644
> --- a/arch/powerpc/boot/dts/cm5200.dts
> +++ b/arch/powerpc/boot/dts/cm5200.dts
> @@ -219,7 +219,7 @@
>  	};
>  
>  	localbus {
> -		compatible = "fsl,mpc5200b-lpb","simple-bus";
> +		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
>  		#address-cells = <2>;
>  		#size-cells = <1>;
>  		ranges = <0 0 0xfc000000 0x2000000>;
> diff --git a/arch/powerpc/boot/dts/digsy_mtc.dts b/arch/powerpc/boot/dts/digsy_mtc.dts
> index f0592de..3147b98 100644
> --- a/arch/powerpc/boot/dts/digsy_mtc.dts
> +++ b/arch/powerpc/boot/dts/digsy_mtc.dts
> @@ -218,7 +218,7 @@
>  	};
>  
>  	localbus {
> -		compatible = "fsl,mpc5200b-lpb","simple-bus";
> +		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
>  		#address-cells = <2>;
>  		#size-cells = <1>;
>  		ranges = <0 0 0xff000000 0x1000000>;
> diff --git a/arch/powerpc/boot/dts/media5200.dts b/arch/powerpc/boot/dts/media5200.dts
> index e027f45..861f09f 100644
> --- a/arch/powerpc/boot/dts/media5200.dts
> +++ b/arch/powerpc/boot/dts/media5200.dts
> @@ -270,7 +270,7 @@
>  	};
>  
>  	localbus {
> -		compatible = "fsl,mpc5200b-lpb","simple-bus";
> +		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
>  		#address-cells = <2>;
>  		#size-cells = <1>;
>  
> diff --git a/arch/powerpc/boot/dts/motionpro.dts b/arch/powerpc/boot/dts/motionpro.dts
> index 3ab4666..97cb085 100644
> --- a/arch/powerpc/boot/dts/motionpro.dts
> +++ b/arch/powerpc/boot/dts/motionpro.dts
> @@ -236,7 +236,7 @@
>  	};
>  
>  	localbus {
> -		compatible = "fsl,mpc5200b-lpb","simple-bus";
> +		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
>  		#address-cells = <2>;
>  		#size-cells = <1>;
>  		ranges = <0 0 0xff000000 0x01000000
> 
