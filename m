Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab2HVFmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:42:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44379 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab2HVFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:42:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1208220729440.1966@localhost6.localdomain6>
References: <1344069330-29569-1-git-send-email-Julia.Lawall@lip6.fr>
 <1345608994.1895.73.camel@vkoul-udesk3> <CAGsJ_4yjzE3eNGz=AA7gGxGNkjBH8bKRAUsYXcG+A1p8PtOQPw@mail.gmail.com>
 <alpine.DEB.2.02.1208220729440.1966@localhost6.localdomain6>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Aug 2012 13:41:42 +0800
Message-ID: <CAGsJ_4wkyY7VkrgMwGwmFF4kpGiGEtU8Ox46G-yOspAi27Lqgg@mail.gmail.com>
Subject: Re: [PATCH] drivers/dma/sirf-dma.c: fix usage of devm functions
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry Song <baohua.song@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/22 Julia Lawall <julia.lawall@lip6.fr>:
> On Wed, 22 Aug 2012, Barry Song wrote:
>
>> 2012/8/22 Vinod Koul <vinod.koul@linux.intel.com>:
>>>
>>> On Sat, 2012-08-04 at 10:35 +0200, Julia Lawall wrote:
>>>>
>>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>>
>>>> Fix some problems with the use of devm_ functions.
>>>
>>> Applied, thanks
>>
>>
>> the git log "drivers/dma/sirf-dma.c: fix usage of devm functions"
>> should be fixed.
>
>
> What do you suggest?  The patch is about problems with the use of
> devm_kzalloc, devm_ioremap, and devm_request_irq.

i mean the prefix

dmaengine: sirf: .............

>
> thanks,
> julia

-barry
