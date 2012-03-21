Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab2CUId6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 04:33:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57810 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab2CUIdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 04:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdV45SBg+cm0+x07SfvY-xpjqb_ZVznn-vD=70G1YZXnFw@mail.gmail.com>
References: <20120314233926.GA22887@windriver.com>
	<CAMuHMdV45SBg+cm0+x07SfvY-xpjqb_ZVznn-vD=70G1YZXnFw@mail.gmail.com>
Date: Wed, 21 Mar 2012 09:33:45 +0100
X-Google-Sender-Auth: raQxj70fWWlC7s3W7GNmpOVJOYQ
Message-ID: <CAMuHMdWU2TcU=LPMQZD35Ssbfah5tuhykcfQPPkEtF_RRdjTyw@mail.gmail.com>
Subject: Re: linux-next: triage for March 14, 2012
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        gregkh@linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 09:00, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Mar 15, 2012 at 00:39, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> New breakage since last report:
>
> Seems you missed two new failures for m68k/allmodconfig:
>
> include/linux/mmc/core.h:128:20: error: field 'completion' has incomplete type
> make[4]: *** [drivers/mmc/card/mmc_test.o] Error 1
>
> drivers/staging/android/persistent_ram.c:457:2: error: implicit
> declaration of function 'memblock_reserve'
> [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[4]: *** [drivers/staging/android/persistent_ram.o] Error 1

This build failure is now in Linus' tree :-(
http://kisskb.ellerman.id.au/kisskb/buildresult/5926105/

Please fix it. Thx!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
