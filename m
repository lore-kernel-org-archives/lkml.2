Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0KON1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:27:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:36408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645Ab0KON1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:27:41 -0500
Date: Mon, 15 Nov 2010 14:27:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH][trivial] ARM, mm: Don't include smp_plat.h twice in
 flush.c
In-Reply-To: <alpine.LNX.2.00.1011072312490.26247@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1011151427160.7420@pobox.suse.cz>
References: <alpine.LNX.2.00.1011072312490.26247@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Jesper Juhl wrote:

> It's enough to include the asm/smp_plat.h once in arch/arm/mm/flush.c
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  flush.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
> index 391ffae..7d6e92b 100644
> --- a/arch/arm/mm/flush.c
> +++ b/arch/arm/mm/flush.c
> @@ -17,7 +17,6 @@
>  #include <asm/smp_plat.h>
>  #include <asm/system.h>
>  #include <asm/tlbflush.h>
> -#include <asm/smp_plat.h>

Doesn't seem to be present in linux-next as of today. I have picked that 
up. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
