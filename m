Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1HHMBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:01:06 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:54975 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1HHMBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:01:04 -0400
MIME-Version: 1.0
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F23AFDDA6@SC1EXMB-MBCL.global.atheros.com>
References: <20100927162143.3a9c1efe.sfr@canb.auug.org.au>
	<20100927113829.2928636a.rdunlap@xenotime.net>
	<35B17FE5076C7040809188FBE7913F983F23AFDDA6@SC1EXMB-MBCL.global.atheros.com>
Date: Mon, 8 Aug 2011 14:01:03 +0200
X-Google-Sender-Auth: 1gGO5Fe8JWbbwecYph9HPdbTxvc
Message-ID: <CAMuHMdUMhwiXwc4X9umrEwtFsKacmPPvzxZ3UoOY8_iLQ57hqQ@mail.gmail.com>
Subject: Re: linux-next: Tree for September 27 (staging: ath6kl, spectra, & vt6655)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vipin Mehta <Vipin.Mehta@atheros.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "forest@alittletooquiet.net" <forest@alittletooquiet.net>,
        "yunpeng.gao@intel.com" <yunpeng.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 21:28, Vipin Mehta <Vipin.Mehta@atheros.com> wrote:
>> Changes since 20100924:
>
> drivers/staging/ath6kl/os/linux/ar6000_drv.c:1370:1: warning: "CONFIG_AR600x_BT_RESET_PIN" redefined
> ./include/generated/autoconf.h:419:1: warning: this is the location of the previous definition
> drivers/staging/ath6kl/os/linux/ioctl.c:4673: warning: the frame size of 2052 bytes is larger than 1024 bytes
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:288: error: 'struct mmc_host' has no member named 'max_hw_segs'
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:289: error: 'struct mmc_host' has no member named 'max_hw_segs'
>
> The problem is because the mmc stack is out of sync in Greg's staging tree and Stephen's linux-next tree. Greg asked me to generate a patch which I did and emailed to Greg.

And the 'warning: "CONFIG_AR600x_BT_RESET_PIN" redefined' is still there...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
