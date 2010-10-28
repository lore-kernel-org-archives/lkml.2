Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab0J1RJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:09:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64426 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab0J1RJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:09:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6150"; a="59597714"
Subject: Re: [PATCH 09/10] drivers/video/msm/mddi.c: Remove multiple
 KERN_<level> uses
From: Daniel Walker <dwalker@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <f1dbb5d550e2146508541335999374cf8910ff59.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
	 <f1dbb5d550e2146508541335999374cf8910ff59.1288059486.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 10:08:36 -0700
Message-ID: <1288285716.2683.12.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 19:44 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/video/msm/mddi.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
> index 7c316c3..b66d86a 100644
> --- a/drivers/video/msm/mddi.c
> +++ b/drivers/video/msm/mddi.c
> @@ -318,7 +318,7 @@ static long mddi_wait_interrupt_timeout(struct mddi_info *mddi,
>  static void mddi_wait_interrupt(struct mddi_info *mddi, uint32_t intmask)
>  {
>  	if (mddi_wait_interrupt_timeout(mddi, intmask, HZ/10) == 0)
> -		printk(KERN_INFO KERN_ERR "mddi_wait_interrupt %d, timeout "
> +		printk(KERN_INFO "mddi_wait_interrupt %d, timeout "
>  		       "waiting for %x, INT = %x, STAT = %x gotint = %x\n",
>  		       current->pid, intmask, mddi_readl(INT), mddi_readl(STAT),
>  		       mddi->got_int);
> @@ -465,8 +465,7 @@ static int __init mddi_get_client_caps(struct mddi_info *mddi)
>  
>  		if (mddi->flags & FLAG_HAVE_CAPS)
>  			break;
> -		printk(KERN_INFO KERN_ERR "mddi_init, timeout waiting for "
> -				"caps\n");
> +		printk(KERN_INFO "mddi_init, timeout waiting for caps\n");
>  	}
>  	return mddi->flags & FLAG_HAVE_CAPS;
>  }

Applied to my tree, thanks.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

