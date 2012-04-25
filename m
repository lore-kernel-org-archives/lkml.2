Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2DYJoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:44:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14112 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2DYJn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:43:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 25 Apr 2012 02:43:58 -0700
Message-ID: <4F97C709.2060807@nvidia.com>
Date: Wed, 25 Apr 2012 15:12:33 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] dmaengine: tegra: add dma driver
References: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com>	 <1334920487.31825.98.camel@vkoul-udesk3> <4F9153AF.7020901@nvidia.com>	 <1335170491.31825.104.camel@vkoul-udesk3> <4F95483F.5020005@nvidia.com>	 <20120423130659.GA22186@n2100.arm.linux.org.uk>	 <4F95567E.3090605@nvidia.com>  <4F97BD67.1050300@nvidia.com> <1335346425.31825.118.camel@vkoul-udesk3>
In-Reply-To: <1335346425.31825.118.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2012 03:03 PM, Vinod Koul wrote:
> On Wed, 2012-04-25 at 14:31 +0530, Laxman Dewangan wrote:
>> I had a  communication with Russell on another change thread and
>> understand that some more work need to be done in virt_chan to support
>> cyclic one.
>>
>> I want to have the cyclic dma support in my driver so I want to go on
>> following steps:
>> 1. I will post the patch for tegra dma which will not use the virt_dma
>> so that my driver will be independent of Russel's change.
> which driver? A new driver for cyclic support only or on top of
> Russell's changes?

I am referring the Nvidia Tegra's APB dma driver. This will be 
completely new driver based on dmaengine. We have old dma driver under 
mach-tegra/dma.c which has tegra specific apis. Want to move this driver 
to generic dmaengine based api.

Russell is working on Omap's dma driver.
These are completely independent driver.

