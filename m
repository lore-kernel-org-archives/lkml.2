Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab0D3RGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:06:39 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48812 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab0D3RFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:05:09 -0400
Date: Fri, 30 Apr 2010 18:04:31 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Inotify: Fix build failure in inotify user support
Message-ID: <20100430170431.GA948@linux-mips.org>
References: <20100308195103.GA9228@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308195103.GA9228@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 08:51:03PM +0100, Ralf Baechle wrote:

> CONFIG_INOTIFY_USER defined but CONFIG_ANON_INODES undefined will result
> in the following build failure:
> 
>   LD      vmlinux
> fs/built-in.o: In function 'sys_inotify_init1':
> (.text.sys_inotify_init1+0x22c): undefined reference to 'anon_inode_getfd'
> fs/built-in.o: In function `sys_inotify_init1':
> (.text.sys_inotify_init1+0x22c): relocation truncated to fit: R_MIPS_26 against 'anon_inode_getfd'
> make[2]: *** [vmlinux] Error 1
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2

Ping.  The problem still exists in rc6.

  Ralf
