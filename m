Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab0JPPbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 11:31:38 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:46605 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0JPPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:31:37 -0400
Date: Sat, 16 Oct 2010 17:31:34 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.36-rc8
In-Reply-To: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Stephen,

On Sat, 16 Oct 2010, Geert Uytterhoeven wrote:
> 162 regressions:
> 	src/fs/9p/vfs_inode.c: error: implicit declaration of function 'inode_setattr':  => 1267
> 	src/include/linux/vgaarb.h: error: asm/vga.h: No such file or directory:  => 34:21

These two are reported for m68k/allmodconfig:
http://kisskb.ellerman.id.au/kisskb/buildresult/3387901/, but I cannot
reproduce them.

Moreover, there's no call to inode_setattr on line 1267 of
src/fs/9p/vfs_inode.c.
The same is true for line 34 of include/linux/vgaarb.h.

For the second failure, I know it's been fixed since
71beefe8c0b9e12ed4ac9fe13b98a035ddeaf8eb.

Do you know what's happening here?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
