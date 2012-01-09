Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab2AIUQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:16:00 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51883 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369Ab2AIUP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:15:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvwJWrSRSNxHE620XZkc4w0ayzeqqxZOR1efkh1V+VBO1w@mail.gmail.com>
References: <1326055714.13595.309.camel@deadeye>
	<CA+55aFwwnJPpVY++Vgr6p3s47YjdYWV3sgLZzvCtiJp6DEu78Q@mail.gmail.com>
	<CAFLxGvwJWrSRSNxHE620XZkc4w0ayzeqqxZOR1efkh1V+VBO1w@mail.gmail.com>
Date: Mon, 9 Jan 2012 21:15:55 +0100
X-Google-Sender-Auth: zyCgcEQ1GQOwrU2wAKRp6_QJLE4
Message-ID: <CAMuHMdWrj5qGvnwaXL62btSuSJF1OD3gjiyRD1KVc2bWWgD4uw@mail.gmail.com>
Subject: Re: [PATCH 1/2] topology: Check for missing CPU devices
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 02:06, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> Instead of testing kernels I really should read more LKML. ;-)

As an architecture maintainer, you want to read at least linux-arch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
