Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab2DWMSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:18:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15832 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab2DWMSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:18:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 23 Apr 2012 05:18:10 -0700
Message-ID: <4F95483F.5020005@nvidia.com>
Date: Mon, 23 Apr 2012 17:47:03 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: rmk <rmk@arm.linux.org.uk>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH V1] dmaengine: tegra: add dma driver
References: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com>	 <1334920487.31825.98.camel@vkoul-udesk3>  <4F9153AF.7020901@nvidia.com> <1335170491.31825.104.camel@vkoul-udesk3>
In-Reply-To: <1335170491.31825.104.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,
On Monday 23 April 2012 02:11 PM, Vinod Koul wrote:
> On Fri, 2012-04-20 at 17:46 +0530, Laxman Dewangan wrote:
>> Thanks Vinod for quick review.
> Since I was on vacation, I hadn't noticed Russell has already sent the
> patches for omap dma support.
> http://permalink.gmane.org/gmane.linux.ports.arm.omap/75034
>
> It would be nice if both the efforts are coordinated.
>
> Btw I like the virtual channel support introduced by Russell
>

Can you please point me the virtual channel related change? I am not 
able to locate this like search for function vchan_* ().
My driver is also on same line but not used vchan_* and also having 
support for cyclic transfer.



