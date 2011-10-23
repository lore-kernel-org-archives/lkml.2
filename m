Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab1JWMU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 08:20:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44746 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab1JWMU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 08:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <m2ty70ghk9.fsf@linux-m68k.org>
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
	<201105050824.34056.arnd@arndb.de>
	<alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
	<m2ty70ghk9.fsf@linux-m68k.org>
Date: Sun, 23 Oct 2011 14:20:27 +0200
X-Google-Sender-Auth: idNSsVp9kokufs5YrAyM57238KY
Message-ID: <CAMuHMdVWAcNFeWauj-DoB3btWY9UTOBDNMzRyTvYmYaYb15N4A@mail.gmail.com>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 11:53, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> From 5739b340b334de21c6da4f65d5194957662a6dd0 Mon Sep 17 00:00:00 2001
>> From: Geert Uytterhoeven <geert@linux-m68k.org>
>> Date: Thu, 5 May 2011 20:33:02 +0200
>> Subject: [PATCH] m68k: unistd - Comment out definitions for unimplemented syscalls
>
> This is not a good idea at least for the syscalls referenced by glibc.
> It means that a glibc compiled against this <asm/unistd.h> will lose the
> ability to call those syscalls even if the running kernel happens to
> implement them.

But is any of them likely to be ever implemented on m68k?
Perhaps AFS, vserver and {get,put}pmsg()?
All others seem to be old, obsolete, or i386-only.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
