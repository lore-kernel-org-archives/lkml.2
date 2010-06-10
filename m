Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab0FJQiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:38:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64358 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0FJQiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YZ7/MGuLPwIAHG0EQWe05bfvjefCPcKBYjoUJ+wT+XMtwvL72pI29e34f9IvlBff5q
         br37G1rZNCnMi+AL9kX11ZKd8PEgFPncTsChHj0lhI9HIMVzGUYkzIaNUDVKQL5IMcTS
         RNQrUknVp25gmq9UmlSso4yo7H18TdTpsxTfQ=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: pe1dnn@amsat.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tj@kernel.org, devel@driverdev.osuosl.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] [staging-next] [4] Staging: wl_cs.c: fixed C99 comments style issues in wl_cs.c
Date: Thu, 10 Jun 2010 22:08:11 +0530
Message-Id: <1276187891-6644-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the wl_cs.c file that fixes the C99 comments
style issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/wlags49_h2/wl_cs.c |   38 ++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 52c293a..20315f0 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -150,7 +150,7 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 	link->io.Attributes1    = IO_DATA_PATH_WIDTH_16;
 	link->io.IOAddrLines    = 6;
 	link->irq.Attributes    = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
-	// link->irq.IRQInfo1      = IRQ_INFO2_VALID | IRQ_LEVEL_ID;
+	/* link->irq.IRQInfo1      = IRQ_INFO2_VALID | IRQ_LEVEL_ID; */
 	link->irq.Handler       = &wl_isr;
 	link->conf.Attributes   = CONF_ENABLE_IRQ;
 	link->conf.IntType      = INT_MEMORY_AND_IO;
@@ -165,7 +165,7 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 
 	DBG_LEAVE(DbgInfo);
 	return 0;
-} // wl_adapter_attach
+} /* wl_adapter_attach */
 /*============================================================================*/
 
 
@@ -210,7 +210,7 @@ static void wl_adapter_detach(struct pcmcia_device *link)
 	wl_device_dealloc(dev);
 
 	DBG_LEAVE(DbgInfo);
-} // wl_adapter_detach
+} /* wl_adapter_detach */
 /*============================================================================*/
 
 
@@ -246,21 +246,21 @@ void wl_adapter_release(struct pcmcia_device *link)
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
@@ -271,7 +271,7 @@ static int wl_adapter_resume(struct pcmcia_device *link)
 	netif_device_attach(dev);
 
 	return 0;
-} // wl_adapter_resume
+} /* wl_adapter_resume */
 
 /*******************************************************************************
  *	wl_adapter_insert()
@@ -346,7 +346,7 @@ failed:
 
 	DBG_LEAVE(DbgInfo);
 	return;
-} // wl_adapter_insert
+} /* wl_adapter_insert */
 /*============================================================================*/
 
 
@@ -398,7 +398,7 @@ int wl_adapter_open(struct net_device *dev)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wl_adapter_open
+} /* wl_adapter_open */
 /*============================================================================*/
 
 
@@ -443,7 +443,7 @@ int wl_adapter_close(struct net_device *dev)
 
 	DBG_LEAVE(DbgInfo);
 	return 0;
-} // wl_adapter_close
+} /* wl_adapter_close */
 /*============================================================================*/
 
 static struct pcmcia_device_id wl_adapter_ids[] = {
@@ -455,7 +455,7 @@ static struct pcmcia_device_id wl_adapter_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0004),
 	PCMCIA_DEVICE_PROD_ID12("Linksys", "WCF54G_Wireless-G_CompactFlash_Card",
 				0x0733cc81, 0x98a599e1),
-#endif  // (HCF_TYPE) & HCF_TYPE_HII5
+#endif  /* (HCF_TYPE) & HCF_TYPE_HII5 */
 	PCMCIA_DEVICE_NULL,
 };
 MODULE_DEVICE_TABLE(pcmcia, wl_adapter_ids);
@@ -505,7 +505,7 @@ int wl_adapter_init_module(void)
 
 	DBG_LEAVE(DbgInfo);
 	return ret;
-} // wl_adapter_init_module
+} /* wl_adapter_init_module */
 /*============================================================================*/
 
 
@@ -536,7 +536,7 @@ void wl_adapter_cleanup_module(void)
 
 	DBG_LEAVE(DbgInfo);
 	return;
-} // wl_adapter_cleanup_module
+} /* wl_adapter_cleanup_module */
 /*============================================================================*/
 
 
@@ -568,7 +568,7 @@ int wl_adapter_is_open(struct net_device *dev)
 		return 0;
 
 	return(link->open);
-} // wl_adapter_is_open
+} /* wl_adapter_is_open */
 /*============================================================================*/
 
 #if DBG
@@ -636,8 +636,8 @@ const char* DbgEvent(int mask)
 	if (mask & CS_EVENT_REGISTRATION_COMPLETE)
 		strcat(pBuf, "REGISTRATION_COMPLETE ");
 
-	// if(mask & CS_EVENT_RESET_COMPLETE)
-	//     strcat( pBuf, "RESET_COMPLETE " );
+	/* if(mask & CS_EVENT_RESET_COMPLETE)
+	     strcat( pBuf, "RESET_COMPLETE " ); */
 
 	if (mask & CS_EVENT_PM_SUSPEND)
 		strcat(pBuf, "PM_SUSPEND ");
@@ -679,7 +679,7 @@ const char* DbgEvent(int mask)
 	}
 
 	return pBuf;
-} // DbgEvent
+} /* DbgEvent */
 /*============================================================================*/
 
 #endif  /* DBG */
-- 
1.6.0.4

