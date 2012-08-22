Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2HVFav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:30:51 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:62815 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab2HVFar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:30:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336341600"; 
   d="scan'208";a="170472139"
Date: Wed, 22 Aug 2012 07:30:44 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Barry Song <21cnbao@gmail.com>
cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Dan Williams <dan.j.williams@intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry Song <baohua.song@csr.com>
Subject: Re: [PATCH] drivers/dma/sirf-dma.c: fix usage of devm functions
In-Reply-To: <CAGsJ_4yjzE3eNGz=AA7gGxGNkjBH8bKRAUsYXcG+A1p8PtOQPw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1208220729440.1966@localhost6.localdomain6>
References: <1344069330-29569-1-git-send-email-Julia.Lawall@lip6.fr> <1345608994.1895.73.camel@vkoul-udesk3> <CAGsJ_4yjzE3eNGz=AA7gGxGNkjBH8bKRAUsYXcG+A1p8PtOQPw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Barry Song wrote:

> 2012/8/22 Vinod Koul <vinod.koul@linux.intel.com>:
>> On Sat, 2012-08-04 at 10:35 +0200, Julia Lawall wrote:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> Fix some problems with the use of devm_ functions.
>> Applied, thanks
>
> the git log "drivers/dma/sirf-dma.c: fix usage of devm functions"
> should be fixed.

What do you suggest?  The patch is about problems with the use of 
devm_kzalloc, devm_ioremap, and devm_request_irq.

thanks,
julia

>
>>
>>
>> --
>> ~Vinod
>>
>
> -barry
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
