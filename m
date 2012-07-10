Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2GJMkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:40:53 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11638 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2GJMkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:40:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 10 Jul 2012 05:37:00 -0700
Message-ID: <4FFC2157.7090501@nvidia.com>
Date: Tue, 10 Jul 2012 18:04:31 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] spi: tegra: use dmaengine based dma driver
References: <1340969480-7702-1-git-send-email-ldewangan@nvidia.com> <4FEDD97A.7050702@wwwdotorg.org>
In-Reply-To: <4FEDD97A.7050702@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2012 10:06 PM, Stephen Warren wrote:
> On 06/29/2012 05:31 AM, Laxman Dewangan wrote:
>> Use the dmaengine based Tegra APB DMA driver for
>> data transfer between SPI FIFO and memory in
>> place of legacy Tegra APB DMA.
>>
>> The new driver is selected if legacy driver is not
>> selected and new DMA driver is enabled through config
>> file.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Acked-by: Stephen Warren<swarren@wwwdotorg.org>
>

Hi Mark,
Understand from Grant's mail's discussion that you are picking up the 
spi change.
Please let me know if I need to re-send this patch.

Thanks,
Laxman


