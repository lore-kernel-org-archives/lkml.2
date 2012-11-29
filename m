Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2K2SZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:25:08 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44258 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab2K2SZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:25:06 -0500
Message-ID: <50B7A87E.5070302@wwwdotorg.org>
Date: Thu, 29 Nov 2012 11:25:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Sivaram Nair <sivaramn@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: tegra: moving stuff away from mach/clk.h
References: <1353999553-5196-1-git-send-email-sivaramn@nvidia.com> <1353999553-5196-2-git-send-email-sivaramn@nvidia.com> <50B6FCE5.7080003@nvidia.com>
In-Reply-To: <50B6FCE5.7080003@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 11:12 PM, Prashant Gaikwad wrote:
> On Tuesday 27 November 2012 12:29 PM, Sivaram Nair wrote:
>> This patch moves some stuff away from mach/clk.h to other mach-tegra
>> files. This is part of the efforts to get rid of mach/clk.h which in
>> turn will help to enable single zImage.
>>
>> Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
>> ---
>>   arch/arm/mach-tegra/clock.c            |    1 +
>>   arch/arm/mach-tegra/clock.h            |   12 ++++++++++--
>>   arch/arm/mach-tegra/include/mach/clk.h |   11 -----------
>>   3 files changed, 11 insertions(+), 13 deletions(-)
> 
> This patch will not add any real value since I have removed clk_cfg_ex
> functionality in clock code rework.
> It's just that I will have to rebase my changes on this.
> 
> Reviewed-by: Prashant Gaikwad <pgaikwad@nvidia.com>

In that case, I may as well not apply patch 2/2 at all, and I'll just
take your clock code cleanup instead. I assume that will be posted for
inclusion into 3.9?
