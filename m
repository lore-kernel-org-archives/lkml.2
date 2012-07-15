Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2GOLhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 07:37:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35547 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624Ab2GOLhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 07:37:04 -0400
Date: Sun, 15 Jul 2012 12:36:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120715113631.GA10597@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20472.466.594018.973876@pilspetsen.it.uu.se>
 <20120710101223.GF15120@arm.com>
 <20120714093505.GB23316@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714093505.GB23316@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 10:35:05AM +0100, Pavel Machek wrote:
> On Tue 2012-07-10 11:12:23, Catalin Marinas wrote:
> > On Sat, Jul 07, 2012 at 10:30:58AM +0100, Mikael Pettersson wrote:
> > > Catalin Marinas writes:
> > >  > Compilation requires a new aarch64-none-linux-gnu-
> > >  > toolchain (http://gcc.gnu.org/ml/gcc-patches/2012-05/msg01694.html).
> > > 
> > > Where are the corresponding binutils patches?  Without those it's
> > > impossible for people outside ARM to build the toolchain and kernel.
> > 
> > That's coming soon ;)
> 
> Actually, there's very little arm64 assembly written just now, what
> about using some reasonble syntax for the assembler?

The assembly syntax is very reasonable already and not far from what we
are used to (see the .S files in my kernel patches). The 64-bit
instructions are different and that's specified here (apart from the
actual bit encoding):

http://infocenter.arm.com/help/topic/com.arm.doc.genc010197a/index.html

> hexagon has something quite reasonable. Of course, one can not write
> such assembly without knowing the details, but at least one can read
> it... and maybe review.

Same here, one can read and review them. I doubt reviewers care about
the bit encoding ;).

-- 
Catalin
