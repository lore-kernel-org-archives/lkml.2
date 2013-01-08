Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3AHLio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:38:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11956 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab3AHLil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:38:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Jan 2013 03:34:11 -0800
Message-ID: <50EC0531.3010505@nvidia.com>
Date: Tue, 8 Jan 2013 17:08:25 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/2] dma: tegra: add channel wise pause control support
 and Tegra114 SoCs.
References: <1357489323-21359-1-git-send-email-ldewangan@nvidia.com> <20130108105447.GG19691@intel.com>
In-Reply-To: <20130108105447.GG19691@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2013 04:24 PM, Vinod Koul wrote:
> On Sun, Jan 06, 2013 at 09:52:01PM +0530, Laxman Dewangan wrote:
>> This patch series add the channel wise pause control on dma driver and then
>> add support for Tegra114 SoCs.
>>
>> The orginal change was in single patch and based on review comment, trying to split
>> the change to have more meaningful changelog matches with actual code change.
> Applied thanks
>
> Can you check my next, I got some conflicts and resolved them manually

Thanks you very much. I saw the change and it is fine. No issue in merge.

Thanks,
Laxman
