Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1EBQwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 12:52:13 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:60047 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1EBQwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 12:52:11 -0400
Date: Mon, 2 May 2011 18:52:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuild@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 2 (uml builds fail)
Message-ID: <20110502165208.GA18740@merkur.ravnborg.org>
References: <20110502150150.d932642f.sfr@canb.auug.org.au> <20110502081948.1ccb9aef.rdunlap@xenotime.net> <20110502160405.GE15769@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502160405.GE15769@sepie.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 06:04:05PM +0200, Michal Marek wrote:
> On Mon, May 02, 2011 at 08:19:48AM -0700, Randy Dunlap wrote:
> > On Mon, 2 May 2011 15:01:50 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20110429:
> > 
> > 
> > uml builds on i386 or x86_64 fail with: (I'm using O=outputdir if it matters)
> > 
> >   GEN     /lnx/src/NEXT/linux-next-20110502/UM64/Makefile
> > scripts/kconfig/conf --silentoldconfig arch/um/Kconfig.x86
> >   GEN     /lnx/src/NEXT/linux-next-20110502/UM64/Makefile
> > /lnx/src/NEXT/linux-next-20110502/scripts/Makefile.asm-generic:9: /lnx/src/NEXT/linux-next-20110502/arch/um/include/asm/Kbuild: No such file or directory
> > make[2]: *** No rule to make target `/lnx/src/NEXT/linux-next-20110502/arch/um/include/asm/Kbuild'.  Stop.
> 
> This patch should fix it.
> 
> Michal
> 
> Subject: [PATCH] kbuild: Fix Makefile.asm-generic for um
> 
> Do nothing if arch/$(SRCARCH)/include/asm/Kbuild does not exist, which
> is the case of um.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Makes sense - sorry for not catchign the um case!

Acked-by: Sam Ravnborg <sam@ravnborg.org>


	Sam
