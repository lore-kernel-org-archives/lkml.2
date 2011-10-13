Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1JMIeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:34:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab1JMIeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:34:36 -0400
Date: Thu, 13 Oct 2011 10:34:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] [TRIVIAL] microblaze: add missing CONFIG_ prefixes
In-Reply-To: <1318447716.8345.3.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1110131033360.14768@pobox.suse.cz>
References: <1318447716.8345.3.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Entirely untested. Somehow, I don't feel too bad about that. Added the
> maintainer and the mailinglist because this could change the behavior of
> this code.

Yes, this might make so-far unexcercised codepaths to appear, so I'd like 
to have maintainer's Ack before applying it. I don't have microblaze 
cross-compiling setup.

Thanks,

> 
>  arch/microblaze/mm/init.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
> index 213f2d6..36a133e 100644
> --- a/arch/microblaze/mm/init.c
> +++ b/arch/microblaze/mm/init.c
> @@ -304,11 +304,11 @@ asmlinkage void __init mmu_init(void)
>  	/* Map in all of RAM starting at CONFIG_KERNEL_START */
>  	mapin_ram();
>  
> -#ifdef HIGHMEM_START_BOOL
> -	ioremap_base = HIGHMEM_START;
> +#ifdef CONFIG_HIGHMEM_START_BOOL
> +	ioremap_base = CONFIG_HIGHMEM_START;
>  #else
>  	ioremap_base = 0xfe000000UL;	/* for now, could be 0xfffff000 */
> -#endif /* CONFIG_HIGHMEM */
> +#endif /* CONFIG_HIGHMEM_START_BOOL */
>  	ioremap_bot = ioremap_base;
>  
>  	/* Initialize the context management stuff */
> -- 
> 1.7.4.4
> 
> 
> 

-- 
Jiri Kosina
SUSE Labs
