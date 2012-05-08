Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2EHTWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:22:43 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39225 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab2EHTWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <1336504803-1951-1-git-send-email-geert@linux-m68k.org>
References: <1336504803-1951-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 8 May 2012 21:22:41 +0200
X-Google-Sender-Auth: Nn-o1lLfyADT2RMgW3-aQL-lS7Y
Message-ID: <CAMuHMdWQFc-5bqnU97+ej81TzUieZ8bt3y6ueXOiX7QX2J_GNw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.4-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 9:20 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.4-rc6 to v3.4-rc5[3], the summaries are:
>  - build errors: +2/-1

2 regressions:
  + arch/powerpc/sysdev/mpic.c: error: case label does not reduce to
an integer constant:  => 890:9, 898:9, 886:9, 894:9
  + error: "set_personality_ia32" [arch/x86/ia32/ia32_aout.ko]
undefined!:  => N/A

The former is from powerpc-randconfig, the latter has been fixed in
the mean time.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
