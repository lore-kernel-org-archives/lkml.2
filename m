Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2LRXco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 18:32:44 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:59490 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2LRXck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 18:32:40 -0500
X-Greylist: delayed 807 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 18:32:40 EST
Message-ID: <50D0FD13.5060508@gmail.com>
Date: Wed, 19 Dec 2012 00:32:35 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, balbi@ti.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        p.paneri@samsung.com
Subject: Re: [PATCH 2/2] ARM: Exynos5250: Enabling USB 3.0 phy for samsung-usbphy
 driver
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com> <1355845182-14104-3-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1355845182-14104-3-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 04:39 PM, Vivek Gautam wrote:
> Adding base address information required for enabling
> USB 3.0 DRD phy on exynos5250 SOC.
>
> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>
> ---
>   arch/arm/boot/dts/exynos5250.dtsi |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index bbdb2c2..07b7477 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -316,7 +316,8 @@
>
>   	usbphy@12130000 {
>   		compatible = "samsung,exynos5250-usbphy";
> -		reg =<0x12130000 0x100>;
> +		reg =<0x12130000 0x100>,
> +		<0x12100000 0x100>;

Doesn't this second memory region mean distinct PHY controller device ?
Why separate usbphy node can't/shouldn't be created for it ?

>   		samsung,usb-phyhandle =<&phy_h0&phy_h1&phy_h2>;
>   		samsung,enable-mask =<1>;
>   	};
