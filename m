Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0C2RxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:53:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:57104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab0C2RxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:53:04 -0400
From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 09/17] pcmcia: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:37 +0900
Message-Id: <1269885165-18617-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269885165-18617-1-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 17:52:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/isdn/hardware/avm/avm_cs.c |    1 -
 drivers/pcmcia/pcmcia_cis.c        |    1 +
 drivers/pcmcia/rsrc_iodyn.c        |    1 +
 3 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/avm/avm_cs.c b/drivers/isdn/hardware/avm/avm_cs.c
index 8bbc452..f410d0e 100644
--- a/drivers/isdn/hardware/avm/avm_cs.c
+++ b/drivers/isdn/hardware/avm/avm_cs.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/ptrace.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
diff --git a/drivers/pcmcia/pcmcia_cis.c b/drivers/pcmcia/pcmcia_cis.c
index 7406387..4a65eaf 100644
--- a/drivers/pcmcia/pcmcia_cis.c
+++ b/drivers/pcmcia/pcmcia_cis.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
diff --git a/drivers/pcmcia/rsrc_iodyn.c b/drivers/pcmcia/rsrc_iodyn.c
index 7791375..d0bf350 100644
--- a/drivers/pcmcia/rsrc_iodyn.c
+++ b/drivers/pcmcia/rsrc_iodyn.c
@@ -12,6 +12,7 @@
  * (C) 1999		David A. Hinds
  */
 
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 
-- 
1.6.4.2

