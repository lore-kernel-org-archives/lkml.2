Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1GGCkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 22:40:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:57637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab1GGCki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 22:40:38 -0400
Subject: Re: [PATCH 0/4] DMA40 patches for 3.1
From: Vinod Koul <vkoul@infradead.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robert Marklund <robert.marklund@stericsson.com>,
        Per Forlin <per.forlin@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        om prakash <omprakash.pal@stericsson.com>
In-Reply-To: <1309167190-23295-1-git-send-email-linus.walleij@stericsson.com>
References: <1309167190-23295-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Thu, 07 Jul 2011 07:26:45 +0530
Message-ID: <1310003805.20150.12.camel@psiaudioba-mobl1>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 11:33 +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This is a few ST-Ericsson incremental internal patches to the DMA40 driver
> that I extracted, and added a consolidation patch on top. Currently the
> only major missing piece is runtime PM.
> 
> Linus Walleij (1):
>   dmaengine/ste_dma40: use AMBA PrimeCell helper macros
> 
> Rabin Vincent (1):
>   dmaengine/ste_dma40: allow memory buswidth/burst to be configured
> 
> Robert Marklund (1):
>   dmaengine/ste_dma40: make the cyclic alloc NOWAIT
> 
> Om Prakash (1):
>   dmaengine/ste_dma40: fix missing kernel-doc
> 
>  drivers/dma/ste_dma40.c    |  244 ++++++++++++++++++++++++--------------------
>  drivers/dma/ste_dma40_ll.h |    3 -
>  2 files changed, 131 insertions(+), 116 deletions(-)
> 
Changes look okay to me... though i am not happy with logging is done in
this driver. Just eats my screen space...

I am on road so would be unable to apply these now, if you want to
update feel free to send it by early next week. Otherwise I am okay to
take this set

-- 
~Vinod Koul
Intel Corp.

