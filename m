Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587Ab0FJQio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:38:44 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:35488 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759530Ab0FJQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QzOM2cxzk08s4BIdVv7pWrjAn/fXr5cxMcbMpXlKVxXSeYKAQoZnEAxgv9mxVoo/I5
         Eqr2UYdp3yzp8/1QiZiaUIOcM64u6VqjgoMbkOeduFD2Pscp+hDsvz1txTeLiqgAoPFc
         bfGNiatVclUffvqOk/i4i5rY5QWv6JoNOH/Hs=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: pe1dnn@amsat.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tj@kernel.org, devel@driverdev.osuosl.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] [staging-next] [5] Staging: wl_cs.c: fixed style issues in wl_cs.c
Date: Thu, 10 Jun 2010 22:08:32 +0530
Message-Id: <1276187912-6669-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the wl_cs.c file that fixes braces, spaces
parentheses, etc style issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/wlags49_h2/wl_cs.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 20315f0..19df99d 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -135,7 +135,7 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 {
 	struct net_device   *dev;
 	struct wl_private	*lp;
-	/*------------------------------------------------------------------------*/
+	/*--------------------------------------------------------------------*/
 
 	DBG_FUNC("wl_adapter_attach");
 	DBG_ENTER(DbgInfo);
@@ -334,9 +334,8 @@ void wl_adapter_insert(struct pcmcia_device *link)
 
 	printk(KERN_INFO "%s: Wireless, io_addr %#03lx, irq %d, ""mac_address ",
 	dev->name, dev->base_addr, dev->irq);
-	for (i = 0; i < ETH_ALEN; i++) {
+	for (i = 0; i < ETH_ALEN; i++)
 		printk("%02X%c", dev->dev_addr[i], ((i < (ETH_ALEN-1)) ? ':' : '\n'));
-	}
 
 	DBG_LEAVE(DbgInfo);
 	return;
@@ -447,7 +446,7 @@ int wl_adapter_close(struct net_device *dev)
 /*============================================================================*/
 
 static struct pcmcia_device_id wl_adapter_ids[] = {
-#if ! ((HCF_TYPE) & HCF_TYPE_HII5)
+#if !((HCF_TYPE) & HCF_TYPE_HII5)
 	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0003),
 	PCMCIA_DEVICE_PROD_ID12("Agere Systems", "Wireless PC Card Model 0110",
 				0x33103a9b, 0xe175b0dd),
@@ -567,7 +566,7 @@ int wl_adapter_is_open(struct net_device *dev)
 	if (!pcmcia_dev_present(link))
 		return 0;
 
-	return(link->open);
+	return link->open;
 } /* wl_adapter_is_open */
 /*============================================================================*/
 
@@ -591,7 +590,7 @@ int wl_adapter_is_open(struct net_device *dev)
  *      a pointer to a string describing the error(s)
  *
  ******************************************************************************/
-const char* DbgEvent(int mask)
+const char *DbgEvent(int mask)
 {
 	static char DbgBuffer[256];
 	char *pBuf;
@@ -673,9 +672,8 @@ const char* DbgEvent(int mask)
 	if (*pBuf) {
 		pBuf[strlen(pBuf) - 1] = '\0';
 	} else {
-		if (mask != 0x0) {
+		if (mask != 0x0)
 			sprintf(pBuf, "<<0x%08x>>", mask);
-		}
 	}
 
 	return pBuf;
-- 
1.6.0.4

