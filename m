Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab2LXLbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 06:31:07 -0500
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:38735 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883Ab2LXLbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 06:31:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAEk72FB8q8rO/2dsb2JhbAANN719gxEBAQEDAThAAQULCxgJFg8JAwIBAgFFBg0BBQIBAYd8AQyicZJ0jFeEQwOfWYoB
X-IronPort-AV: E=Sophos;i="4.84,346,1355068800"; 
   d="scan'208";a="296843984"
Message-ID: <50D83CF5.7090202@westnet.com.au>
Date: Mon, 24 Dec 2012 21:31:01 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: Wire up finit_module
References: <1356254998-13380-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1356254998-13380-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2012 07:29 PM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


>   arch/m68k/include/asm/unistd.h      |    2 +-
>   arch/m68k/include/uapi/asm/unistd.h |    1 +
>   arch/m68k/kernel/syscalltable.S     |    1 +
>   3 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
> index 847994c..f9337f6 100644
> --- a/arch/m68k/include/asm/unistd.h
> +++ b/arch/m68k/include/asm/unistd.h
> @@ -4,7 +4,7 @@
>   #include <uapi/asm/unistd.h>
>
>
> -#define NR_syscalls		348
> +#define NR_syscalls		349
>
>   #define __ARCH_WANT_OLD_READDIR
>   #define __ARCH_WANT_OLD_STAT
> diff --git a/arch/m68k/include/uapi/asm/unistd.h b/arch/m68k/include/uapi/asm/unistd.h
> index b94bfbf..625f321 100644
> --- a/arch/m68k/include/uapi/asm/unistd.h
> +++ b/arch/m68k/include/uapi/asm/unistd.h
> @@ -353,5 +353,6 @@
>   #define __NR_process_vm_readv	345
>   #define __NR_process_vm_writev	346
>   #define __NR_kcmp		347
> +#define __NR_finit_module	348
>
>   #endif /* _UAPI_ASM_M68K_UNISTD_H_ */
> diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
> index c30da5b..3f04ea0 100644
> --- a/arch/m68k/kernel/syscalltable.S
> +++ b/arch/m68k/kernel/syscalltable.S
> @@ -368,4 +368,5 @@ ENTRY(sys_call_table)
>   	.long sys_process_vm_readv	/* 345 */
>   	.long sys_process_vm_writev
>   	.long sys_kcmp
> +	.long sys_finit_module
>
>

