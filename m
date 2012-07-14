Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab2GNJfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 05:35:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59214 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2GNJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 05:35:20 -0400
Date: Sat, 14 Jul 2012 11:35:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120714093505.GB23316@elf.ucw.cz>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20472.466.594018.973876@pilspetsen.it.uu.se>
 <20120710101223.GF15120@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710101223.GF15120@arm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2012-07-10 11:12:23, Catalin Marinas wrote:
> On Sat, Jul 07, 2012 at 10:30:58AM +0100, Mikael Pettersson wrote:
> > Catalin Marinas writes:
> >  > Compilation requires a new aarch64-none-linux-gnu-
> >  > toolchain (http://gcc.gnu.org/ml/gcc-patches/2012-05/msg01694.html).
> > 
> > Where are the corresponding binutils patches?  Without those it's
> > impossible for people outside ARM to build the toolchain and kernel.
> 
> That's coming soon ;)

Actually, there's very little arm64 assembly written just now, what
about using some reasonble syntax for the assembler?

hexagon has something quite reasonable. Of course, one can not write
such assembly without knowing the details, but at least one can read
it... and maybe review.

Hmm?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
