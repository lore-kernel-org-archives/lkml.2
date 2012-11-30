Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2K3HJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:09:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18008 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2K3HJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:09:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 29 Nov 2012 23:08:50 -0800
Message-ID: <50B85B91.6080802@nvidia.com>
Date: Fri, 30 Nov 2012 12:39:05 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sivaram Nair <sivaramn@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: tegra: moving stuff away from mach/clk.h
References: <1353999553-5196-1-git-send-email-sivaramn@nvidia.com> <1353999553-5196-2-git-send-email-sivaramn@nvidia.com> <50B6FCE5.7080003@nvidia.com> <50B7A87E.5070302@wwwdotorg.org>
In-Reply-To: <50B7A87E.5070302@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2012 11:55 PM, Stephen Warren wrote:
> On 11/28/2012 11:12 PM, Prashant Gaikwad wrote:
>> On Tuesday 27 November 2012 12:29 PM, Sivaram Nair wrote:
>>> This patch moves some stuff away from mach/clk.h to other mach-tegra
>>> files. This is part of the efforts to get rid of mach/clk.h which in
>>> turn will help to enable single zImage.
>>>
>>> Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
>>> ---
>>>    arch/arm/mach-tegra/clock.c            |    1 +
>>>    arch/arm/mach-tegra/clock.h            |   12 ++++++++++--
>>>    arch/arm/mach-tegra/include/mach/clk.h |   11 -----------
>>>    3 files changed, 11 insertions(+), 13 deletions(-)
>> This patch will not add any real value since I have removed clk_cfg_ex
>> functionality in clock code rework.
>> It's just that I will have to rebase my changes on this.
>>
>> Reviewed-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> In that case, I may as well not apply patch 2/2 at all, and I'll just
> take your clock code cleanup instead. I assume that will be posted for
> inclusion into 3.9?

Yes, I am targeting for 3.9.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

