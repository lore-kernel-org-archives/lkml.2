Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab2EKLCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:02:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6957 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276Ab2EKLC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:02:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 May 2012 04:01:40 -0700
Message-ID: <4FACF0DC.3050209@nvidia.com>
Date: Fri, 11 May 2012 16:28:36 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] dmaengine: tegra: add dma driver
References: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>	 <1336030889-32269-3-git-send-email-ldewangan@nvidia.com>	 <1336558444.1540.243.camel@vkoul-udesk3>  <4FAA4EA3.70001@nvidia.com>	 <1336620844.1540.269.camel@vkoul-udesk3>  <4FAB4C7D.7030406@nvidia.com> <1336725713.15424.1856.camel@vkoul-udesk3>
In-Reply-To: <1336725713.15424.1856.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2012 02:11 PM, Vinod Koul wrote:
> On Thu, 2012-05-10 at 10:35 +0530, Laxman Dewangan wrote:
>
>> But when we update the chan->completed_cookie for aborted cookie?
>> Otherwise I will get the DMA_IN_PROGRSS when I call dma_cookie_status()
>> but actually it is aborted.
> no in .device_tx_status, you should check if the descriptor is aborted
> or not and rteurn error for aborted descriptor.
>
OK, I will not call this function.
Also I am dropping the ONCE_NOTIFY_HALF and will add later if require. I 
realize that patch patch should be simple and sufficient so that  other 
driver development/upstream can be unblock. Later on we can add feature 
based on necessary.

I am sending the new patch with considering all your feedback.
Thanks again for review.

Thanks,
Laxman


