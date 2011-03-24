Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab1CXL66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:58:58 -0400
Received: from ra.se.axis.com ([195.60.68.13]:37064 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab1CXL65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:58:57 -0400
Date: Thu, 24 Mar 2011 12:58:54 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [PATCH] cris: Change function name from alloc_thread_info to
	alloc_thread_info_node
Message-ID: <20110324115854.GY3976@axis.com>
References: <1300946448-8468-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300946448-8468-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 07:00:48AM +0100, Nobuhiro Iwamatsu wrote:
> By commit b6a84016bd2598e35ead635147fa53619982648d, alloc_thread_info was
> replaced by alloc_thread_info_node.
> However, the change of the function name was incomplete.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> CC: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  arch/cris/include/asm/thread_info.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
> index 29b74a1..6f23eca 100644
> --- a/arch/cris/include/asm/thread_info.h
> +++ b/arch/cris/include/asm/thread_info.h
> @@ -68,7 +68,7 @@ struct thread_info {
>  #define init_thread_info	(init_thread_union.thread_info)
>  
>  /* thread information allocation */
> -#define alloc_thread_info(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
> +#define alloc_thread_info_node(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
>  #define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
>  
>  #endif /* !__ASSEMBLY__ */
> -- 
> 1.7.2.3

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
