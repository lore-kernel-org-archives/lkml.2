Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1EFIYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:24:10 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:34532 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab1EFIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:24:08 -0400
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
	<201105052237.11656.arnd@arndb.de>
	<BANLkTinqouGVWH8CmfM038TKFvhpJEczUQ@mail.gmail.com>
X-Yow: I'll clean your ROOM!!  I know some GOOD stories, too!!  All about
 ROAD Island's, HUSH Puppies, and how LUKE finds GOLD on his LAND!!
Date: Fri, 06 May 2011 10:24:04 +0200
In-Reply-To: <BANLkTinqouGVWH8CmfM038TKFvhpJEczUQ@mail.gmail.com> (Geert
	Uytterhoeven's message of "Fri, 6 May 2011 07:11:42 +0200")
Message-ID: <m38vuk9qzf.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> BTW, we have a hole at 218/219. I don't remember why, but it may have been
> a placeholder for pselect6 and ppoll when that implementation was still in flux.
> Couldn't find anything about it in git/cvs archives, so I'll check
> have to check my
> old mailing list archives...

Probably it originated from the time when it was still deemed useful to
keep the numbers in sync with the x86 ones.  The hole is filled with
mincore and madvice there (pselect6 and ppoll came much later).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
