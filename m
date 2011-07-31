Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1GaGcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 02:32:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:50787 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1GaGcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 02:32:05 -0400
Date: Sun, 31 Jul 2011 02:31:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <linux-media@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110731063128.GE31842@windriver.com>
References: <20110729152533.73329e8bafd4e839e85f0555@canb.auug.org.au>
 <20110729153707.389b56be0b6d51c31324fe5d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729153707.389b56be0b6d51c31324fe5d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: linux-next: build failure after merge of the moduleh tree] On 29/07/2011 (Fri 15:37) Stephen Rothwell wrote:

[...]

> 
> Forget that, it was not the correct patch.  Instead I have added this
> patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 15:34:32 +1000
> Subject: [PATCH] ir-raw: include kmod.h for request_module

Thanks, I just saw the same thing while retesting sparc on the latest
master content.  Applied to queue.

Paul.

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/media/rc/ir-raw.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
> index 56adca8..1ebaf5b 100644
> --- a/drivers/media/rc/ir-raw.c
> +++ b/drivers/media/rc/ir-raw.c
> @@ -15,6 +15,7 @@
>  #include <linux/kthread.h>
>  #include <linux/mutex.h>
>  #include <linux/export.h>
> +#include <linux/kmod.h>
>  #include <linux/sched.h>
>  #include <linux/freezer.h>
>  #include "rc-core-priv.h"
> -- 
> 1.7.5.4
> 
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
