Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2AZUlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:41:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17171 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2AZUlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:41:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jan 2012 12:40:51 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 12:40:06 -0800
Subject: RE: [PATCH v1 7/8] ARM: tegra: support for Tegra30 CPU powerdomains
Thread-Topic: [PATCH v1 7/8] ARM: tegra: support for Tegra30 CPU powerdomains
Thread-Index: AczcTSWF/qZeziILTM6+NhegTFgESAAHWnvQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB8247C@HQMAIL01.nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
 <1327597641-7519-8-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1327597641-7519-8-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, January 26, 2012 10:07 AM:
> Secondary CPU powerdomains can be powergated on Tegra30. Add the necessary
> functions to do this. This will be used to boot the secondary CPUs later on.

> diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c

> -int __init tegra_powergate_init(void)
...
> +int  __init tegra_powergate_init(void)

You added an extra space there; probably not really worth fixing unless
you repost for some other reason.

-- 
nvpublic

