Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1AFQEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:04:04 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:35174 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1AFQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:04:02 -0500
Date: Thu, 06 Jan 2011 11:03:41 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jiri Slaby <jslaby@suse.cz>
Cc: len.brown@intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 1/1] ia64: fix build of ioremap_cache
In-reply-to: <1294302687-8051-1-git-send-email-jslaby@suse.cz>
Message-id: <alpine.LFD.2.02.1101061103010.17728@x980>
References: <4D257CD9.8060909@gmail.com>
 <1294302687-8051-1-git-send-email-jslaby@suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
> index 009a7e0..e5a6c35 100644
> --- a/arch/ia64/include/asm/io.h
> +++ b/arch/ia64/include/asm/io.h
> @@ -428,7 +428,7 @@ extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size
>  extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
>  static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
>  {
> -	return ioremap(unsigned long phys_addr, unsigned long size);
> +	return ioremap(phys_addr, size);
>  }

I pushed this fix 9 days ago, what tree are you running?

thanks,
Len Brown, Intel Open Source Technology Center

