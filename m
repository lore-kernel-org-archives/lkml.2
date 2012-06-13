Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2FMMrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:47:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54126 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2FMMrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120613075737.GA27673@linux-sh.org>
References: <20120613075737.GA27673@linux-sh.org>
Date: Wed, 13 Jun 2012 14:47:34 +0200
X-Google-Sender-Auth: DrWwzbYnUoEaY0lhhumm2qt-5xg
Message-ID: <CAMuHMdVLEUBz8=L_=3MdzvAzr8jtyu_o2f3AaAiSNHS0KX11Cg@mail.gmail.com>
Subject: Re: [GIT PULL] sh fixes for 3.5-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Jun 13, 2012 at 9:57 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> Paul Mundt (13):
>      sh: convert to kbuild asm-generic support.

>  arch/sh/include/asm/kvm_para.h          |    1 -

I guess this breaks "make ARCH=sh headers_check"?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
