Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2CJLLz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 06:11:55 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:50189 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695Ab2CJLLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 06:11:54 -0500
Message-ID: <4F5B3707.1030504@metafoo.de>
Date: Sat, 10 Mar 2012 12:12:07 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dmaengine: care sd_dma_address/len in dmaengine_prep_slave_single()
References: <8739axwnh9.wl%kuninori.morimoto.gx@renesas.com>	<1327917366.1527.42.camel@vkoul-udesk3>	<87pqe04qtk.wl%kuninori.morimoto.gx@renesas.com>	<4F58806E.9090500@metafoo.de> <871up2k4o6.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <871up2k4o6.wl%kuninori.morimoto.gx@renesas.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 01:18 AM, Kuninori Morimoto wrote:
> 
> Hi Lars
> 
>> On 01/31/2012 02:13 AM, Kuninori Morimoto wrote:
>>> dmaengine_prep_slave_single() is helper macro of dmaengine.
>>> But it doesn't have sg_dma_address/len() settings which are required.
>>> And it used void *buf in parameter, but it should be dma_addr_t.
>>> This patch fixes up it.
>>>
>>> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>>
>> Hi,
>>
>> Any news regarding this patch? The dmaengine_prep_slave_single in upstream
>> is not really usable as it is right now.
> 
> Sorry. I have no news/update for this.
> I'm not good at IOMMU which was pointed by Russell.
> 
> Best regards
> ---
> Kuninori Morimoto


Well, he pointed out a minor and easy to fix flaw with the patch. But if you
don't want to resend the patch is it OK for you, if I resend the patch with the
flaw fixed? And is it OK, if I keep your Signed-off-by on that patch?

Thanks,
- Lars
