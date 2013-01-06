Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3AFP57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 10:57:59 -0500
Received: from [216.228.121.140] ([216.228.121.140]:1824 "EHLO
	hqemgate03.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3AFP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 10:57:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 06 Jan 2013 07:57:23 -0800
Message-ID: <50E99ED7.4050406@nvidia.com>
Date: Sun, 6 Jan 2013 21:27:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] dma: tegra: add support for Tegra114 SoC
References: <1357387568-26010-1-git-send-email-ldewangan@nvidia.com> <20130106143738.GC29209@intel.com>
In-Reply-To: <20130106143738.GC29209@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 January 2013 08:07 PM, Vinod Koul wrote:
> On Sat, Jan 05, 2013 at 05:36:08PM +0530, Laxman Dewangan wrote:
>> NVIDIA's Tegra114 has APB DMA controller which supports channel wise
>> pause control. The global pause is used for clock gating and hence
>> DMA registers are not accessible if DMAs are globally disabled.
>>
>> Add support for use of channel wise pause feature for Tegra114 SOCs.
> Looks fine to me. Only issue being that changelog tells me you are adding
> support for 114, but patch seems more of adding pause support and while at it
> also add entries for 114.
> Care to update changelog & title...

The channel wise pause come along with T114 and that's why it is 
together in this change.
Probably I need to split the change into two patches: One for adding 
feature of channel wise pause and other for adding support of T114.
This way it will not mixup the stuff and will much clear about change.

