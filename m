Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2GQGxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:53:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49599
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393Ab2GQGxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:53:51 -0400
Date: Tue, 17 Jul 2012 02:53:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
        Ingo Molnar <mingo@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120717065338.GA24699@infradead.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120714093032.GA23316@elf.ucw.cz>
 <20120715121644.GB10597@arm.com>
 <201207151943.08183.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207151943.08183.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 07:43:07PM +0000, Arnd Bergmann wrote:
> Yes, I agree that's the best way to handle this. Compared to other
> architectures, I think x86 is the only that allows booting either a
> 32 or 64 bit kernel on the same system. We used to support 32 bit
> kernels on 64 bit PowerMac, but nobody used it and we discontinued
> it long ago. Tile 64 bit is actually incompatible with 32 bit kernels
> at the architecture level and would require a third mode. On sparc,
> parisc and mips, AFAIK we could support 32 bit kernels on 64 bit
> machines, but never did.

On mips it works just fine.  On Sparc I don't think Linux ever did it,
but Solaris did for a long time, as did (IIRC) NetBSD/OpenBSD.

