Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2GPHCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:02:53 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58438 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2GPHCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:02:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAA_GA1fsRiUD_XpHXJXV+R3zVuz-fvRGiD3ttQU4md0sL9t_vg@mail.gmail.com>
References: <1340740795-19603-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdXgCR1HUwmwT21p=O2p+LuAqLfeM=Tn=ghvKQ+qgsNTTQ@mail.gmail.com>
	<CAA_GA1fsRiUD_XpHXJXV+R3zVuz-fvRGiD3ttQU4md0sL9t_vg@mail.gmail.com>
Date: Mon, 16 Jul 2012 09:02:40 +0200
X-Google-Sender-Auth: EegoOEbHr036f8mNxG5gyR7C1Lc
Message-ID: <CAMuHMdUChVosb4p5wEzjduFVcTbNqRWVo1NkmmP+1CgB2v1jFg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bob Liu <lliubbo@gmail.com>
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bob,

On Mon, Jul 16, 2012 at 4:44 AM, Bob Liu <lliubbo@gmail.com> wrote:
> On Sat, Jul 14, 2012 at 4:02 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Tue, Jun 26, 2012 at 9:59 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> + drivers/i2c/busses/i2c-bfin-twi.c: error: 'ANAK' undeclared (first use in this function):  => 154:19
>>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'XMTSERV' undeclared (first use in this function):  => 344:39, 489:39, 90:23
>
> The fix patches have already in Wolfram Sang's i2c tree, i think it'll
> be merged soon.

Thanks, good to hear that!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
