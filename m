Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2GITXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:23:03 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50261 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2GITXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <1341861422-25861-1-git-send-email-geert@linux-m68k.org>
References: <1341861422-25861-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 9 Jul 2012 21:23:00 +0200
X-Google-Sender-Auth: sl2Zhegb3yT5PSjk1q6DTiYl5_k
Message-ID: <CAMuHMdWUCL4HPo4KG-7EeP4rz5bRaY8uR7pUofDybM6Ovi06ug@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 9:17 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.5-rc6 to v3.5-rc5[3], the summaries are:
>   - build errors: +5/-19

5 regressions:
  + error: "usb_speed_string" [drivers/usb/core/usbcore.ko] undefined!:  => N/A
  + error: "utf16s_to_utf8s" [drivers/usb/core/usbcore.ko] undefined!:  => N/A

i386-randconfig

  + error: No rule to make target
/scratch/kisskb/build/linus_sh-randconfig_sh4/usr/include/linux/kvm_para.h:
 => N/A

sh-randconfig (known issue, the conditional kvm_para.h export that breaks all
"generic-y += kvm_para.h" platforms)

  + error: idt77252.c: relocation truncated to fit: R_PPC64_REL24
against symbol `.__raw_spin_lock_init' defined in .text section in
lib/built-in.o: (.text+0x1ff8c5c) => (.text+0x1ff8518),
(.text+0x1ff84f4), (.text+0x1ff84d4), (.text+0x1ff8548)
  + error: idt77252.c: relocation truncated to fit: R_PPC64_REL24
against symbol `.printk' defined in .text.unlikely section in
kernel/built-in.o:  => (.text+0x1ff94f4), (.text+0x1ff93d8),
(.text+0x1ff9418), (.text+0x1ff94b0), (.text+0x1ff8e18),
(.text+0x1ff8d98)

powerpc-allyesconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5220/ (all 116 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
