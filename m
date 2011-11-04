Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1KDUoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:44:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8001 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1KDUoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:44:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Nov 2011 13:43:58 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 4 Nov 2011 13:43:57 -0700
Subject: RE: [PATCH v2 7/8] arm/tegra: implement support for tegra30
Thread-Topic: [PATCH v2 7/8] arm/tegra: implement support for tegra30
Thread-Index: AcyZaQYs8EsmRC81T4GIyTrPN9mbBwByNIzQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E4F@HQMAIL01.nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
 <1320242948-21061-8-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1320242948-21061-8-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Wednesday, November 02, 2011 8:09 AM:
> Add support for tegra30 SoC. This includes a device tree compatible type for
> this SoC ("nvidia,tegra30") and adds L2 cache initialization for this new SoC.
> The clock framework is still missing, which prevents most drivers from working.
...
> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
...
> @@ -17,7 +14,18 @@ config ARCH_TEGRA_2x_SOC
>  	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
>  	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
> 
> -endchoice
> +config ARCH_TEGRA_3x_SOC

Wasn't that config option already used earlier in the series, e.g. in
[PATCH v2 6/8] arm/tegra: pinmux tables and definitions for tegra30.
Should this patch be pushed earlier so it isn't used before it's created?
I'm not sure how much that matters.

-- 
nvpublic

