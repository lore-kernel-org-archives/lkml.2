Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2FERPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:15:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7968 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2FERPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:15:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Jun 2012 10:13:15 -0700
Message-ID: <4FCE3CD8.8060502@nvidia.com>
Date: Tue, 5 Jun 2012 22:37:36 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/4] i2c: tegra: Bug fixes, cleanups and M_NOSTART support
References: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com> <4FCE3078.1030008@wwwdotorg.org>
In-Reply-To: <4FCE3078.1030008@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2012 09:44 PM, Stephen Warren wrote:
> On 06/05/2012 07:09 AM, Laxman Dewangan wrote:
>> This patch series having the:
>> - Handling of late register write due to Tegra PPSB design.
>> - support for I2C_M_NOSTART
>> - Use devm_* for all allocation.
> The series,
>
> Acked-by: Stephen Warren<swarren@wwwdotorg.org>
>
> Note that patch 4 touches context adjacent to Prashant's "i2c: tegra:
> Add clk_prepare/clk_unprepare" patch, which I hope to take through the
> Tegra tree since it's a requirement for the Tegra common clock
> conversion. I don't think this will cause any significant conflict, but
> perhaps it's worth resolving it explicitly.
>
> Wolfram, perhaps we should put these 4 patches and Prashan'ts into their
> own topic branch so that you can merge it into the I2C tree, and I can
> merge it into the Tegra tree too? Or, I can take everything through
> Tegra if you want, and ack it.
>
> Laxman, do you expect any more I2C-related changes this kernel cycle?
I have two more changes in plan:
-I2c controller require two clock source and the fixes towards that. 
This can go on Tegra tree as changes are require in 
mach-tegra/tegra30_clock.c, tegra20_clock.c files also.

- Run time PM support but can be done later.







