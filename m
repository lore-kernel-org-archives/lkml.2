Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2DTNpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:45:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7436 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2DTNpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:45:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Apr 2012 06:45:54 -0700
Message-ID: <4F91686A.1030000@nvidia.com>
Date: Fri, 20 Apr 2012 19:15:14 +0530
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
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] dmaengine: tegra: add dma driver
References: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com> <1334920487.31825.98.camel@vkoul-udesk3> <4F9153AF.7020901@nvidia.com>
In-Reply-To: <4F9153AF.7020901@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,
On Friday 20 April 2012 05:46 PM, Laxman Dewangan wrote:
> Thanks Vinod for quick review.
>
>>> + * @dma_dev: required DMA master client device.
>>> + * @dm_req_id: Peripheral dma requestor ID.
>>> + */
>>> +struct tegra_dma_slave {
>>> +     struct device                   *client_dev;
>>> +     enum tegra_dma_requestor        dma_req_id;
>>> +     enum tegra_dma_burst_size       burst_size;
>> pls remove
> if above is OK then I can remove this.
>

If I add one more member as slave_id for slave requester in struct 
dma_slave_config then I will not need the tegra_dma header at all and I 
can get rid of this file.
Let me know if this is OK so that I can take care of this in my next patch.

Thanks,
Laxman


