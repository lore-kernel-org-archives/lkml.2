Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1CZGWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 02:22:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60249 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab1CZGWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 02:22:14 -0400
Date: Sat, 26 Mar 2011 17:22:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH] apm: orphan the driver
Message-Id: <20110326172204.05e52c10.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 MAINTAINERS |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

I no longer have access to any hardware that uses APM and have not
provided real maintenance for several years.  Hopefully someone with the
hardware or energy will step forward if the driver is to be kept.

diff --git a/MAINTAINERS b/MAINTAINERS
index 749f9cd..61f9948 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -548,10 +548,8 @@ S:	Maintained
 F:	sound/aoa/
 
 APM DRIVER
-M:	Stephen Rothwell <sfr@canb.auug.org.au>
 L:	linux-laptop@vger.kernel.org
-W:	http://www.canb.auug.org.au/~sfr/
-S:	Supported
+S:	Orphan
 F:	arch/x86/kernel/apm_32.c
 F:	include/linux/apm_bios.h
 
-- 
1.7.4.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
