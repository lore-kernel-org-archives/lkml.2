Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1JWJxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:53:34 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48115 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab1JWJxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:53:32 -0400
X-Auth-Info: R8obYwCmvkBQ0rVd01ZgijBudCtud2uDp0PL1+l0zR8=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux/m68k <linux-m68k@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
	<201105050824.34056.arnd@arndb.de>
	<alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
X-Yow: On the other hand, life can be an endless parade of TRANSSEXUAL
 QUILTING BEES aboard a cruise ship to DISNEYWORLD
 if only we let it!!
Date: Sun, 23 Oct 2011 11:53:26 +0200
In-Reply-To: <alpine.DEB.2.00.1105052042590.17077@ayla.of.borg> (Geert
	Uytterhoeven's message of "Thu, 5 May 2011 20:44:20 +0200 (CEST)")
Message-ID: <m2ty70ghk9.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> From 5739b340b334de21c6da4f65d5194957662a6dd0 Mon Sep 17 00:00:00 2001
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Thu, 5 May 2011 20:33:02 +0200
> Subject: [PATCH] m68k: unistd - Comment out definitions for unimplemented syscalls

This is not a good idea at least for the syscalls referenced by glibc.
It means that a glibc compiled against this <asm/unistd.h> will lose the
ability to call those syscalls even if the running kernel happens to
implement them.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
