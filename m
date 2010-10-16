Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0JPIuu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:50:50 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54867 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0JPIus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:50:48 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Akinobu Mita <akinobu.mita@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux\/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-23-git-send-email-akinobu.mita@gmail.com>
	<201010151253.15653.arnd@arndb.de>
	<AANLkTi=cA=yf7NmPVKXaZdoTBYmwdmy_frk7b_feG-WG@mail.gmail.com>
X-Yow: I'm into SOFTWARE!
Date: Sat, 16 Oct 2010 10:50:45 +0200
In-Reply-To: <AANLkTi=cA=yf7NmPVKXaZdoTBYmwdmy_frk7b_feG-WG@mail.gmail.com>
	(Geert Uytterhoeven's message of "Sat, 16 Oct 2010 09:59:24 +0200")
Message-ID: <m262x24j2y.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Funny, m68k uses the little endian minix file system?
>
> Perhaps this was due to minix using the ext2 accessors? And ext2 being
> switched from big to little endian ext2 on m68k, without anyone
> noticing the impact
> on minix?

m68k has always used big-endian minixfs and the minix bitops were always
independent of the ext2 ones.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
