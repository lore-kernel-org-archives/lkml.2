Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1G3Svu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 14:51:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39762 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1G3Svo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 14:51:44 -0400
MIME-Version: 1.0
In-Reply-To: <20110729120734.cec5168f.rdunlap@xenotime.net>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
	<20110729120734.cec5168f.rdunlap@xenotime.net>
Date: Sat, 30 Jul 2011 14:51:41 -0400
X-Google-Sender-Auth: yma3YLCFqgeB1aY2XkoTvRhIspk
Message-ID: <CAP=VYLqx8eqjt4V+fLyJLv7FVrhLF++XF+qHOeRbMHiYWotyRg@mail.gmail.com>
Subject: Re: [PATCH -next] x86: files need export.h
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 3:07 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Fix multiple build errors due to missing export.h header file.

I'd already pushed equivalent changes to the branch before seeing
this one.

Thanks,
Paul.

>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  arch/x86/kernel/e820.c    |    1 +
>  arch/x86/kernel/pci-dma.c |    1 +
>  arch/x86/kernel/rtc.c     |    1 +
>  3 files changed, 3 insertions(+)
>
> --- linux-next-20110729.orig/arch/x86/kernel/e820.c
> +++ linux-next-20110729/arch/x86/kernel/e820.c
> @@ -16,6 +16,7 @@
>  #include <linux/pfn.h>
>  #include <linux/suspend.h>
>  #include <linux/acpi.h>
> +#include <linux/export.h>
>  #include <linux/firmware-map.h>
>  #include <linux/memblock.h>
>  #include <linux/sort.h>
> --- linux-next-20110729.orig/arch/x86/kernel/pci-dma.c
> +++ linux-next-20110729/arch/x86/kernel/pci-dma.c
> @@ -1,6 +1,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/dma-debug.h>
>  #include <linux/dmar.h>
> +#include <linux/export.h>
>  #include <linux/bootmem.h>
>  #include <linux/gfp.h>
>  #include <linux/pci.h>
> --- linux-next-20110729.orig/arch/x86/kernel/rtc.c
> +++ linux-next-20110729/arch/x86/kernel/rtc.c
> @@ -5,6 +5,7 @@
>  #include <linux/mc146818rtc.h>
>  #include <linux/acpi.h>
>  #include <linux/bcd.h>
> +#include <linux/export.h>
>  #include <linux/pnp.h>
>  #include <linux/of.h>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
