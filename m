Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab1HMR60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 13:58:26 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:44544 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1HMR6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 13:58:24 -0400
MIME-Version: 1.0
In-Reply-To: <1310937150-27890-1-git-send-email-jim.rotmalm@gmail.com>
References: <1310937150-27890-1-git-send-email-jim.rotmalm@gmail.com>
Date: Sat, 13 Aug 2011 19:58:24 +0200
X-Google-Sender-Auth: bUFHW7raV-B11YkQB26kTwFUBfM
Message-ID: <CAMuHMdUT51N_6kw7JMitTF06nqRMYKMS9HuudjEYK7MHw_6byQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: zorro: fix four checkpatch warnings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jim Rotmalm <jim.rotmalm@gmail.com>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 23:12, Jim Rotmalm <jim.rotmalm@gmail.com> wrote:
> zorro-driver.c: fix four checkpatch warnings of:
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>
> I had a cat. The cat was mine.
> His name was Zorro. Amiga is fine.

Thanks, applied. Will queue for 3.2.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
