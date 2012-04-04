Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab2DDRoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:44:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61959 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab2DDRoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:44:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120404074553.GA14959@merkur.ravnborg.org>
References: <20120404074553.GA14959@merkur.ravnborg.org>
Date: Wed, 4 Apr 2012 19:44:00 +0200
X-Google-Sender-Auth: eiQ0KUAf_PEikjRIWYzWDKCT-DQ
Message-ID: <CAMuHMdXuODijkJrPOwppaU9z07ziBFFoag6AQT7vqr0yXva3Aw@mail.gmail.com>
Subject: Re: [PATCH] irq: remove obsolete definitions in interrupt.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-m68k@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>,
        sparclinux <sparclinux@vger.kernel.org>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 09:45, Sam Ravnborg <sam@ravnborg.org> wrote:
> interrupt.h contained a small fixlet for the days when
> m68k and sparc32 did not use genirq.
> As they have both entered the modern world this
> fixlet can be dropped.
>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: "David S. Miller" <davem@davemloft.net>

Does this affect s390 (the sole !genirq arch) negatively?

If not:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
