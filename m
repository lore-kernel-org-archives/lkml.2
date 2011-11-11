Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1KKWC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 17:02:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1298 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1KKWC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 17:02:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 11 Nov 2011 14:02:49 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 11 Nov 2011 14:02:49 -0800
Subject: RE: [PATCH v4 09/10] arm/tegra: implement support for tegra30
Thread-Topic: [PATCH v4 09/10] arm/tegra: implement support for tegra30
Thread-Index: AcygZDmKv2T5kkXGSRKoBKchVGAAuQAWTfSQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17408058CA@HQMAIL01.nvidia.com>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
 <1321010541-31337-10-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1321010541-31337-10-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Friday, November 11, 2011 4:22 AM:
> Add support for tegra30 SoC. This includes a device tree compatible type for
> this SoC ("nvidia,tegra30") and adds L2 cache initialization for this new SoC.
> The clock framework is still missing, which prevents most drivers from working.
> The basic IRQs are the same, so remove the dependency on
> CONFIG_ARCH_TEGRA_2x_SOC.

> diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h

>  #ifdef CONFIG_ARCH_TEGRA_2x_SOC
>  void __init tegra20_init_early(void);
>  #endif
> +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> +void __init tegra30_init_early(void);
> +#endif

Do we need to ifdef the prototypes? Same comment for Tegra30 here and
Tegra20 in the earlier patch.

-- 
nvpublic

