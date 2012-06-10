Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2FJIkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 04:40:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62068 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2FJIkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 04:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <4FD19B29.4050904@snapgear.com>
References: <1339059427.25798.3.camel@x61.thuisdomein>
	<4FD19B29.4050904@snapgear.com>
Date: Sun, 10 Jun 2012 10:40:17 +0200
X-Google-Sender-Auth: 0R7fW0nIhwpWVhCI9vTcSFHPw-M
Message-ID: <CAMuHMdXisLvXAPbbkuYsYH2UZ_DJSyEhKZOL6_4qwuwLzFcEoQ@mail.gmail.com>
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

On Fri, Jun 8, 2012 at 8:26 AM, Greg Ungerer <gerg@snapgear.com> wrote:
> On 07/06/12 18:57, Paul Bolle wrote:
>> There are six entirely unused headers in arch/m68k/include/asm. Nothing
>> includes these headers. And a few tests found no hits for the things
>> they provide (which makes sense).
>>
>> MC68332.h, mac_mouse.h, mcfmbus.h, and mcfne.h are all unused since at
>> least v2.6.12-rc2 (I didn't bother looking further back than that).
>
>
> Although mcfne.h has been unused for a while I am working on some patches
> that do use it. No problem for the others.

If I'm not mistaken, that should become mcf8390.h, as "NE2000" means
"NE2000-compatible 8390-based Ethernet"? Cfr. the mac8390 and zorro8390
discussions in the previous millennium.

>> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>
>
>
> Acked-by: Greg Ungerer<gerg@uclinux.org>

Thanks, queued for 3.6.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
