Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1GaQ56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 12:57:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:40226 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1GaQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 12:57:53 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>
Date: Sun, 31 Jul 2011 17:57:46 +0100
In-Reply-To: <20110731093740.39f7fbc3.rdunlap@xenotime.net>
References: <1312067499.22074.59.camel@i7.infradead.org>
	 <1312067670.22074.61.camel@i7.infradead.org>
	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	 <4E34998D.8060806@zytor.com>
	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	 <4E34A1E4.8040103@zytor.com>
	 <CACqU3MVkLXoBq7KP2Jff=p7EiKR7DkPa4z7y0Rdah-dGzRvj4g@mail.gmail.com>
	 <1312097621.22074.71.camel@i7.infradead.org>
	 <20110731093740.39f7fbc3.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312131467.22074.95.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 09:37 -0700, Randy Dunlap wrote:
> Simple question:  what does "ARCH=x86" mean?
> 
> It doesn't mean anything to me without SUBARCH or nnBIT specified.

SUBARCH is meaningless for a native build; it's only for ARCH=um. So I
don't know why that would make anything more meaningful to you.

And why would CONFIG_64BIT make a difference either? Or conversely: why
do CONFIG_PAE, CONFIG_LITTLE_ENDIAN, etc. *not* make a difference to
your understanding?

ARCH=x86 means exactly what it says: "build a kernel for the x86
architecture".

Just like ARCH=mips means "build a kernel for MIPS" and ARCH=sparc means
"build a kernel for SPARC", and ARCH=parisc means "build a kernel for
PARISC", and ARCH=powerpc means "build a kernel for PowerPC". and
ARCH=s390 means "build a kernel for S390".

In *all* of those cases, CONFIG_64BIT is just one more configuration
option; one of *many* that define what actual hardware the kernel
supports.

-- 
dwmw2

