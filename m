Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1GAIe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:34:29 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54791 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab1GAIe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:34:27 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Mikael Starvik <mikael.starvik@axis.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
	<20110629140630.5aefdda8.rdunlap@xenotime.net>
	<BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
	<20110630080119.GA20802@infradead.org>
	<BANLkTik81kgf=g+QngnaB7gNUF+xCQdSvw@mail.gmail.com>
	<m2y60jmeo3.fsf@igel.home>
	<4BEA3FF3CAA35E408EA55C7BE2E61D055C63F4D814@xmail3.se.axis.com>
X-Yow: Two with FLUFFO, hold th' BEETS..side of SOYETTES!
Date: Fri, 01 Jul 2011 10:34:16 +0200
In-Reply-To: <4BEA3FF3CAA35E408EA55C7BE2E61D055C63F4D814@xmail3.se.axis.com>
	(Mikael Starvik's message of "Fri, 1 Jul 2011 07:25:27 +0200")
Message-ID: <m38vsiflh3.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Starvik <mikael.starvik@axis.com> writes:

> Also note that sizeof(long) == sizeof(int) for cris.

That is irrelevant for C++ name mangling.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
