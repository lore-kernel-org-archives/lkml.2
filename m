Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1H2PLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:11:25 -0400
Received: from trent.utfs.org ([194.246.123.103]:48556 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab1H2PLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:11:23 -0400
Date: Mon, 29 Aug 2011 08:11:20 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: LKML <linux-kernel@vger.kernel.org>, Trond.Myklebust@netapp.com,
        neilb@suse.de, bfields@redhat.com
Subject: Re: undefined reference to `sys_nfsservctl'
In-Reply-To: <20110829161726.c980a80258fe714db49b425b@canb.auug.org.au>
Message-ID: <alpine.DEB.2.01.1108290809260.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1108282138020.9183@trent.utfs.org> <20110829161726.c980a80258fe714db49b425b@canb.auug.org.au>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 at 16:17, Stephen Rothwell wrote:
> >   MODPOST vmlinux.o
> > WARNING: modpost: Found 1 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >   GEN     .version
> >   CHK     include/generated/compile.h
> >   UPD     include/generated/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > arch/powerpc/kernel/built-in.o: In function `sys_call_table':
> > (.text+0x5be0): undefined reference to `sys_nfsservctl'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make: *** [sub-make] Error 2
> 
> I posted a patch to Linus earlier today (subject of lkml message:
> "linux-next: build failure in Linus' tree").

Ah, thanks. Will try. Meanwhile I've just reverted 
f5b940997397229975ea073679b03967932a541b (All Arch: remove linkage for 
sys_nfsservctl system call) and it compiled w/o errors too.

Christian.
-- 
BOFH excuse #364:

Sand fleas eating the Internet cables
