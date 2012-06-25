Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab2FYKVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:21:13 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1559 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab2FYKVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:21:12 -0400
Message-ID: <1340619670.1773.162.camel@x61.thuisdomein>
Subject: ARM: BAST: update MAINTAINERS entry
From: Paul Bolle <pebolle@tiscali.nl>
To: Simtec Linux Team <linux@simtec.co.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 12:21:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 25 Jun 2012 10:21:11.0020 (UTC) FILETIME=[3DF1D2C0:01CD52BC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 85fd6d63bf2927b9da7ab1b0d46723bfdb13808c ("ARM: S3C2410: move
mach-s3c2410/* into mach-s3c24xx/") moved the three files mentioned in
the "SIMTEC EB2410ITX (BAST)" MAINTAINERS entry to the arch/arm/s3c24xx
directory. Update that entry accordingly.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb22272..df09359 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6145,9 +6145,9 @@ P:	Vincent Sanders <vince@simtec.co.uk>
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
1.7.7.6

