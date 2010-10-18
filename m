Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0JRI61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:58:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45881 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab0JRI6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:58:25 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 21/22] m68k: convert minix bitops to use little endian bitops
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-22-git-send-email-akinobu.mita@gmail.com>
X-Yow: If elected, Zippy pledges to each and every American
 a 55-year-old houseboy...
Date: Mon, 18 Oct 2010 10:58:24 +0200
In-Reply-To: <1287135981-17604-22-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Fri, 15 Oct 2010 18:46:20 +0900")
Message-ID: <m3r5fnyj0v.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu Mita <akinobu.mita@gmail.com> writes:

> The inode and block bitmap for minix filesystem is little endian
> byte order on m68k.

No, it isn't.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
