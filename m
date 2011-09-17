Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1IQUR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 16:17:56 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:59228 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1IQURz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 16:17:55 -0400
Message-ID: <4E75006F.2090909@bootc.net>
Date: Sat, 17 Sep 2011 21:17:51 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: adam radford <aradford@gmail.com>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, Adam Radford <linuxraid@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: iommu_iova leak [inside 3w-9xxx]
References: <4E734467.3040703@bootc.net> <1316256305.24257.25.camel@shinybook.infradead.org> <AD4B8103-C98F-4BC5-9F7F-496D220781F3@bootc.net> <3A4FADE6-3653-46C5-B225-8200F9DCE35B@bootc.net> <CAHtARFHfxpU1JKu4092ZshvhsrRY-hx_pfnL3_+T32B3ncgWvg@mail.gmail.com>
In-Reply-To: <CAHtARFHfxpU1JKu4092ZshvhsrRY-hx_pfnL3_+T32B3ncgWvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/2011 20:22, adam radford wrote:
> On Sat, Sep 17, 2011 at 7:29 AM, Chris Boot<bootc@bootc.net>  wrote:
>> On 17 Sep 2011, at 12:57, Chris Boot wrote:
>>> On 17 Sep 2011, at 11:45, Woodhouse, David wrote:
>>>> I suppose it's vaguely possible that we're leaking them in such a way
>>>> that they remain on the rbtree, perhaps if the deferred unmap is never
>>>> actually happening... but I think it's a whole lot more likely that the
>>>> PCI driver is just never bothering to unmap the pages it maps.
> If you think 3w-9xxx is not unmapping pages it maps, please re-run with
> CONFIG_PCI_DMA_DEBUG=y

I can't find a CONFIG_PCI_DMA_DEBUG to enable in 3.1-rc6. Did you mean 
CONFIG_DMA_API_DEBUG?

And as David Woodhouse mentions, the 3ware card houses my root 
filesystem - is there a way I can debug without unloading the module? If 
not I guess I can try to work around it but it would be difficult.

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net
