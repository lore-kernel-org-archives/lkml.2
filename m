Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2FLHYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:24:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64190 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2FLHYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:24:11 -0400
MIME-Version: 1.0
In-Reply-To: <4FD6DC69.2090008@snapgear.com>
References: <1339059427.25798.3.camel@x61.thuisdomein>
	<4FD19B29.4050904@snapgear.com>
	<CAMuHMdXisLvXAPbbkuYsYH2UZ_DJSyEhKZOL6_4qwuwLzFcEoQ@mail.gmail.com>
	<4FD6DC69.2090008@snapgear.com>
Date: Tue, 12 Jun 2012 09:24:10 +0200
X-Google-Sender-Auth: mgTmoe-YYNXQq0Pq6tLcpJbH0gI
Message-ID: <CAMuHMdWn7KsdW1mEcvp8tGrDZeMiD+e6RszB=qH7P3CLZEyftg@mail.gmail.com>
Subject: Re: [PATCH] m68k: remove six unused headers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 8:06 AM, Greg Ungerer <gerg@snapgear.com> wrote:
>>> Although mcfne.h has been unused for a while I am working on some patches
>>> that do use it. No problem for the others.
>>
>> If I'm not mistaken, that should become mcf8390.h, as "NE2000" means
>> "NE2000-compatible 8390-based Ethernet"? Cfr. the mac8390 and zorro8390
>> discussions in the previous millennium.
>
>
> I guess I missed those :-(
> I think I see from the code for those under ~/drivers/net/ethernet/8390/
> what this may have been about though.
>
> Interestingly one of the ColdFire platforms (the Arnewsh 5206 board)
> really did have an ISA NE2000 card fitted to it. Most of the follow
> ons that where similar use a Davicom/9000.

If it's a real ISA NE2000 card, you ISA bus support instead of a special
driver.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
