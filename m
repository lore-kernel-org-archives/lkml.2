Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2BFKly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:41:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44768 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2BFKlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:41:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVim5VjEYCABXmaw8JQQQtAJk_hLGs+vys2Vr49AFOxCw@mail.gmail.com>
References: <1326622076-957-1-git-send-email-geert@linux-m68k.org>
	<20120115105203.GA12584@x220.P-661HNU-F1>
	<CAMuHMdVim5VjEYCABXmaw8JQQQtAJk_hLGs+vys2Vr49AFOxCw@mail.gmail.com>
Date: Mon, 6 Feb 2012 11:41:51 +0100
X-Google-Sender-Auth: 68kl7CHF7vfR6tc9ZITho8W3Q4M
Message-ID: <CAMuHMdUgyDgOttd+VFJviKw=WCNpt7rjEHC_FCNLfujcr-4m4A@mail.gmail.com>
Subject: Re: [PATCH] blutetooth: Remove bogus inline for l2cap_chan_connect()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Sun, Jan 15, 2012 at 12:25, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sun, Jan 15, 2012 at 11:52, Johan Hedberg <johan.hedberg@gmail.com> wrote:
>>>     net/bluetooth/l2cap_sock.c: In function ‘l2cap_sock_connect’:
>>>     include/net/bluetooth/l2cap.h:838: sorry, unimplemented: inlining failed in call to ‘l2cap_chan_connect’: function body not available
>>>     net/bluetooth/l2cap_sock.c:126: sorry, unimplemented: called from here
>>>     make[1]: *** [net/bluetooth/l2cap_sock.o] Error 1
>
>> This was already reported[1] earlier this month and a patch[2] was also
>
> Ah, it was reported as a sparse warning. I guess that's why I didn't find it.
> But a build error is worse.
>
>> created for it which right now resides in my bluetooth-next tree[3].
>> [3] http://git.kernel.org/?p=linux/kernel/git/jh/bluetooth-next.git;a=commitdiff;h=cd555072d0b0738c8a107776fe91902da686f94d

This doesn't seem to be in linux-next, as -next pulls
git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next.git
instead?

Can we please get the fix in mainline ASAP, as it breaks the build with some
versions of gcc?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
