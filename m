Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0LNQRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:17:36 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:58574 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759483Ab0LNQRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:17:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BWJF0s+QumhyJxWa5RQnBZ0v2k36Yuw8AKuneOrniueG6eBj8gBv42FpgJKLoFhl8M
         jy+4KVn7EOjBFyqieE8iYj9R9hSlq5FU47NSxcMkmnTqg6ZcxbBgPO3NBfc1aGXyrVVW
         TOXVIc7OGk23TWwq4M88mUUMzbUE6FdN2Jfew=
MIME-Version: 1.0
In-Reply-To: <1292333615-17860-1-git-send-email-toralf.foerster@gmx.de>
References: <1292333615-17860-1-git-send-email-toralf.foerster@gmx.de>
Date: Tue, 14 Dec 2010 14:17:26 -0200
Message-ID: <AANLkTi=32w8Td-0ajaB5A9E6bE7g1-_hKk=oGcULHyFK@mail.gmail.com>
Subject: Re: [PATCH] checkpatch.pl: fix 2 of 2 errors in ./kernek/panic.c
From: Thiago Farina <tfransosi@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: kernel-janitors@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/14 Toralf Förster <toralf.foerster@gmx.de>:
>
> Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
> ---
>  kernel/panic.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 4c13b1a..13623e4 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -56,7 +56,7 @@ EXPORT_SYMBOL(panic_blink);
>  *
>  *     This function never returns.
>  */
> -NORET_TYPE void panic(const char * fmt, ...)
> +NORET_TYPE void panic(const char *fmt, ...)
>  {
>        static char buf[1024];
>        va_list args;
> @@ -75,7 +75,7 @@ NORET_TYPE void panic(const char * fmt, ...)
>        va_start(args, fmt);
>        vsnprintf(buf, sizeof(buf), fmt, args);
>        va_end(args);
> -       printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
> +       printk(KERN_EMERG "Kernel panic - not syncing: %s\n", buf);
>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>        dump_stack();
>  #endif

Can you put in the change log message the description of those errors
and resend?  Looking at this patch it seems they are just whitespace
changes or something very trivial like this.

The subject line could be something more like:
kernek/panic.c: Fix two checkpatch.pl errors:
