Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1C1OFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:05:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab1C1OFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:05:19 -0400
Date: Mon, 28 Mar 2011 16:05:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] apm: orphan the driver
In-Reply-To: <20110329004438.d9e755ef.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au> <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz> <20110329004438.d9e755ef.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011, Stephen Rothwell wrote:

> > I still have some hardware that uses APM and put a new 2.6 on it time 
> > to time, so I can take this driver over if you want to. According to 
> > git log it's really low effort anyway :)
> 
> If you want it, its yours :-)

Not really fighting for maintaining it actively, but can certainly give it 
some care when necessary.




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] APM: take over maintainership

Commit 04a6553f076 ("apm: orphan the driver") Orphaned the APM
driver as Stephen is not willing/able to maintain it any more.

As I still have some hardware that is using APM and running 2.6,
I can take it over.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 MAINTAINERS |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8aa1cac..758a690 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -548,8 +548,9 @@ S:	Maintained
 F:	sound/aoa/
 
 APM DRIVER
-L:	linux-laptop@vger.kernel.org
-S:	Orphan
+M:	Jiri Kosina <jkosina@suse.cz>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
 F:	arch/x86/kernel/apm_32.c
 F:	include/linux/apm_bios.h
 
-- 
1.7.3.1
