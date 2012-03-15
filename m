Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab2COIAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:00:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62267 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab2COIAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 04:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120314233926.GA22887@windriver.com>
References: <20120314233926.GA22887@windriver.com>
Date: Thu, 15 Mar 2012 09:00:50 +0100
X-Google-Sender-Auth: fTChLjsLGwe3MZjHxv2W3UiPmfE
Message-ID: <CAMuHMdV45SBg+cm0+x07SfvY-xpjqb_ZVznn-vD=70G1YZXnFw@mail.gmail.com>
Subject: Re: linux-next: triage for March 14, 2012
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 00:39, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> New breakage since last report:

Seems you missed two new failures for m68k/allmodconfig:

include/linux/mmc/core.h:128:20: error: field 'completion' has incomplete type
make[4]: *** [drivers/mmc/card/mmc_test.o] Error 1

drivers/staging/android/persistent_ram.c:457:2: error: implicit
declaration of function 'memblock_reserve'
[-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[4]: *** [drivers/staging/android/persistent_ram.o] Error 1

> m68k:allmodconfig
>       when:   Mar 9, 00:38
>       why:    ERROR: "__udivdi3" [drivers/media/dvb/frontends/rtl2830.ko] undefined!

This seems to be fixed, unless it doesn't get that far anymore.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
