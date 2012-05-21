Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab2EUU4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:56:49 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38476 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758513Ab2EUU4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:56:48 -0400
MIME-Version: 1.0
In-Reply-To: <1337629862-23393-1-git-send-email-geert@linux-m68k.org>
References: <1337629862-23393-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 21 May 2012 22:56:47 +0200
X-Google-Sender-Auth: K8pcZg5JhTfprU3mqz0_muHnReQ
Message-ID: <CAMuHMdV8PFRT+APVkSPkgCHxSx806h4rpCJBCHb9NQw=JQLuEg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 9:51 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.4 to v3.4-rc7[3], the summaries are:
>  - build errors: +5/-14

  + error: via-pmu-event.c: undefined reference to
`.input_allocate_device':  => .init.text+0x8aa4)
  + error: via-pmu-event.c: undefined reference to
`.input_free_device':  => .init.text+0x8b68)
  + error: via-pmu-event.c: undefined reference to
`.input_register_device':  => .init.text+0x8b54)

powerpc-randconfig

  + kernel/fork.c: error: implicit declaration of function
'alloc_task_struct_node' [-Werror=implicit-function-declaration]:  =>
266:2
  + kernel/fork.c: error: implicit declaration of function
'free_task_struct' [-Werror=implicit-function-declaration]:  => 174:2

frv-defconfig (ouch)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
