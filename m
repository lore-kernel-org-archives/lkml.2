Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1J0UWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:22:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6817 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1J0UWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:22:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 27 Oct 2011 13:22:06 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 27 Oct 2011 13:22:04 -0700
Subject: RE: [PATCH 6/6] arm/tegra: add support for tegra30 based board
 cardhu
Thread-Topic: [PATCH 6/6] arm/tegra: add support for tegra30 based board
 cardhu
Thread-Index: AcyTNsXAyMFSooEkRwi4e9gBIvvoJwBrsqow
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B49C9@HQMAIL01.nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
 <1319561644-6160-7-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1319561644-6160-7-git-send-email-pdeschrijver@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter De Schrijver wrote at Tuesday, October 25, 2011 10:54 AM:
> From: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Some description of what Cardhu is and what's done in the patch please.

> diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
> new file mode 100644
> index 0000000..0f3f8a8
> --- /dev/null
> +++ b/arch/arm/boot/dts/tegra-cardhu.dts
> @@ -0,0 +1,37 @@
> +/dts-v1/;
> +
> +/include/ "tegra30.dtsi"
> +
> +/ {
> +	model = "NVIDIA Tegra30 Cardhu evaluation board";
> +	compatible = "nvidia,cardhu", "nvidia,tegra30";
> +
> +	memory {
> +		device_type = "memory";

The other boards don't contain this. If they should, can you please post
a patch to add it to them all? Thanks.

> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> index 21c99f9..3ff191a 100644
> --- a/arch/arm/mach-tegra/Kconfig
> +++ b/arch/arm/mach-tegra/Kconfig
> @@ -83,6 +83,12 @@ config MACH_VENTANA
>         help
>           Support for the nVidia Ventana development platform
> 
> +config MACH_CARDHU
> +       bool "Cardhu board"
> +       select MACH_TEGRA_DT
> +       help
> +         Support for the nVidia Cardhu development platform

This should depend on Tegra30 support.

Please use the capitalization NVIDIA; we should do a pass and clean up
any existing instances sometime.

-- 
nvpublic

