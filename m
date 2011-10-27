Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1J0UKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:10:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5383 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1J0UKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:10:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 27 Oct 2011 13:10:11 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 27 Oct 2011 13:10:10 -0700
Subject: RE: [PATCH 4/6] arm/tegra: implement support for tegra30
Thread-Topic: [PATCH 4/6] arm/tegra: implement support for tegra30
Thread-Index: AcyTNsPOEq/HBHi9TFSlYgJxIvbTrQBrUaPg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B49B6@HQMAIL01.nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
 <1319561644-6160-5-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1319561644-6160-5-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at  Tuesday, October 25, 2011 10:54 AM:
> From: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Some description here would be nice. And notes re: stuff like lack of
clock/... support yet, since this just gets stuff booted to a UART with
no clocks/devices/...

> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig

> +config ARCH_TEGRA_3x_SOC
> +	bool "Enable support for Tegra30 family"
> +	select CPU_V7
> +	select ARM_GIC
> +	select ARCH_REQUIRE_GPIOLIB
> +	select USB_ARCH_HAS_EHCI if USB_SUPPORT
> +	select USB_ULPI if USB_SUPPORT
> +	select USB_ULPI_VIEWPORT if USB_SUPPORT
> +	select USE_OF
> +	help
> +	  Support for NVIDIA Tegra T30 processorfamily, based on the
> +	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller

Either remove "family" or add a space before it to separate the words.

-- 
nvpublic

