Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0JXJ6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:58:50 -0400
Received: from www.tglx.de ([62.245.132.106]:49524 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab0JXJ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:58:49 -0400
Date: Sun, 24 Oct 2010 11:58:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/15] x86, visws: Set_fixmap in find_smp_config
In-Reply-To: <1287882149-29275-9-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1010241157060.2466@localhost6.localdomain6>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-9-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Yinghai Lu wrote:

-ENOREASON.

Also visws does it set already in cobalt_init(). So this is redundant
crap.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/visws_quirks.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
> index 3371bd0..a70bc71 100644
> --- a/arch/x86/kernel/visws_quirks.c
> +++ b/arch/x86/kernel/visws_quirks.c
> @@ -211,6 +211,7 @@ static void __init visws_find_smp_config(void)
>  		MP_processor_info(mp++);
>  
>  	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
> +	set_fixmap(FIX_APIC_BASE, APIC_DEFAULT_PHYS_BASE);
>  }
>  
>  static void visws_trap_init(void);
> -- 
> 1.7.1
> 
