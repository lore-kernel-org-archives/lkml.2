Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1CEVCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 16:02:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57596 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1CEVCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 16:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qPtO70XbpFFjHP8ydwRmdKoKnY1MOwCFHLeAUzXeEbTWau1yUpU4DRyN2KCYCXp44Z
         KdOLCWKjvODuIqWv8XG2usuWB9v5lAlL4g87wx2S3RBdHxJR5l6K7wKcIU9wgpVus7HM
         rWoLXD7bexG5+ZXrqv+Llasmi+13HoKjOByeU=
MIME-Version: 1.0
In-Reply-To: <20110119210840.381111598@linutronix.de>
References: <20110119205258.462759212@linutronix.de>
	<20110119210840.381111598@linutronix.de>
Date: Sat, 5 Mar 2011 22:02:33 +0100
X-Google-Sender-Auth: zxCOodIAoPkLWuux0bWcikGxy6I
Message-ID: <AANLkTi=nLFx7Z7UfiXZrBQoGgC1Fh_dh9--5T=Di9qhc@mail.gmail.com>
Subject: Re: [patch 31/37] mn10300: Use generic irq Kconfig
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 22:49, Thomas Gleixner <tglx@linutronix.de> wrote:
> No functional change.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  arch/mn10300/Kconfig |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> Index: linux-2.6/arch/mn10300/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/mn10300/Kconfig
> +++ linux-2.6/arch/mn10300/Kconfig
> @@ -1,6 +1,7 @@
>  config MN10300
>        def_bool y
>        select HAVE_OPROFILE
> +       select GENERIC_HARDIRQS

Wasn't this supposed to be "select HAVE_GENERIC_HARDIRQS"?

/me studying generic hardirqs...

>
>  config AM33_2
>        def_bool n
> @@ -76,10 +77,6 @@ config QUICKLIST
>  config ARCH_HAS_ILOG2_U32
>        def_bool y
>
> -# Use the generic interrupt handling code in kernel/irq/
> -config GENERIC_HARDIRQS
> -       def_bool y
> -
>  config HOTPLUG_CPU
>        def_bool n

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
