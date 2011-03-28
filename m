Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1C1RYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:24:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab1C1RYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:24:45 -0400
Date: Mon, 28 Mar 2011 19:24:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] apm: orphan the driver
In-Reply-To: <1301321667.30628.21.camel@Joe-Laptop>
Message-ID: <alpine.LNX.2.00.1103281924010.26754@pobox.suse.cz>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au>  <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz>  <20110329004438.d9e755ef.sfr@canb.auug.org.au>  <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz> <1301321667.30628.21.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Joe Perches wrote:

> > > > I still have some hardware that uses APM and put a new 2.6 on it time 
> > > > to time, so I can take this driver over if you want to. According to 
> > > > git log it's really low effort anyway :)
> > > If you want it, its yours :-)
> > Not really fighting for maintaining it actively, but can certainly give it 
> > some care when necessary.
> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > @@ -548,8 +548,9 @@ S:	Maintained
> >  F:	sound/aoa/
> >  
> >  APM DRIVER
> > -L:	linux-laptop@vger.kernel.org
> > -S:	Orphan
> > +M:	Jiri Kosina <jkosina@suse.cz>
> > +L:	linux-kernel@vger.kernel.org
> 
> Please don't add L: LKML as it's the default
> and it could confuse people that read the file
> and see some sections with LKML and other without
> and may think that LKML is somehow optional.
> 
> > +S:	Maintained
> 
> If you're not actively maintaining it, maybe
> S:	Odd Fixes
> instead?

Whatever ...



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] APM: take over maintainership

Commit 04a6553f076 ("apm: orphan the driver") Orphaned the APM
driver as Stephen is not willing/able to maintain it any more.

As I still have some hardware that is using APM and running 2.6,
I can take it over.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8aa1cac..a8f2705 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -548,8 +548,8 @@ S:	Maintained
 F:	sound/aoa/
 
 APM DRIVER
-L:	linux-laptop@vger.kernel.org
-S:	Orphan
+M:	Jiri Kosina <jkosina@suse.cz>
+S:	Odd Fixes
 F:	arch/x86/kernel/apm_32.c
 F:	include/linux/apm_bios.h
 
-- 
1.7.3.1

