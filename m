Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab1JRKfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 06:35:25 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:38844 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1JRKfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 06:35:24 -0400
Subject: Re: [PATCH] unicore32: EXPORT_SYMBOL needs export.h
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
In-Reply-To: <1318927906.25468.2.camel@phoenix>
References: <1318927906.25468.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Tue, 18 Oct 2011 18:36:48 +0800
Message-ID: <1318934208.1789.48.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems the same problem with cross-compiler.
And I can't produce the same warnings.

Thanks Axel.

Guan Xuetao

On Tue, 2011-10-18 at 16:51 +0800, Axel Lin wrote:
> Include export.h to fix below warning:
> 
>   CC      arch/unicore32/mm/init.o
> arch/unicore32/mm/init.c:227: warning: data definition has no type or storage class
> arch/unicore32/mm/init.c:227: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
> arch/unicore32/mm/init.c:227: warning: parameter names (without types) in function declaration
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against linux-next 20111014.
> export.h only exist in Paul's tree now.
> I think this patch should route via Paul's module.h splitup tree.
> 
> Axel
>  arch/unicore32/mm/init.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
> index 2d3e711..3b379cd 100644
> --- a/arch/unicore32/mm/init.c
> +++ b/arch/unicore32/mm/init.c
> @@ -20,6 +20,7 @@
>  #include <linux/memblock.h>
>  #include <linux/sort.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/export.h>
>  
>  #include <asm/sections.h>
>  #include <asm/setup.h>


