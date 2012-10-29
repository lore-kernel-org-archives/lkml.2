Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab2J2UwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:52:23 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34168 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab2J2UwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:52:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210292149270.23875@ayla.of.borg>
References: <alpine.DEB.2.00.1210292149270.23875@ayla.of.borg>
Date: Mon, 29 Oct 2012 21:52:18 +0100
X-Google-Sender-Auth: vRReVrvXE2GfH1Qx6DIdidcxNjU
Message-ID: <CAMuHMdXwn0iLd=Phgpn4pAHwVkRebHNt=RhcnEYWe40gUckZ4w@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.7-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 9:50 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.7-rc3 to v3.7-rc2[3], the summaries are:
>   - build errors: +5/-6
>   - build warnings: +149/-2090

  + error: file_storage.c: undefined reference to `usb_ep_autoconfig':
 => .init.text+0x10bc5), .init.text+0x10be7), .init.text+0x10bac)
  + error: file_storage.c: undefined reference to
`usb_ep_autoconfig_reset':  => .init.text+0x10ba0)
  + error: file_storage.c: undefined reference to
`usb_gadget_config_buf':  => .text+0x34726a)
  + error: file_storage.c: undefined reference to
`usb_gadget_get_string':  => .text+0x347289)

i386-randconfig

  + error: phy_n.c: relocation truncated to fit: R_PPC64_REL24 against
symbol `_restgpr0_14' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o: (.text+0x1ff7df4), (.text+0x1ff9f70) =>
(.text+0x1ff79ac), (.text+0x1ff7fdc), (.text+0x1ffa158)

powerpc-allyesconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5580/ (all 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5550/ (all 117 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
