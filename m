Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1KUQyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:54:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37055 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1KUQyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:54:23 -0500
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <alpine.LNX.2.00.1111202157170.17195@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1111202157170.17195@swampdragon.chaosbits.net>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Mon, 21 Nov 2011 10:54:00 -0600
Message-ID: <CAHrUA374rf6rsq4xMLrxRrFsdZvfed3KCUHcYf+b=21LPYVkDQ@mail.gmail.com>
Subject: Re: [PATCH] Remove unneeded include of version.h from arch/hexagon/include/asm/spinlock_types.h
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-hexagon@vger.kernel.org, Richard Kuo <rkuo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Linas Vepstas <linasvepstas@gmail.com>

On 20 November 2011 14:59, Jesper Juhl <jj@chaosbits.net> wrote:
> "make versioncheck" points out that arch/hexagon/include/asm/spinlock_types.h
> does not need to include version.h .
> A quick look at the file seems to confirm its findings, so here's a patch that
> removes the include.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  arch/hexagon/include/asm/spinlock_types.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
>  Please note: I've not done any compile tests or other tests to confirm
>              this patch since I have no way to build stuff for this
>              architecture, so please review carefully before applying.
>
> diff --git a/arch/hexagon/include/asm/spinlock_types.h b/arch/hexagon/include/asm/spinlock_types.h
> index 5e937af..99b5a75 100644
> --- a/arch/hexagon/include/asm/spinlock_types.h
> +++ b/arch/hexagon/include/asm/spinlock_types.h
> @@ -21,8 +21,6 @@
>  #ifndef _ASM_SPINLOCK_TYPES_H
>  #define _ASM_SPINLOCK_TYPES_H
>
> -#include <linux/version.h>
> -
>  #ifndef __LINUX_SPINLOCK_TYPES_H
>  # error "please don't include this file directly"
>  #endif
> --
> 1.7.7.3
>
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-hexagon" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
