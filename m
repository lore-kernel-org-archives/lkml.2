Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1FME4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 00:56:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51105 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1FME4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 00:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iNs2P+nIMGSyfSgen+9OhvxM5wmJ4BagnZnBGFHcF4CljFSjFgkvOoczsg0+m2gJ8Q
         /VkVeS6iUeB3QwrLjDymJ67jAXR5AQbGUqGCFLkvTlljKspPsHDnnGC2s/bdDIZl8YNs
         OfZNhPAU1LEI8nBOtwfQubJA/uuP9TTep/qQc=
MIME-Version: 1.0
In-Reply-To: <1307939723-2953-1-git-send-email-wanlong.gao@gmail.com>
References: <1307939723-2953-1-git-send-email-wanlong.gao@gmail.com>
Date: Sun, 12 Jun 2011 21:56:16 -0700
Message-ID: <BANLkTiknFkJ+TE5OYBuJm8gOoi1pMzbzTA@mail.gmail.com>
Subject: Re: [PATCH] Documentation:fix the wrong file position in sched-arch.txt
From: Connor Hansen <cmdkhh@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 9:35 PM, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> The arch i386 had changed to x86.

$ grep -R "i386" Documentation/ | wc -l
155

Fix them all with:
grep -lZR "i386" Documentation/ | xargs -0 -l sed -i -e 's/i386/x86/g'

or send ~ 100 patches

-Connor

>
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
>  Documentation/scheduler/sched-arch.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/scheduler/sched-arch.txt b/Documentation/scheduler/sched-arch.txt
> index d43dbcb..28aa107 100644
> --- a/Documentation/scheduler/sched-arch.txt
> +++ b/Documentation/scheduler/sched-arch.txt
> @@ -66,7 +66,7 @@ Your cpu_idle routines need to obey the following rules:
>            barrier issued (followed by a test of need_resched with
>            interrupts disabled, as explained in 3).
>
> -arch/i386/kernel/process.c has examples of both polling and
> +arch/x86/kernel/process.c has examples of both polling and
>  sleeping idle functions.
>
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
