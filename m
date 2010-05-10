Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0EJViz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:38:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:38197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0EJVix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:38:53 -0400
Date: Mon, 10 May 2010 23:38:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 4/5] uml: i386: Avoid redefinition of NR_syscalls
In-Reply-To: <20100421061205.GC4467@cr0.nay.redhat.com>
Message-ID: <alpine.LNX.2.00.1005102338190.28092@pobox.suse.cz>
References: <cover.1271713955.git.jan.kiszka@web.de> <3e07ad1a38e88a22d7298deb88a8f3962b101998.1271713955.git.jan.kiszka@web.de> <20100420101056.GC5317@cr0.nay.redhat.com> <4BCDE103.7080709@web.de> <20100421061205.GC4467@cr0.nay.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010, Amerigo Wang wrote:

> >> Where?
> >
> >Not sure if this answers your question:
> >
> >  CC      arch/um/kernel/skas/syscall.o
> >/data/linux-2.6/arch/um/kernel/skas/syscall.c:13:1: warning:
> >"NR_syscalls" redefined
> >In file included from /data/linux-2.6/arch/x86/include/asm/unistd.h:3,
> >                 from
> >/data/linux-2.6/arch/um/sys-i386/shared/sysdep/syscalls.h:6,
> >                 from /data/linux-2.6/arch/um/kernel/skas/syscall.c:10:
> >/data/linux-2.6/arch/x86/include/asm/unistd_32.h:349:1: warning: this is
> >the location of the previous definition
> >
> 
> Ah, sure. I misunderstood your purpose, please do include the warning
> messages you are trying to fix in your patch description.

The patch doesn't seem to be present in linux-next as of today. I have 
applied it to my queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
