Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1KKVxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 16:53:49 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19233 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1KKVxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 16:53:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Nov 2011 13:53:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 11 Nov 2011 13:53:35 -0800
Subject: RE: [PATCH v4 04/10] arm/tegra: prepare early init for multiple
 tegra variants
Thread-Topic: [PATCH v4 04/10] arm/tegra: prepare early init for multiple
 tegra variants
Thread-Index: AcygZDPoq/XAvvl9QNuHPBS3Tup/bgAV+n0A
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17408058B9@HQMAIL01.nvidia.com>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
 <1321010541-31337-5-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1321010541-31337-5-git-send-email-pdeschrijver@nvidia.com>
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
> This patch splits the early init code in a common and a tegra20 specific part.
> L2 cache initialization is generalized and discovers the cache associativity
> at runtime. Also use arm_pm_restart instead of arm_arch_reset and reset the
> the system using the PMC reset feature rather then the CAR system reset.

> diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
> -void tegra_assert_system_reset(char mode, const char *cmd);

Given you explicitly removed that from the header...

> +++ b/arch/arm/mach-tegra/clock.c
>  void tegra_assert_system_reset(char mode, const char *cmd)

Maybe you want to make it static in the .c file too?

-- 
nvpublic

