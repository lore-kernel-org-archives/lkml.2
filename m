Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2BZTvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 14:51:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39086 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2BZTvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 14:51:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120226.144019.2044348944862329030.davem@davemloft.net>
References: <1330284719-22348-1-git-send-email-geert@linux-m68k.org>
	<20120226.144019.2044348944862329030.davem@davemloft.net>
Date: Sun, 26 Feb 2012 20:51:17 +0100
X-Google-Sender-Auth: 0rA-csxfQFcRv-AkIinPnxZHitg
Message-ID: <CAMuHMdV4q9JY-pa=yw9uUZQWywjW0j0K36MQXYf+OsJt6ZeTqA@mail.gmail.com>
Subject: Re: [PATCH RESEND] bluetooth: Remove bogus inline for l2cap_chan_connect()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, Feb 26, 2012 at 20:40, David Miller <davem@davemloft.net> wrote:
> This fix is already in the 'net' GIT tree and will be on it's
> way to Linus soon.

Thanks, good to hear that!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
