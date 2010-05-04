Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0EDIKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 04:10:21 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:46982 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab0EDIKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 04:10:19 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Inotify: Fix build failure in inotify user support
Date: Tue, 4 May 2010 10:09:33 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-server; KDE/4.4.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
References: <20100308195103.GA9228@linux-mips.org> <20100430170431.GA948@linux-mips.org>
In-Reply-To: <20100430170431.GA948@linux-mips.org>
Organization: Freebox
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005041009.33992.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 30 April 2010 19:04:31 Ralf Baechle wrote:
> On Mon, Mar 08, 2010 at 08:51:03PM +0100, Ralf Baechle wrote:
> > CONFIG_INOTIFY_USER defined but CONFIG_ANON_INODES undefined will result
> > 
> > in the following build failure:
> >   LD      vmlinux
> > 
> > fs/built-in.o: In function 'sys_inotify_init1':
> > (.text.sys_inotify_init1+0x22c): undefined reference to
> > 'anon_inode_getfd' fs/built-in.o: In function `sys_inotify_init1':
> > (.text.sys_inotify_init1+0x22c): relocation truncated to fit: R_MIPS_26
> > against 'anon_inode_getfd' make[2]: *** [vmlinux] Error 1
> > make[1]: *** [sub-make] Error 2
> > make: *** [all] Error 2
> 
> Ping.  The problem still exists in rc6.

Ralf's patch fixes the issue for me.

