Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2JVTua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:50:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61988 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2JVTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:50:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210222146440.12209@ayla.of.borg>
References: <alpine.DEB.2.00.1210222146440.12209@ayla.of.borg>
Date: Mon, 22 Oct 2012 21:50:26 +0200
X-Google-Sender-Auth: ej-ttoVPSUqJJxcDebLnL4XJOdg
Message-ID: <CAMuHMdVS-qz0BAHXFGD01+w1GxyQ2M7DpLnLRQKtdZSiDfYgHw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.7-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 9:47 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.7-rc2 to v3.7-rc1[3], the summaries are:
>   - build errors: +4/-44

  + arch/s390/include/asm/kvm_para.h: error: redefinition of
'kvm_arch_para_features':  => 147:28, 147:99
  + arch/s390/include/asm/kvm_para.h: error: redefinition of
'kvm_check_and_clear_guest_paused':  => 152:91, 152:20

s390-allmodconfig/s390-allyesconfig/s390-defconfig

  + error: phy_n.c: relocation truncated to fit: R_PPC64_REL24 against
symbol `._mcount' defined in .text section in
arch/powerpc/kernel/entry_64.o:  => (.text+0x1ff9500)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol
`_savegpr0_24' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ffac7c)

powerpc-allyesconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5550/ (all 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5526/ (all 117 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
