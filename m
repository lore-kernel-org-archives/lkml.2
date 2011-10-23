Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1JWO7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:59:14 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48407 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1JWO7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:59:12 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Linux\/m68k" <linux-m68k@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
	<201105050824.34056.arnd@arndb.de>
	<alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
	<m2ty70ghk9.fsf@linux-m68k.org>
	<CAMuHMdVWAcNFeWauj-DoB3btWY9UTOBDNMzRyTvYmYaYb15N4A@mail.gmail.com>
X-Yow: I LOVE juxtaposing th' splendor of an unpopulated ARROYO with
 th' SLEEK lines of ``NARCISSUS-X'', my new SPORTS UTILITY VEHICLE!
Date: Sun, 23 Oct 2011 16:59:07 +0200
In-Reply-To: <CAMuHMdVWAcNFeWauj-DoB3btWY9UTOBDNMzRyTvYmYaYb15N4A@mail.gmail.com>
	(Geert Uytterhoeven's message of "Sun, 23 Oct 2011 14:20:27 +0200")
Message-ID: <m2y5wb7o04.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> All others seem to be old, obsolete, or i386-only.

Those are not referenced by glibc anyway.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
