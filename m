Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1FOJTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:19:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1FOJTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xjMAKuFs5p6Wvlduc54XZwn/VktpuigzlL51gfoHzkclDU7mvuvv87/dRSt5wV7mM2
         g476H9uuCt0+As2X4PQGmgTEoXZpD9WRl47FOM8WIoM4F96UI39q8vjYf1sHpuS1gX57
         8JzLWHLmAVwry9g70n/ZQxPXmpSv+0chnylGI=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
Date: Wed, 15 Jun 2011 11:19:48 +0200
X-Google-Sender-Auth: coWm9wIz-wBTBHi3v3Sgw9NBqJ0
Message-ID: <BANLkTikBDVR=S5J-=Kjq1QW3OU64WzHYRg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <michael@ellerman.id.au>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 11:11, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.0-rc3[1] compared to v2.6.39[2].
>
> Summarized:
>  - build errors: +21/-66
>  - build warnings: +202/-421
>
> JFYI, when comparing v3.0-rc3 to v3.0-rc2[3], the summaries are:
>  - build errors: +20/-45
>  - build warnings: +92/-101

While looking what kind of fix got applied for one of the
improvements, I noticed it
didn't get fixed at all. But m68k/allmodconfig is broken due to an
unrelated change, after
which the build stops, so it never got to compile the file I was looking into.

Would it be possible to build with `make -k', so it continues in case
of an error, and
tries to build as much as possible?
Yes, I know this may increase build time considerably, but in an ideal
world, there
are no compile errors and everything is built anyway ;-)

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
