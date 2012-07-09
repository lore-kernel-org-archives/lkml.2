Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2GIVbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:31:08 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51267 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2GIVbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:31:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo47VO7F=fY1CRS-uwvp4CsTNttk2tasszs5Fdo7j7RqMA@mail.gmail.com>
References: <1341861422-25861-1-git-send-email-geert@linux-m68k.org>
	<CAErSpo47VO7F=fY1CRS-uwvp4CsTNttk2tasszs5Fdo7j7RqMA@mail.gmail.com>
Date: Mon, 9 Jul 2012 23:31:04 +0200
X-Google-Sender-Auth: Wld1YGRlBAr1ALqZNgpgXFAXT4w
Message-ID: <CAMuHMdXXXg=ChD8h2+ot2igtYR7N_C5FHO5ziHZwwL_7BVPBmQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn (or Björn?),

On Mon, Jul 9, 2012 at 11:20 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> There are some PCI-related regressions here that I'd like to fix, but
> I don't know where to start.  For example, these:
>
>>   + drivers/pci/quirks.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 3154:2
>>   + drivers/pci/quirks.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 3144:2
>
> I don't see these in an x86 build, so I assume these are from some
> other arch or other config.  Can I tell which one?

xtensa-allmodconfig

http://kisskb.ellerman.id.au/kisskb/buildresult/6668885/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
