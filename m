Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0JPWOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 18:14:46 -0400
Received: from xenotime.net ([72.52.115.56]:40371 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756568Ab0JPWOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 18:14:44 -0400
Date: Sat, 16 Oct 2010 15:14:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.36-rc8
Message-Id: <20101016151442.a21769f6.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
	<alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010 17:31:34 +0200 (CEST) Geert Uytterhoeven wrote:

> 	Hi Stephen,
> 
> On Sat, 16 Oct 2010, Geert Uytterhoeven wrote:
> > 162 regressions:
> > 	src/fs/9p/vfs_inode.c: error: implicit declaration of function 'inode_setattr':  => 1267
> > 	src/include/linux/vgaarb.h: error: asm/vga.h: No such file or directory:  => 34:21
> 
> These two are reported for m68k/allmodconfig:
> http://kisskb.ellerman.id.au/kisskb/buildresult/3387901/, but I cannot
> reproduce them.
> 
> Moreover, there's no call to inode_setattr on line 1267 of
> src/fs/9p/vfs_inode.c.
> The same is true for line 34 of include/linux/vgaarb.h.
> 
> For the second failure, I know it's been fixed since
> 71beefe8c0b9e12ed4ac9fe13b98a035ddeaf8eb.
> 
> Do you know what's happening here?

I can't see why that's happening, but then I can't find a function or macro
named 'inode_setattr' in the -rc8 kernel source tree at all.
Maybe it's a constructed name (i.e., with ##, stringify)?

BTW, do you use LC_ALL=C when doing builds?  I'd like to be able to read
messages like this one:

src/Documentation/spi/spidev_test.c:56: warning: (near initialization for ‘tr’): 1 warnings in 1 logs



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
