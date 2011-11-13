Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1KMKpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 05:45:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36942 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1KMKo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 05:44:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdV4BEVPKBG7=-vvZ9fjEsaFjq+8Aw11XstqxpSfR8_1NA@mail.gmail.com>
References: <CAMuHMdV4BEVPKBG7=-vvZ9fjEsaFjq+8Aw11XstqxpSfR8_1NA@mail.gmail.com>
Date: Sun, 13 Nov 2011 11:44:56 +0100
X-Google-Sender-Auth: AgR7zty_qci70yfVWTfZpHY0Hqg
Message-ID: <CAMuHMdWJPOvrU62GuN4-3+61V5kvaPZ40g5LkqzMp5dGnK+_+w@mail.gmail.com>
Subject: Re: linux-m68k.git is back
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Linux/m68k" <linux-m68k@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 09:22, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> linux-m68k.git is back, in the usual place:
>
> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git
>
> Interesting branches:
>  - master: main development, containing accepted changesets,
>  - m68k-queue: (almost) identical to master, but nice changesets rebased on top of
>    the latest v* tag (incl. release candidates) from Linus (I don't follow stable),

I added the following cleanups to master:

      m68k: Remove unused platform.c skeleton files
      m68k: Remove unused GVP IO-Extender files and config symbols
      m68k: Remove unused mc68681.h header file for MultiFace III serial
      fs/fat: Reorder options to match the m68k-queue branch
      m68k/atari: Remove Atari SCC serial driver
      Revert "CONFIG_SWAP=n: include/linux/swap.h needs <linux/pagemap.h>"
      m68k/atari: Remove superfluous comment in debug code

and now it's identical to m68k-queue. I'll keep it that way.

>  - for-*: What's destined for a specific merge window. The latest overlap with
>    for-linus/for-next,

Sometimes they may be a few commits ahead of for-linus/for-next, e.g. if
those commits have to go in through another maintainer's tree.

> master and m68k-v* are never rebased. m68k-queue and for-* are rebased when a
> new v* comes out.

and they may be reshuffled when commits are added.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
