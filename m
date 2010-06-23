Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab0FWGrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:47:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35822 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0FWGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:47:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UnOV2RLxqQkCm44HDtAHxOPNWEyuIK3RdP3DCEH41qRddX5jXrBKu1IFWDk264GP8F
         Y2+RSi2qSBmgf8pQvgzlxJPasLLaVM2CZ7ythXPcBH+RaG/EeZIgPG2j//7TJQQIO1KE
         VHcUbzrKW6a8ZBVpJ2J+xqpDK7bTkUc/UrLc4=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: pe1dnn@amsat.org, akpm@linux-foundation.org, tj@kernel.org,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] [staging-next] [3] Staging: wl_cs.c: fixed style issues in wl_cs.c
Date: Wed, 23 Jun 2010 12:17:02 +0530
Message-Id: <1277275622-6340-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the wl_cs.c file that fixes braces, spaces
parentheses, etc style issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/wlags49_h2/wl_cs.c |   73 ++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index fbc09b3..464b067 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -135,7 +135,7 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 {
 	struct net_device   *dev;
 	struct wl_private   *lp;
-	/*------------------------------------------------------------------------*/
+	/*--------------------------------------------------------------------*/
 
 	DBG_FUNC("wl_adapter_attach");
 	DBG_ENTER(DbgInfo);
@@ -162,7 +162,7 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 
 	DBG_LEAVE(DbgInfo);
 	return 0;
-} // wl_adapter_attach
+} /* wl_adapter_attach */
 /*============================================================================*/
 
 
@@ -191,8 +191,7 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 static void wl_adapter_detach(struct pcmcia_device *link)
 {
 	struct net_device   *dev = link->priv;
-	/*------------------------------------------------------------------------*/
-
+	/*--------------------------------------------------------------------*/
 
 	DBG_FUNC("wl_adapter_detach");
 	DBG_ENTER(DbgInfo);
@@ -208,7 +207,7 @@ static void wl_adapter_detach(struct pcmcia_device *link)
 	wl_device_dealloc(dev);
 
 	DBG_LEAVE(DbgInfo);
-} // wl_adapter_detach
+} /* wl_adapter_detach */
 /*============================================================================*/
 
 
@@ -244,21 +243,21 @@ void wl_adapter_release(struct pcmcia_device *link)
 	pcmcia_disable_device(link);
 
 	DBG_LEAVE(DbgInfo);
-} // wl_adapter_release
+} /* wl_adapter_release */
 /*============================================================================*/
 
 static int wl_adapter_suspend(struct pcmcia_device *link)
 {
 	struct net_device *dev = link->priv;
 
-	//if (link->open) {
+	/* if (link->open) { */
 	netif_device_detach(dev);
 	wl_suspend(dev);
-	//// CHECK! pcmcia_release_configuration(link->handle);
-	//}
+	/* CHECK! pcmcia_release_configuration(link->handle); */
+	/* } */
 
 	return 0;
-} // wl_adapter_suspend
+} /* wl_adapter_suspend */
 
 static int wl_adapter_resume(struct pcmcia_device *link)
 {
@@ -269,7 +268,7 @@ static int wl_adapter_resume(struct pcmcia_device *link)
 	netif_device_attach(dev);
 
 	return 0;
-} // wl_adapter_resume
+} /* wl_adapter_resume */
 
 /*******************************************************************************
  *	wl_adapter_insert()
@@ -296,7 +295,7 @@ void wl_adapter_insert(struct pcmcia_device *link)
 	struct net_device *dev;
 	int i;
 	int ret;
-	/*------------------------------------------------------------------------*/
+	/*--------------------------------------------------------------------*/
 
 	DBG_FUNC("wl_adapter_insert");
 	DBG_ENTER(DbgInfo);
@@ -332,9 +331,8 @@ void wl_adapter_insert(struct pcmcia_device *link)
 
 	printk(KERN_INFO "%s: Wireless, io_addr %#03lx, irq %d, ""mac_address ",
 		dev->name, dev->base_addr, dev->irq);
-	for (i = 0; i < ETH_ALEN; i++) {
+	for (i = 0; i < ETH_ALEN; i++)
 		printk("%02X%c", dev->dev_addr[i], ((i < (ETH_ALEN-1)) ? ':' : '\n'));
-	}
 
 	DBG_LEAVE(DbgInfo);
 	return;
@@ -344,7 +342,7 @@ failed:
 
 	DBG_LEAVE(DbgInfo);
 	return;
-} // wl_adapter_insert
+} /* wl_adapter_insert */
 /*============================================================================*/
 
 
@@ -373,16 +371,14 @@ int wl_adapter_open(struct net_device *dev)
 	struct pcmcia_device *link = lp->link;
 	int result = 0;
 	int hcf_status = HCF_SUCCESS;
-	/*------------------------------------------------------------------------*/
-
+	/*--------------------------------------------------------------------*/
 
 	DBG_FUNC("wl_adapter_open");
 	DBG_ENTER(DbgInfo);
 	DBG_PRINT("%s\n", VERSION_INFO);
 	DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
 
-	if (!pcmcia_dev_present(link))
-	{
+	if (!pcmcia_dev_present(link)) {
 		DBG_LEAVE(DbgInfo);
 		return -ENODEV;
 	}
@@ -398,7 +394,7 @@ int wl_adapter_open(struct net_device *dev)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wl_adapter_open
+} /* wl_adapter_open */
 /*============================================================================*/
 
 
@@ -425,8 +421,7 @@ int wl_adapter_close(struct net_device *dev)
 {
 	struct wl_private *lp = wl_priv(dev);
 	struct pcmcia_device *link = lp->link;
-	/*------------------------------------------------------------------------*/
-
+	/*--------------------------------------------------------------------*/
 
 	DBG_FUNC("wl_adapter_close");
 	DBG_ENTER(DbgInfo);
@@ -444,11 +439,11 @@ int wl_adapter_close(struct net_device *dev)
 
 	DBG_LEAVE(DbgInfo);
 	return 0;
-} // wl_adapter_close
+} /* wl_adapter_close */
 /*============================================================================*/
 
 static struct pcmcia_device_id wl_adapter_ids[] = {
-#if ! ((HCF_TYPE) & HCF_TYPE_HII5)
+#if !((HCF_TYPE) & HCF_TYPE_HII5)
 	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0003),
 	PCMCIA_DEVICE_PROD_ID12("Agere Systems", "Wireless PC Card Model 0110",
 				0x33103a9b, 0xe175b0dd),
@@ -456,7 +451,7 @@ static struct pcmcia_device_id wl_adapter_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0004),
 	PCMCIA_DEVICE_PROD_ID12("Linksys", "WCF54G_Wireless-G_CompactFlash_Card",
 				0x0733cc81, 0x98a599e1),
-#endif  // (HCF_TYPE) & HCF_TYPE_HII5
+#endif  /* (HCF_TYPE) & HCF_TYPE_HII5 */
 	PCMCIA_DEVICE_NULL,
 };
 MODULE_DEVICE_TABLE(pcmcia, wl_adapter_ids);
@@ -496,8 +491,7 @@ static struct pcmcia_driver wlags49_driver = {
 int wl_adapter_init_module(void)
 {
 	int ret;
-	/*------------------------------------------------------------------------*/
-
+	/*--------------------------------------------------------------------*/
 
 	DBG_FUNC("wl_adapter_init_module");
 	DBG_ENTER(DbgInfo);
@@ -507,7 +501,7 @@ int wl_adapter_init_module(void)
 
 	DBG_LEAVE(DbgInfo);
 	return ret;
-} // wl_adapter_init_module
+} /* wl_adapter_init_module */
 /*============================================================================*/
 
 
@@ -539,7 +533,7 @@ void wl_adapter_cleanup_module(void)
 
 	DBG_LEAVE(DbgInfo);
 	return;
-} // wl_adapter_cleanup_module
+} /* wl_adapter_cleanup_module */
 /*============================================================================*/
 
 
@@ -567,12 +561,11 @@ int wl_adapter_is_open(struct net_device *dev)
 	struct wl_private *lp = wl_priv(dev);
 	struct pcmcia_device *link = lp->link;
 
-	if (!pcmcia_dev_present(link)) {
+	if (!pcmcia_dev_present(link))
 		return 0;
-	}
 
-	return(link->open);
-} // wl_adapter_is_open
+	return link->open;
+} /* wl_adapter_is_open */
 /*============================================================================*/
 
 
@@ -596,12 +589,11 @@ int wl_adapter_is_open(struct net_device *dev)
  *      a pointer to a string describing the error(s)
  *
  ******************************************************************************/
-const char* DbgEvent(int mask)
+const char *DbgEvent(int mask)
 {
 	static char DbgBuffer[256];
 	char *pBuf;
-	/*------------------------------------------------------------------------*/
-
+	/*--------------------------------------------------------------------*/
 
 	pBuf    = DbgBuffer;
 	*pBuf   = '\0';
@@ -643,8 +635,8 @@ const char* DbgEvent(int mask)
 	if (mask & CS_EVENT_REGISTRATION_COMPLETE)
 		strcat(pBuf, "REGISTRATION_COMPLETE ");
 
-	// if (mask & CS_EVENT_RESET_COMPLETE)
-		// strcat(pBuf, "RESET_COMPLETE ");
+	/* if (mask & CS_EVENT_RESET_COMPLETE)
+		strcat(pBuf, "RESET_COMPLETE "); */
 
 	if (mask & CS_EVENT_PM_SUSPEND)
 		strcat(pBuf, "PM_SUSPEND ");
@@ -680,13 +672,12 @@ const char* DbgEvent(int mask)
 	if (*pBuf) {
 		pBuf[strlen(pBuf) - 1] = '\0';
 	} else {
-		if (mask != 0x0) {
+		if (mask != 0x0)
 			sprintf(pBuf, "<<0x%08x>>", mask);
-		}
 	}
 
 	return pBuf;
-} // DbgEvent
+} /* DbgEvent */
 /*============================================================================*/
 
 #endif  /* DBG */
-- 
1.6.0.4

