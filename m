Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1G3TAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:00:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62939 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1G3TAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:00:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110729180422.07355fdb.rdunlap@xenotime.net>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
	<20110729180422.07355fdb.rdunlap@xenotime.net>
Date: Sat, 30 Jul 2011 15:00:15 -0400
X-Google-Sender-Auth: Oceptekv-XIqtYQhey7Mi7xp1-U
Message-ID: <CAP=VYLrtcQ_zWxXSqD+wHV=rk6z03wCdhivVPNt43D+Fw+b4tg@mail.gmail.com>
Subject: Re: [PATCH -next] x86: devicetree.h needs export.h
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 9:04 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> devicetree.c needs to include linux/export.h to fix build errors.

Applied to module.h-split, thanks.

P.

>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  arch/x86/kernel/devicetree.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-next-20110729.orig/arch/x86/kernel/devicetree.c
> +++ linux-next-20110729/arch/x86/kernel/devicetree.c
> @@ -2,6 +2,7 @@
>  * Architecture specific OF callbacks.
>  */
>  #include <linux/bootmem.h>
> +#include <linux/export.h>
>  #include <linux/io.h>
>  #include <linux/interrupt.h>
>  #include <linux/list.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
