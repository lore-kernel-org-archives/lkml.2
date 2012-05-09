Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2EIKbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:31:24 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14176 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2EIKbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:31:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 09 May 2012 03:31:22 -0700
Message-ID: <4FAA46A6.4090003@nvidia.com>
Date: Wed, 9 May 2012 15:57:50 +0530
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
Subject: Re: [PATCH V2 1/2] dma: dmaengine: add slave req id in slave_config
References: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>	 <1336030889-32269-2-git-send-email-ldewangan@nvidia.com> <1336553358.1540.169.camel@vkoul-udesk3>
In-Reply-To: <1336553358.1540.169.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for review.

On Wednesday 09 May 2012 02:19 PM, Vinod Koul wrote:
> On Thu, 2012-05-03 at 13:11 +0530, Laxman Dewangan wrote:
>> The dma controller like Nvidia's Tegra Dma controller
>> supports the different slave requestor id from different slave.
>> This need to be configure in dma controller to handle the request
>> properly.
>>
>> Adding the slave-id in the slave configuration so that information
>> can be passed from client when configuring for slave.
>>
>>   	u32 dst_maxburst;
>>   	bool device_fc;
>> +	int slave_id;
> This wont be negative, so perhaps an unsigned value?

Fine, I will make it unsigned int in my next patch.

