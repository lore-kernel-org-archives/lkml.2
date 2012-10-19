Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab2JSJOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:14:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18894 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2JSJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:14:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 19 Oct 2012 02:14:31 -0700
Message-ID: <508119CE.9070408@nvidia.com>
Date: Fri, 19 Oct 2012 14:43:50 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] ARM: tegra: fix clock entry of slink controller
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com> <1350557795-31487-4-git-send-email-ldewangan@nvidia.com> <5080862C.9030203@wwwdotorg.org>
In-Reply-To: <5080862C.9030203@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2012 04:13 AM, Stephen Warren wrote:
>
> The patch subject isn't entirely accurate here; this patch isn't just
> about fixing clock entries.
>

OK, then  will break in two patches.

>
>> +	OF_DEV_AUXDATA("nvidia,tegra20-slink", TEGRA_SLINK1_BASE, "spi-tegra-slink.0", NULL),
> Here, can't we just use the existing device names in the clock files...
>
> So we can completely drop the changes to these two files:
>
I want to name the driver as spi-tegra-slink. When we add the sflash spi 
driver for tegra20, the driver name will be spi-tegra-sflash.
Also current name is "spi_tegra" I do not want to name with "_". So it 
is require to convert as "-".



>> diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
>> diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
> The device names will hopefully be irrelevant once we're able to use
> DT-based clock lookups.
Agree, but currently we can add this to have progress.

