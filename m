Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2HCOL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:11:26 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60768 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab2HCOLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <1344002771-21072-1-git-send-email-geert@linux-m68k.org>
References: <1344002771-21072-1-git-send-email-geert@linux-m68k.org>
Date: Fri, 3 Aug 2012 16:11:23 +0200
X-Google-Sender-Auth: tv27P-ExaZ6P3CbIhhXS12uf7XQ
Message-ID: <CAMuHMdXsWkXaGPoMDBEkvwWPWvYzPhn8rtbmuQZumWtWe5WGxQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 4:06 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.5 to v3.5-rc7[3], the summaries are:
>   - build errors: +6/-9
>   - build warnings: +105/-5443

  + drivers/staging/ccg/../../usb/gadget/f_mass_storage.c: error:
implicit declaration of function 'get_ds'
[-Werror=implicit-function-declaration]:  => 2624:2
  + drivers/staging/ccg/../../usb/gadget/f_mass_storage.c: error:
implicit declaration of function 'set_fs'
[-Werror=implicit-function-declaration]:  => 2624:2
  + drivers/staging/ccg/../../usb/gadget/storage_common.c: error:
implicit declaration of function 'bdev_logical_block_size'
[-Werror=implicit-function-declaration]:  => 686:3
  + drivers/staging/ccg/../../usb/gadget/storage_common.c: error:
implicit declaration of function 'blksize_bits'
[-Werror=implicit-function-declaration]:  => 687:3

i386-randconfig, staging drivers including USB core sources?

  + error: No rule to make target
/scratch/kisskb/build/linus_sh-randconfig_sh4/usr/include/linux/kvm_para.h:
 => N/A

Known issue with kvm_para.h header export.

  + error: No rule to make target include/config/auto.conf:  => N/A

x86_64-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5266/ (all 116 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
