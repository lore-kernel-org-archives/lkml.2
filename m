Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab1GaFWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:22:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:45282 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1GaFWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:22:19 -0400
Date: Sun, 31 Jul 2011 01:22:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (probably moduleh tree related)
Message-ID: <20110731052214.GB31842@windriver.com>
References: <20110729170142.4cd1979127a0d5d864297db3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729170142.4cd1979127a0d5d864297db3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build failure after merge of the final tree (probably moduleh tree related)] On 29/07/2011 (Fri 17:01) Stephen Rothwell wrote:

[...]

> 
> I have added the folllowing patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 16:55:11 +1000
> Subject: [PATCH] dmaengine.h needs bitmap.h

Thanks, I've added it to the queue.
Paul.

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/dmaengine.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 8fbf40e..c90b17f 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -24,6 +24,7 @@
>  #include <linux/device.h>
>  #include <linux/uio.h>
>  #include <linux/dma-direction.h>
> +#include <linux/bitmap.h>
>  
>  struct scatterlist;
>  
> -- 
> 1.7.5.4
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
