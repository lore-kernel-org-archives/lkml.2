Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab1IJJTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 05:19:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56422 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621Ab1IJJS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 05:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110910085546.GV23283@sweaglesw.org>
References: <20110910085546.GV23283@sweaglesw.org>
Date: Sat, 10 Sep 2011 11:18:57 +0200
X-Google-Sender-Auth: KNJpV-qjVdL54jbh514rJ6liy7Q
Message-ID: <CAMuHMdXv3Rfn-T6=14tya82a_W4WLReSkNW8Y7ChevwvcdcSvA@mail.gmail.com>
Subject: Re: [PATCH] logo: Change regular 224-color tux logo to something more
 appropriate for Linux 3.1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: djwong@djwong.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 10:55,  <djwong@djwong.org> wrote:
> For Linux 3.1, I thought we could change the 224-color framebuffer logo to
> something more apropos given the version number.  As the patch is quite large,
> I'm only inlining the changelog. 8)
>
> See http://djwong.org/docs/31-tuxlogo.patch for too-large-for-lkml patch,
> http://djwong.org/docs/31-tuxlogo.png  for a PNG logo, or

Nice try!

> http://djwong.org/docs/31-tuxlogo-screen.png for a screenshot.

How come the text is corrupting the logo during scrolling?

> Singed-off-by: Darrick J. Wong <djwong@djwong.org>
> ---
>
>  drivers/video/logo/logo_linux_clut224.ppm |39322 ++++++++++++++++++++++++++++-
>  1 files changed, 37720 insertions(+), 1602 deletions(-)

This really needs to go through linux-fbdev (CCed).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
