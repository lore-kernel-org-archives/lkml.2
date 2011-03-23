Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1CWOOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:14:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43960 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1CWOOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rYfKKPN87oPWMdvZSNGN5RLDJ+bgweyBr3ypYWt6LFhtzEZ6mHa779PoTs+qG4i6kD
         7c0hKwfP+6UVd0nwdW+Vr83/VtozL7BK60kL+ESuYx90hTaxlkqPq6mlXRc4DhC32Lkt
         3GPXaB/93m+Yw87w5oN4GguIRIoF46xspGVVM=
MIME-Version: 1.0
In-Reply-To: <1300884395-13835-2-git-send-email-namhyung@gmail.com>
References: <1300884395-13835-1-git-send-email-namhyung@gmail.com>
	<1300884395-13835-2-git-send-email-namhyung@gmail.com>
Date: Wed, 23 Mar 2011 15:14:50 +0100
Message-ID: <AANLkTi=jogANzNXK7e4K013NzAppJRQWEQsJ5apy4hUX@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, dumpstack: use %pT format specifier for stack trace
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

2011/3/23 Namhyung Kim <namhyung@gmail.com>:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> ---
>  arch/x86/kernel/dumpstack.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 914065620f2c..809d027de28f 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -27,7 +27,7 @@ static int die_counter;
>
>  void printk_address(unsigned long address, int reliable)
>  {
> -       printk(" [<%p>] %s%pS\n", (void *) address,
> +       printk(" [<%p>] %s%pT\n", (void *) address,
>                        reliable ? "" : "? ", (void *) address);
>  }
>
> --
> 1.7.4
>
>
