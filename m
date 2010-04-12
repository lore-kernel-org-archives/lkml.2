Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0DLUAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:00:53 -0400
Received: from mail.perches.com ([173.55.12.10]:1445 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0DLUAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:00:52 -0400
Subject: [PATCH] MAINTAINERS: arch/arm/s3c and arch/arm/s5p
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100412194737.GS3048@n2100.arm.linux.org.uk>
References: <cover.1269655208.git.joe@perches.com>
	 <0c97f736400ec243e71ba794ae7046a61d2449c1.1269655208.git.joe@perches.com>
	 <20100412194737.GS3048@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 13:00:50 -0700
Message-ID: <1271102450.2131.27.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 20:47 +0100, Russell King - ARM Linux wrote:
> This is Samsung stuff, it should be copied to Ben (added).

Maybe this is appropriate?

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   40 ++++++++--------------------------------
 1 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a9ccda..5a0d6ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -902,48 +902,24 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-s3c/
 F:	arch/arm/plat-s3c24xx/
+F:	arch/arm/plat-samsung/
 
-ARM/S3C2410 ARM ARCHITECTURE
+ARM/S3Cxxxx ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
-F:	arch/arm/mach-s3c2410/
-
-ARM/S3C2440 ARM ARCHITECTURE
-M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.fluff.org/ben/linux/
-S:	Maintained
-F:	arch/arm/mach-s3c2440/
-
-ARM/S3C2442 ARM ARCHITECTURE
-M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.fluff.org/ben/linux/
-S:	Maintained
-F:	arch/arm/mach-s3c2442/
-
-ARM/S3C2443 ARM ARCHITECTURE
-M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.fluff.org/ben/linux/
-S:	Maintained
-F:	arch/arm/mach-s3c2443/
-
-ARM/S3C6400 ARM ARCHITECTURE
-M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.fluff.org/ben/linux/
-S:	Maintained
-F:	arch/arm/mach-s3c6400/
+F:	arch/arm/mach-s3c????/
+F:	arch/arm/plat-s3c????/
 
-ARM/S3C6410 ARM ARCHITECTURE
+ARM/S5Pxxxx ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
-F:	arch/arm/mach-s3c6410/
+F:	arch/arm/mach-s5p????/
+F:	arch/arm/plat-s5p/
+F:	arch/arm/plat-s5p????/
 
 ARM/SHMOBILE ARM ARCHITECTURE
 M:	Paul Mundt <lethal@linux-sh.org>


