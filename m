Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2AOLZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 06:25:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54377 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab2AOLZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 06:25:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120115105203.GA12584@x220.P-661HNU-F1>
References: <1326622076-957-1-git-send-email-geert@linux-m68k.org>
	<20120115105203.GA12584@x220.P-661HNU-F1>
Date: Sun, 15 Jan 2012 12:25:04 +0100
X-Google-Sender-Auth: E1D4mOyYcPcsx6XF53FQPCiY_Q4
Message-ID: <CAMuHMdVim5VjEYCABXmaw8JQQQtAJk_hLGs+vys2Vr49AFOxCw@mail.gmail.com>
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

On Sun, Jan 15, 2012 at 11:52, Johan Hedberg <johan.hedberg@gmail.com> wrote:
>>     net/bluetooth/l2cap_sock.c: In function ‘l2cap_sock_connect’:
>>     include/net/bluetooth/l2cap.h:838: sorry, unimplemented: inlining failed in call to ‘l2cap_chan_connect’: function body not available
>>     net/bluetooth/l2cap_sock.c:126: sorry, unimplemented: called from here
>>     make[1]: *** [net/bluetooth/l2cap_sock.o] Error 1

> This was already reported[1] earlier this month and a patch[2] was also

Ah, it was reported as a sparse warning. I guess that's why I didn't find it.
But a build error is worse.

> created for it which right now resides in my bluetooth-next tree[3].

OK, thanks a lot!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
