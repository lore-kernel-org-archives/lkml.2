Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0C2RyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:54:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:41488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab0C2RyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:54:10 -0400
From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 15/17] libata: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:43 +0900
Message-Id: <1269885165-18617-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269885165-18617-1-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 17:53:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/ata/ahci_platform.c |    1 +
 drivers/ata/libahci.c       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 42cdd73..19bfd1d 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/gfp.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 3f586ec..34fc57d 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -33,6 +33,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/gfp.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
-- 
1.6.4.2

