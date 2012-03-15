Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238Ab2COOe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:34:26 -0400
Received: from mail1.windriver.com ([147.11.146.13]:43838 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760319Ab2COOeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:34:22 -0400
Message-ID: <4F61FDE7.7040003@windriver.com>
Date: Thu, 15 Mar 2012 10:34:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: triage for March 14, 2012
References: <20120314233926.GA22887@windriver.com> <CAMuHMdV45SBg+cm0+x07SfvY-xpjqb_ZVznn-vD=70G1YZXnFw@mail.gmail.com>
In-Reply-To: <CAMuHMdV45SBg+cm0+x07SfvY-xpjqb_ZVznn-vD=70G1YZXnFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-15 04:00 AM, Geert Uytterhoeven wrote:
> On Thu, Mar 15, 2012 at 00:39, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> New breakage since last report:
> 
> Seems you missed two new failures for m68k/allmodconfig:
> 
> include/linux/mmc/core.h:128:20: error: field 'completion' has incomplete type
> make[4]: *** [drivers/mmc/card/mmc_test.o] Error 1

Thanks -- at some point, if this seems worthwhile, I'll have to
automate things a bit more (need to go look at that pointer you'd
sent me earlier).  At the moment, I'm not 100% apt to notice when
an old failure is replaced with a new failure on the same target
on the same day.

Paul.

> 
> drivers/staging/android/persistent_ram.c:457:2: error: implicit
> declaration of function 'memblock_reserve'
> [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[4]: *** [drivers/staging/android/persistent_ram.o] Error 1
> 
>> m68k:allmodconfig
>>       when:   Mar 9, 00:38
>>       why:    ERROR: "__udivdi3" [drivers/media/dvb/frontends/rtl2830.ko] undefined!
> 
> This seems to be fixed, unless it doesn't get that far anymore.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
