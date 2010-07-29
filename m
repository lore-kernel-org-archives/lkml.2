Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab0G2ROh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 13:14:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61048 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab0G2ROf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 13:14:35 -0400
Date: Thu, 29 Jul 2010 10:13:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
Subject: [PATCH -next] mtd: redwood depends on MTD_PARTITIONS
Message-Id: <20100729101306.36c20611.randy.dunlap@oracle.com>
In-Reply-To: <20100729143211.9e7edaed.sfr@canb.auug.org.au>
References: <20100729143211.9e7edaed.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C51B6ED.01CE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

redwood uses add/del_mtd_partitions(), so it should depend on
MTD_PARTITIONS.

ERROR: "add_mtd_partitions" [drivers/mtd/maps/redwood.ko] undefined!
ERROR: "del_mtd_partitions" [drivers/mtd/maps/redwood.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/mtd/maps/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100729.orig/drivers/mtd/maps/Kconfig
+++ linux-next-20100729/drivers/mtd/maps/Kconfig
@@ -321,7 +321,7 @@ config MTD_CFI_FLAGADM
 
 config MTD_REDWOOD
 	tristate "CFI Flash devices mapped on IBM Redwood"
-	depends on MTD_CFI
+	depends on MTD_CFI && MTD_PARTITIONS
 	help
 	  This enables access routines for the flash chips on the IBM
 	  Redwood board. If you have one of these boards and would like to
