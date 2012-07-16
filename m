Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab2GPS7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:59:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42211 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2GPS7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <1342464946-30236-1-git-send-email-geert@linux-m68k.org>
References: <1342464946-30236-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 16 Jul 2012 20:59:47 +0200
X-Google-Sender-Auth: hOp76p2nUxhCX8zwvcqUsRSm9cM
Message-ID: <CAMuHMdW39GoFf4or-7PJxW78zUPkZe+pyAqjN59FNTOZYWnQ6g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 8:55 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.5-rc7 to v3.5-rc6[3], the summaries are:
>   - build errors: +5/-24

5 regressions:
  + arch/powerpc/sysdev/mpic.c: error: case label does not reduce to
an integer constant:  => 890:9, 898:9, 886:9, 894:9

powerpc-randconfig

  + drivers/scsi/bnx2i/bnx2i_iscsi.c: error: implicit declaration of
function 'pci_iomap' [-Werror=implicit-function-declaration]:  =>
816:3
  + drivers/scsi/bnx2i/bnx2i_iscsi.c: error: implicit declaration of
function 'pci_iounmap' [-Werror=implicit-function-declaration]:  =>
887:3

xtensa-allmodconfig

  + error: idt77252.c: relocation truncated to fit: R_PPC64_REL24
against symbol `_restgpr0_29' defined in .text section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff83a0)

powerpc-allyesconfig

  + kernel/sys.c: error: 'mmap_min_addr' undeclared (first use in this
function): 1864:34 => 1868:37, 1868:34

sh-randconfig, sh-allyesconfig, sh-allmodconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5243/ (all 116 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
