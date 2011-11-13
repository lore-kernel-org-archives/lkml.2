Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1KMAWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 19:22:48 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:54507 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1KMAWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 19:22:47 -0500
Subject: [PATCH] [TRIVIAL] powerpc/4xx: Fix typo 'PCC4xx_MSI'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, Tirumala R Marri <tmarri@apm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 01:22:40 +0100
Message-ID: <1321143760.20271.31.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This corrects an obvious typo. It is untested.

1) This could influence the code generated for the "AMCC PPC440SPe
evaluation board". So I've CC'd the people involved in commit 3fb7933850
("powerpc/4xx: Adding PCIe MSI support"), which introduced this typo, to
actually test this.

 arch/powerpc/platforms/44x/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 762322c..9c37179 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -75,7 +75,7 @@ config KATMAI
 	select PCI
 	select PPC4xx_PCI_EXPRESS
 	select PCI_MSI
-	select PCC4xx_MSI
+	select PPC4xx_MSI
 	help
 	  This option enables support for the AMCC PPC440SPe evaluation board.
 
-- 
1.7.4.4

