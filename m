Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab1IIPFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 11:05:19 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54612 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1IIPFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 11:05:17 -0400
MIME-Version: 1.0
In-Reply-To: <4E683413.6010009@snapgear.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
	<1315383059-3673-13-git-send-email-yong.zhang0@gmail.com>
	<4E683413.6010009@snapgear.com>
Date: Fri, 9 Sep 2011 17:05:15 +0200
X-Google-Sender-Auth: QfyLb6G8OZOUSnxHhK_z9L-8mH0
Message-ID: <CAMuHMdVopb8wkUa5rn48_Zp4y33HaXUr0-BGE6N-6p2PAt=hag@mail.gmail.com>
Subject: Re: [PATCH 12/62] m64k: irq: Remove IRQF_DISABLED
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, Sam Creasey <sammy@sammy.net>,
        Greg Ungerer <gerg@uclinux.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 05:18, Greg Ungerer <gerg@snapgear.com> wrote:
> On 07/09/11 18:10, Yong Zhang wrote:
>>
>> This flag is a NOOP and can be removed now.
>>
>> Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>
>
> Looks ok to me:
>
> Acked-by: Greg Ungerer <gerg@uclinux.org>

Except for the subject, it's m68k, not m64k ;-)

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Sorry, I missed the introductary email [0/62]. But do you expect the individual
maintainers to take these patches, or are you just collecting Acks?

>> ---
>>  arch/m68k/include/asm/floppy.h         |    2 +-
>>  arch/m68k/include/asm/irq.h            |    4 ++--
>>  arch/m68k/include/asm/sun3xflop.h      |    2 +-
>>  arch/m68k/platform/68328/timers.c      |    2 +-
>>  arch/m68k/platform/68360/config.c      |    2 +-
>>  arch/m68k/platform/coldfire/pit.c      |    2 +-
>>  arch/m68k/platform/coldfire/sltimers.c |    4 ++--
>>  arch/m68k/platform/coldfire/timers.c   |    4 ++--
>>  8 files changed, 11 insertions(+), 11 deletions(-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
