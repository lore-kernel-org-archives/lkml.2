Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab2BONzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:55:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237Ab2BONzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:55:45 -0500
Message-ID: <4F3BB94E.7010204@redhat.com>
Date: Wed, 15 Feb 2012 11:55:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Fabio Estevam <festevam@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Jan 20 (drivers/media/radio/wl128x/)
References: <20120120131243.7c867c7b96c75819b68aec8d@canb.auug.org.au> <4F1A0783.9010501@xenotime.net> <CAMuHMdX8=x-=DQu0SCbqYK00+sP8a-kR=9KrUptAq-gqOXHAhA@mail.gmail.com> <CAMuHMdWofPn9gUdPJwUDm0rqWrzKAnc=yqzDwQqrr7ZCDz6VkA@mail.gmail.com> <CAOMZO5BxFi8z-6B4GNLfibHPjBz1viH0tacoUEfVA-pjDhZjdA@mail.gmail.com> <CAMuHMdU-HQsjL-gcdr5XtK8fh+LAa-nY59K2r44hKkxeQ=P04w@mail.gmail.com>
In-Reply-To: <CAMuHMdU-HQsjL-gcdr5XtK8fh+LAa-nY59K2r44hKkxeQ=P04w@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 15-02-2012 07:47, Geert Uytterhoeven escreveu:
> On Tue, Feb 14, 2012 at 20:31, Fabio Estevam <festevam@gmail.com> wrote:
>> On 2/14/12, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>
>>> Ping?
>>>
>>> Build breakage in mainline since at least 3 weeks.
>>
>> From what I recall Randy proposed a patch for fixing this issue:
>> http://patchwork.linuxtv.org/patch/9750/
> 
> Still, someone (preferably the maintainer) should take the appropriate
> action(s) to get the patch in mainline.

I'll be doing it today.

> 
> Thanks!
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

