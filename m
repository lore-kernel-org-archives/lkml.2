Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab2LMT1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:27:37 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54280 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab2LMT1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:27:36 -0500
MIME-Version: 1.0
In-Reply-To: <1355426667-3060-1-git-send-email-geert@linux-m68k.org>
References: <1355426667-3060-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 13 Dec 2012 20:27:34 +0100
X-Google-Sender-Auth: Clj35ccgoJdNYmJwprE3Ze2APgc
Message-ID: <CAMuHMdVaTp2MRYBcuMO1fEx_9GKVFHQbT4kmQqzWKe=WVzbi_A@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: "the arch/x86 maintainers" <x86@kernel.org>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 8:24 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.7 to v3.7-rc8[3], the summaries are:
>   - build errors: +2/-0

  + error: No rule to make target include/config/auto.conf:  => N/A

x86_64-randconfig

  + error: vga16fb.c: undefined reference to `vgacon_remap_base':  =>
.devinit.text+0x16b52), .devinit.text+0x16b5a)

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5700/ (all 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5670/ (all 117 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
