Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2LKVuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:50:55 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:60043 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab2LKVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:25 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Ben Dooks <ben-linux@fluff.org>, Vincent Sanders <vince@simtec.co.uk>,
        Simtec Linux Team <linux@simtec.co.uk>
Subject: [PATCH 18/19] MAINTAINERS: fix BAST
Date: Tue, 11 Dec 2012 19:50:00 -0200
Message-Id: <1355262601-4263-19-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files were renamed by commit 85fd6d6 (ARM: S3C2410: move
mach-s3c2410/* into mach-s3c24xx/).

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Vincent Sanders <vince@simtec.co.uk>
Cc: Simtec Linux Team <linux@simtec.co.uk>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 26363fd..f900562 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6642,9 +6642,9 @@ P:	Vincent Sanders <vince@simtec.co.uk>
 M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
-F:	arch/arm/mach-s3c2410/mach-bast.c
-F:	arch/arm/mach-s3c2410/bast-ide.c
-F:	arch/arm/mach-s3c2410/bast-irq.c
+F:	arch/arm/mach-s3c24xx/mach-bast.c
+F:	arch/arm/mach-s3c24xx/bast-ide.c
+F:	arch/arm/mach-s3c24xx/bast-irq.c
 
 TI DAVINCI MACHINE SUPPORT
 M:	Sekhar Nori <nsekhar@ti.com>
-- 
1.7.11.7

