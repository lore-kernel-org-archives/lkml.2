Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1GGCks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 22:40:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35004 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab1GGCkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 22:40:46 -0400
Subject: Re: [PATCH 2/2] dmaengine: remove ste_dma40 from issue_pending TODO
From: Vinod Koul <vkoul@infradead.org>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>
In-Reply-To: <1309123793-7806-3-git-send-email-per.forlin@linaro.org>
References: <1309123793-7806-1-git-send-email-per.forlin@linaro.org>
	 <1309123793-7806-3-git-send-email-per.forlin@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Thu, 07 Jul 2011 07:30:32 +0530
Message-ID: <1310004032.20150.14.camel@psiaudioba-mobl1>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-26 at 23:29 +0200, Per Forlin wrote:
> ste_dma40 now implements issue_pending according to documentation.
> Submit adds descriptos to a pending queue with are flushed down to the DMAC
> at issue_pending.
> 
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
How about the client driver which are currently using this driver, wont
they break as they would be calling submit and not issue_pending...?

> ---
>  drivers/dma/TODO |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/TODO b/drivers/dma/TODO
> index a4af858..734ed02 100644
> --- a/drivers/dma/TODO
> +++ b/drivers/dma/TODO
> @@ -9,6 +9,5 @@ TODO for slave dma
>  	- mxs-dma.c
>  	- dw_dmac
>  	- intel_mid_dma
> -	- ste_dma40
>  4. Check other subsystems for dma drivers and merge/move to dmaengine
>  5. Remove dma_slave_config's dma direction.

-- 
~Vinod Koul
Intel Corp.

