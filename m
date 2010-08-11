Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab0HKIFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:05:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42275 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0HKIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:05:46 -0400
Message-ID: <4C6259CE.70109@monstr.eu>
Date: Wed, 11 Aug 2010 10:05:34 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
CC: "Steven J. Magnani" <steve@digidescorp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        John Williams <john.williams@petalogix.com>,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] arch/microblaze: Removing dead CONTIGUOUS_PAGE_ALLOC
 config option
References: <20100810120052.GA26802@faui49.informatik.uni-erlangen.de>
In-Reply-To: <20100810120052.GA26802@faui49.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Dietrich wrote:
> CONFIG_CONTIGUOUS_PAGE_ALLOC doesn't exist in Kconfig, therefore removing
> all references to it from the source.

Applied.

Thanks,
Michal

> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---
>  arch/microblaze/include/asm/page.h |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
> index 4f268fa..1f033c6 100644
> --- a/arch/microblaze/include/asm/page.h
> +++ b/arch/microblaze/include/asm/page.h
> @@ -205,9 +205,6 @@ extern int page_is_ram(unsigned long pfn);
>  #define TOPHYS(addr)  __virt_to_phys(addr)
>  
>  #ifdef CONFIG_MMU
> -#ifdef CONFIG_CONTIGUOUS_PAGE_ALLOC
> -#define WANT_PAGE_VIRTUAL 1 /* page alloc 2 relies on this */
> -#endif
>  
>  #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
>  				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
