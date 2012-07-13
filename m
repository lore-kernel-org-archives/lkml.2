Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030260Ab2GMFqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:46:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13121 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2GMFqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:46:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 12 Jul 2012 22:46:05 -0700
Message-ID: <4FFFB476.9050006@nvidia.com>
Date: Fri, 13 Jul 2012 11:09:02 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] dma: tegra: fix residual calculation for cyclic case
References: <1341217328-6676-1-git-send-email-ldewangan@nvidia.com>	 <4FF1C62B.5070005@wwwdotorg.org> <1342149336.1726.5.camel@vkoul-udesk3>
In-Reply-To: <1342149336.1726.5.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2012 08:45 AM, Vinod Koul wrote:
> On Mon, 2012-07-02 at 10:02 -0600, Stephen Warren wrote:
>> On 07/02/2012 02:22 AM, Laxman Dewangan wrote:
>>> In cyclic mode of DMA, the byte transferred can be more
>>> than the requested size and in this case, calculating
>>> residuals based on the current position of DMA transfer to
>>> bytes requested i.e. bytes required to transfer to reach
>>> bytes requested from current DMA position.
>>>
>>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>> This makes sense to me, although I wonder if details like this aren't
>> something that the dmaengine core should be handling.
> No core doesn't know anything about the how much you are transferring
> and where you are. That is the driver to calculate and provide.

Just for confirmation, are you going to apply this patch or do I need to 
do anything here.

Thanks,
Laxman

