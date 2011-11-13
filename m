Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab1KMS04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 13:26:56 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:54534 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1KMS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 13:26:55 -0500
Subject: [PATCH] [TRIVIAL] powerpc/mpc5121: drop "select  MPC5121_ADS_CPLD"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 19:26:53 +0100
Message-ID: <1321208813.20271.76.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no Kconfig symbol named MPC5121_ADS_CPLD. The select statement
for that symbol is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "yes "" | make ARCH=powerpc config" before and after
applying this patch. Identical .config files were generated, as was
expected.

1) This select statement was added in commit 1879f711d8
("powerpc/mpc5121: Add support for CPLD on MPC5121ADS board"). Perhaps
there was some confusion about the amount of magic actually involved in
the kbuild system.

 arch/powerpc/platforms/512x/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/512x/Kconfig b/arch/powerpc/platforms/512x/Kconfig
index b3ebce1..c169998 100644
--- a/arch/powerpc/platforms/512x/Kconfig
+++ b/arch/powerpc/platforms/512x/Kconfig
@@ -12,7 +12,6 @@ config MPC5121_ADS
 	bool "Freescale MPC5121E ADS"
 	depends on PPC_MPC512x
 	select DEFAULT_UIMAGE
-	select MPC5121_ADS_CPLD
 	help
 	  This option enables support for the MPC5121E ADS board.
 
-- 
1.7.4.4



