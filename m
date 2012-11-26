Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2KZU4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:56:11 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44598 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2KZU4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:56:09 -0500
MIME-Version: 1.0
In-Reply-To: <1353963243-21887-1-git-send-email-geert@linux-m68k.org>
References: <1353963243-21887-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 26 Nov 2012 21:56:06 +0100
X-Google-Sender-Auth: zk9vK2nYoeHU64yCr2U5v6mnHPI
Message-ID: <CAMuHMdWjpQ1+=MoxUCLvv4dMkjVV3Y2XoiwFWbHMTkZeeOQheQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.7-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Linux-sh list <linux-sh@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 9:54 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.7-rc7 to v3.7-rc6[3], the summaries are:
>   - build errors: +4/-8

  + error: "__sync_fetch_and_and_4"
[drivers/staging/line6/line6usb.ko] undefined!:  => N/A
  + error: "__sync_fetch_and_or_4" [drivers/staging/line6/line6usb.ko]
undefined!:  => N/A

sh4/sh-randconfig

  + error: "smp_send_reschedule" [arch/powerpc/kvm/kvm.ko] undefined!:  => N/A

powerpc/powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5646/ (all 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5628/ (all 117 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
