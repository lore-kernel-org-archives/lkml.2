Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2KRJUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 04:20:45 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37102 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2KRJUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 04:20:43 -0500
MIME-Version: 1.0
In-Reply-To: <1353230222-3464-1-git-send-email-geert@linux-m68k.org>
References: <1353230222-3464-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 18 Nov 2012 10:20:42 +0100
X-Google-Sender-Auth: kj_kCRiKLSvPRkfSPt4ZfBpVXEg
Message-ID: <CAMuHMdXuoAhW=CLogzprPe+6=8Oe5y0J6SuZnYKQzhMv=dpuTg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.7-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 10:17 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.7-rc6 to v3.7-rc5[3], the summaries are:
>   - build errors: +2/-12

Just some broken dependencies, I guess:

2 regressions:
  + arch/powerpc/sysdev/mpic.c: error: case label does not reduce to
an integer constant:  => 890:9, 898:9, 886:9, 894:9

powerpc/powerpc-randconfig

  + error: "__ashrdi3" [fs/ext4/ext4.ko] undefined!:  => N/A

sh4/sh-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5628/ (all 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5614/ (all 117 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
