Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0JPM54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 08:57:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45985 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab0JPM5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 08:57:54 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux\/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-23-git-send-email-akinobu.mita@gmail.com>
	<201010151253.15653.arnd@arndb.de>
	<AANLkTi=cA=yf7NmPVKXaZdoTBYmwdmy_frk7b_feG-WG@mail.gmail.com>
	<m262x24j2y.fsf@igel.home>
	<AANLkTimHYYLZHOxgco3jotD7ikVhaPh8FVcSqeZwtrVc@mail.gmail.com>
	<AANLkTimtyW8AbOj+w=mjPbpP1j0LB9JXdo7cb=nQAXQ8@mail.gmail.com>
X-Yow: ..  Do you like ``TENDER VITTLES?''?
Date: Sat, 16 Oct 2010 14:57:51 +0200
In-Reply-To: <AANLkTimtyW8AbOj+w=mjPbpP1j0LB9JXdo7cb=nQAXQ8@mail.gmail.com>
	(Akinobu Mita's message of "Sat, 16 Oct 2010 21:40:03 +0900")
Message-ID: <m2aamepa5s.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu Mita <akinobu.mita@gmail.com> writes:

> m68knommu is big-endian minixfs but m68k (mmu) is little-endian minixfs
> if I read arch/m68k/include/asm/bitops_{mm,no}.h correctly.

Don't be confused by ^16, this is for the 16bit/32bit indexing
correction.  The nommu version uses big-endian 32bit indexing which yet
another format.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
