Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab1JRNcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:32:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:39965 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab1JRNcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:32:54 -0400
Message-ID: <4E9D7FE4.20403@windriver.com>
Date: Tue, 18 Oct 2011 09:32:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Rientjes <rientjes@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] unicore32: EXPORT_SYMBOL needs export.h
References: <1318927906.25468.2.camel@phoenix>
In-Reply-To: <1318927906.25468.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-10-18 04:51 AM, Axel Lin wrote:
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

Correct.  I will add it.

Thanks.
Paul.

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
