Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1JMHWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:22:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1JMHWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:22:14 -0400
MIME-Version: 1.0
Date: Thu, 13 Oct 2011 09:22:13 +0200
X-Google-Sender-Auth: gL-hlyIU_zgyQ8g7jyJ0EVZkcvM
Message-ID: <CAMuHMdV4BEVPKBG7=-vvZ9fjEsaFjq+8Aw11XstqxpSfR8_1NA@mail.gmail.com>
Subject: linux-m68k.git is back
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Linux/m68k" <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

linux-m68k.git is back, in the usual place:

http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git

Interesting branches:
  - master: main development, containing accepted changesets,
  - m68k-queue: (almost) identical to master, but nice changesets
rebased on top of
    the latest v* tag (incl. release candidates) from Linus (I don't
follow stable),
  - for-linus: What I will ask Linus to pull in this merge window,
  - for-next: What's destined for the next merge window,
  - for-*: What's destined for a specific merge window. The latest overlap with
    for-linus/for-next,
  - m68k-v*: State of m68k-queue when v* was current.

master and m68k-v* are never rebased. m68k-queue and for-* are rebased when a
new v* comes out.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
