Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1HRK76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:59:58 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:56910 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1HRK74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:59:56 -0400
MIME-Version: 1.0
In-Reply-To: <1313566827-29636-1-git-send-email-geert@linux-m68k.org>
References: <1313566827-29636-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 18 Aug 2011 12:59:54 +0200
X-Google-Sender-Auth: TxusZszp3u0AFRAeYPSCA4tAp7o
Message-ID: <CAMuHMdWpYneoQQTX8224-G=2766qzOUbj=7ktFR206yd7A=+4g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.1-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 09:40, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.1-rc2[1] compared to v3.0[2].
>
> Summarized:
>  - build errors: +95/-34
>  - build warnings: +183/-259
>
> JFYI, when comparing v3.1-rc2 to v3.1-rc1[3], the summaries are:
>  - build errors: +24/-10
>  - build warnings: +52/-39
>
> In addition, I've put the verbose summary at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.1-rc2.summary.gz
> so you can easily find out for which configs and architectures the
> errors/warnings you're interested in are happening.
>
> Happy fixing! ;-)
>
> Thanks to the linux-next team for providing the build service.
>
> [1] http://kisskb.ellerman.id.au/kisskb/head/4271/ (all 107 configs)

Due to a bug in my scripts, I missed new config 108, namely
BF537-STAMP_defconfig
(which is the first config ever with upper case characters ;-).

This adds one more warning:

src/sound/soc/blackfin/bf5xx-ad73311.c:195: warning: initialization
from incompatible pointer type

I updated v3.1-rc2.summary.gz on kernel.org.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
