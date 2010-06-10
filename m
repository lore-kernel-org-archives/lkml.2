Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab0FJQhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:37:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44303 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0FJQhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wYFPZxiIA2XrSVKgIu6WvZTedFbvugWT0UkhpimIfHFowG7TUa2kwmBjKZm2v7C5X3
         8wqDwerdF6x8FdVi22JQlgnLRgBQkoUoqPPVJVMwZ+Nsh+outgzwCGen4c/RuXZVBVwK
         ySoyIlRLAp3IvyiH9oKga517EXIwMRAijFtvw=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: pe1dnn@amsat.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tj@kernel.org, devel@driverdev.osuosl.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] [staging-next] [1] Staging: wl_cs.c: fixed space style issues in wl_cs.c
Date: Thu, 10 Jun 2010 22:07:04 +0530
Message-Id: <1276187824-6569-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the wl_cs.c file that fixes the space
style issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/wlags49_h2/wl_cs.c |  204 ++++++++++++++++++------------------
 1 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 568993f..a716a40 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -137,12 +137,12 @@ static int wl_adapter_attach(struct pcmcia_device *link)
     struct wl_private	*lp;
     /*------------------------------------------------------------------------*/
 
-    DBG_FUNC( "wl_adapter_attach" );
-    DBG_ENTER( DbgInfo );
+    DBG_FUNC("wl_adapter_attach");
+    DBG_ENTER(DbgInfo);
 
     dev = wl_device_alloc();
-    if(dev == NULL) {
-        DBG_ERROR( DbgInfo, "wl_device_alloc returned NULL\n");
+    if (dev == NULL) {
+        DBG_ERROR(DbgInfo, "wl_device_alloc returned NULL\n");
 	return -ENOMEM;
     }
 
@@ -163,7 +163,7 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 
     wl_adapter_insert(link);
 
-    DBG_LEAVE( DbgInfo );
+    DBG_LEAVE(DbgInfo);
     return 0;
 } // wl_adapter_attach
 /*============================================================================*/
@@ -197,9 +197,9 @@ static void wl_adapter_detach(struct pcmcia_device *link)
     /*------------------------------------------------------------------------*/
 
 
-    DBG_FUNC( "wl_adapter_detach" );
-    DBG_ENTER( DbgInfo );
-    DBG_PARAM( DbgInfo, "link", "0x%p", link );
+    DBG_FUNC("wl_adapter_detach");
+    DBG_ENTER(DbgInfo);
+    DBG_PARAM(DbgInfo, "link", "0x%p", link);
 
     wl_adapter_release(link);
 
@@ -210,7 +210,7 @@ static void wl_adapter_detach(struct pcmcia_device *link)
 
     wl_device_dealloc(dev);
 
-    DBG_LEAVE( DbgInfo );
+    DBG_LEAVE(DbgInfo);
 } // wl_adapter_detach
 /*============================================================================*/
 
@@ -235,18 +235,18 @@ static void wl_adapter_detach(struct pcmcia_device *link)
  *      N/A
  *
  ******************************************************************************/
-void wl_adapter_release( struct pcmcia_device *link )
+void wl_adapter_release(struct pcmcia_device *link)
 {
-    DBG_FUNC( "wl_adapter_release" );
-    DBG_ENTER( DbgInfo );
-    DBG_PARAM( DbgInfo, "link", "0x%p", link);
+    DBG_FUNC("wl_adapter_release");
+    DBG_ENTER(DbgInfo);
+    DBG_PARAM(DbgInfo, "link", "0x%p", link);
 
     /* Stop hardware */
     wl_remove(link->priv);
 
     pcmcia_disable_device(link);
 
-    DBG_LEAVE( DbgInfo );
+    DBG_LEAVE(DbgInfo);
 } // wl_adapter_release
 /*============================================================================*/
 
@@ -269,7 +269,7 @@ static int wl_adapter_resume(struct pcmcia_device *link)
 
 	wl_resume(dev);
 
-	netif_device_attach( dev );
+	netif_device_attach(dev);
 
 	return 0;
 } // wl_adapter_resume
@@ -294,16 +294,16 @@ static int wl_adapter_resume(struct pcmcia_device *link)
  *      N/A
  *
  ******************************************************************************/
-void wl_adapter_insert( struct pcmcia_device *link )
+void wl_adapter_insert(struct pcmcia_device *link)
 {
     struct net_device       *dev;
     int i;
     int                     ret;
     /*------------------------------------------------------------------------*/
 
-    DBG_FUNC( "wl_adapter_insert" );
-    DBG_ENTER( DbgInfo );
-    DBG_PARAM( DbgInfo, "link", "0x%p", link );
+    DBG_FUNC("wl_adapter_insert");
+    DBG_ENTER(DbgInfo);
+    DBG_PARAM(DbgInfo, "link", "0x%p", link);
 
     dev     = link->priv;
 
@@ -335,15 +335,15 @@ void wl_adapter_insert( struct pcmcia_device *link )
 
     printk(KERN_INFO "%s: Wireless, io_addr %#03lx, irq %d, ""mac_address ",
                dev->name, dev->base_addr, dev->irq);
-    for( i = 0; i < ETH_ALEN; i++ ) {
+    for (i = 0; i < ETH_ALEN; i++) {
         printk("%02X%c", dev->dev_addr[i], ((i < (ETH_ALEN-1)) ? ':' : '\n'));
     }
 
-    DBG_LEAVE( DbgInfo );
+    DBG_LEAVE(DbgInfo);
     return;
 
 failed:
-    wl_adapter_release( link );
+    wl_adapter_release(link);
 
     DBG_LEAVE(DbgInfo);
     return;
@@ -370,7 +370,7 @@ failed:
  *      errno value otherwise
  *
  ******************************************************************************/
-int wl_adapter_open( struct net_device *dev )
+int wl_adapter_open(struct net_device *dev)
 {
     struct wl_private *lp = wl_priv(dev);
     struct pcmcia_device *link = lp->link;
@@ -379,27 +379,27 @@ int wl_adapter_open( struct net_device *dev )
     /*------------------------------------------------------------------------*/
 
 
-    DBG_FUNC( "wl_adapter_open" );
-    DBG_ENTER( DbgInfo );
-	DBG_PRINT( "%s\n", VERSION_INFO );
-    DBG_PARAM( DbgInfo, "dev", "%s (0x%p)", dev->name, dev );
+    DBG_FUNC("wl_adapter_open");
+    DBG_ENTER(DbgInfo);
+	DBG_PRINT("%s\n", VERSION_INFO);
+    DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
 
-    if(!pcmcia_dev_present(link))
+    if (!pcmcia_dev_present(link))
     {
-        DBG_LEAVE( DbgInfo );
+        DBG_LEAVE(DbgInfo);
         return -ENODEV;
     }
 
     link->open++;
 
-    hcf_status = wl_open( dev );
+    hcf_status = wl_open(dev);
 
-    if( hcf_status != HCF_SUCCESS ) {
+    if (hcf_status != HCF_SUCCESS) {
         link->open--;
         result = -ENODEV;
     }
 
-    DBG_LEAVE( DbgInfo );
+    DBG_LEAVE(DbgInfo);
     return result;
 } // wl_adapter_open
 /*============================================================================*/
@@ -424,28 +424,28 @@ int wl_adapter_open( struct net_device *dev )
  *      errno value otherwise
  *
  ******************************************************************************/
-int wl_adapter_close( struct net_device *dev )
+int wl_adapter_close(struct net_device *dev)
 {
     struct wl_private *lp = wl_priv(dev);
     struct pcmcia_device *link = lp->link;
     /*------------------------------------------------------------------------*/
 
 
-    DBG_FUNC( "wl_adapter_close" );
-    DBG_ENTER( DbgInfo );
-    DBG_PARAM( DbgInfo, "dev", "%s (0x%p)", dev->name, dev );
+    DBG_FUNC("wl_adapter_close");
+    DBG_ENTER(DbgInfo);
+    DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
 
-    if( link == NULL ) {
-        DBG_LEAVE( DbgInfo );
+    if (link == NULL) {
+        DBG_LEAVE(DbgInfo);
         return -ENODEV;
     }
 
-    DBG_TRACE( DbgInfo, "%s: Shutting down adapter.\n", dev->name );
-    wl_close( dev );
+    DBG_TRACE(DbgInfo, "%s: Shutting down adapter.\n", dev->name);
+    wl_close(dev);
 
     link->open--;
 
-    DBG_LEAVE( DbgInfo );
+    DBG_LEAVE(DbgInfo);
     return 0;
 } // wl_adapter_close
 /*============================================================================*/
@@ -496,19 +496,19 @@ static struct pcmcia_driver wlags49_driver = {
  *      -1 on error
  *
  ******************************************************************************/
-int wl_adapter_init_module( void )
+int wl_adapter_init_module(void)
 {
     int ret;
     /*------------------------------------------------------------------------*/
 
 
-    DBG_FUNC( "wl_adapter_init_module" );
-    DBG_ENTER( DbgInfo );
-    DBG_TRACE( DbgInfo, "wl_adapter_init_module() -- PCMCIA\n" );
+    DBG_FUNC("wl_adapter_init_module");
+    DBG_ENTER(DbgInfo);
+    DBG_TRACE(DbgInfo, "wl_adapter_init_module() -- PCMCIA\n");
 
     ret = pcmcia_register_driver(&wlags49_driver);
 
-    DBG_LEAVE( DbgInfo );
+    DBG_LEAVE(DbgInfo);
     return ret;
 } // wl_adapter_init_module
 /*============================================================================*/
@@ -531,16 +531,16 @@ int wl_adapter_init_module( void )
  *      N/A
  *
  ******************************************************************************/
-void wl_adapter_cleanup_module( void )
+void wl_adapter_cleanup_module(void)
 {
-    DBG_FUNC( "wl_adapter_cleanup_module" );
-    DBG_ENTER( DbgInfo );
-    DBG_TRACE( DbgInfo, "wl_adapter_cleanup_module() -- PCMCIA\n" );
+    DBG_FUNC("wl_adapter_cleanup_module");
+    DBG_ENTER(DbgInfo);
+    DBG_TRACE(DbgInfo, "wl_adapter_cleanup_module() -- PCMCIA\n");
 
 
     pcmcia_unregister_driver(&wlags49_driver);
 
-    DBG_LEAVE( DbgInfo );
+    DBG_LEAVE(DbgInfo);
     return;
 } // wl_adapter_cleanup_module
 /*============================================================================*/
@@ -565,16 +565,16 @@ void wl_adapter_cleanup_module( void )
  *      0 otherwise
  *
  ******************************************************************************/
-int wl_adapter_is_open( struct net_device *dev )
+int wl_adapter_is_open(struct net_device *dev)
 {
     struct wl_private *lp = wl_priv(dev);
     struct pcmcia_device *link = lp->link;
 
-    if(!pcmcia_dev_present(link)) {
+    if (!pcmcia_dev_present(link)) {
         return 0;
     }
 
-    return( link->open );
+    return(link->open);
 } // wl_adapter_is_open
 /*============================================================================*/
 
@@ -599,7 +599,7 @@ int wl_adapter_is_open( struct net_device *dev )
  *      a pointer to a string describing the error(s)
  *
  ******************************************************************************/
-const char* DbgEvent( int mask )
+const char* DbgEvent(int mask)
 {
     static char DbgBuffer[256];
     char *pBuf;
@@ -610,81 +610,81 @@ const char* DbgEvent( int mask )
     *pBuf   = '\0';
 
 
-    if( mask & CS_EVENT_WRITE_PROTECT )
-        strcat( pBuf, "WRITE_PROTECT " );
+    if (mask & CS_EVENT_WRITE_PROTECT)
+        strcat(pBuf, "WRITE_PROTECT ");
 
-    if(mask & CS_EVENT_CARD_LOCK)
-        strcat( pBuf, "CARD_LOCK " );
+    if (mask & CS_EVENT_CARD_LOCK)
+        strcat(pBuf, "CARD_LOCK ");
 
-    if(mask & CS_EVENT_CARD_INSERTION)
-        strcat( pBuf, "CARD_INSERTION " );
+    if (mask & CS_EVENT_CARD_INSERTION)
+        strcat(pBuf, "CARD_INSERTION ");
 
-    if(mask & CS_EVENT_CARD_REMOVAL)
-        strcat( pBuf, "CARD_REMOVAL " );
+    if (mask & CS_EVENT_CARD_REMOVAL)
+        strcat(pBuf, "CARD_REMOVAL ");
 
-    if(mask & CS_EVENT_BATTERY_DEAD)
-        strcat( pBuf, "BATTERY_DEAD " );
+    if (mask & CS_EVENT_BATTERY_DEAD)
+        strcat(pBuf, "BATTERY_DEAD ");
 
-    if(mask & CS_EVENT_BATTERY_LOW)
-        strcat( pBuf, "BATTERY_LOW " );
+    if (mask & CS_EVENT_BATTERY_LOW)
+        strcat(pBuf, "BATTERY_LOW ");
 
-    if(mask & CS_EVENT_READY_CHANGE)
-        strcat( pBuf, "READY_CHANGE " );
+    if (mask & CS_EVENT_READY_CHANGE)
+        strcat(pBuf, "READY_CHANGE ");
 
-    if(mask & CS_EVENT_CARD_DETECT)
-        strcat( pBuf, "CARD_DETECT " );
+    if (mask & CS_EVENT_CARD_DETECT)
+        strcat(pBuf, "CARD_DETECT ");
 
-    if(mask & CS_EVENT_RESET_REQUEST)
-        strcat( pBuf, "RESET_REQUEST " );
+    if (mask & CS_EVENT_RESET_REQUEST)
+        strcat(pBuf, "RESET_REQUEST ");
 
-    if(mask & CS_EVENT_RESET_PHYSICAL)
-        strcat( pBuf, "RESET_PHYSICAL " );
+    if (mask & CS_EVENT_RESET_PHYSICAL)
+        strcat(pBuf, "RESET_PHYSICAL ");
 
-    if(mask & CS_EVENT_CARD_RESET)
-        strcat( pBuf, "CARD_RESET " );
+    if (mask & CS_EVENT_CARD_RESET)
+        strcat(pBuf, "CARD_RESET ");
 
-    if(mask & CS_EVENT_REGISTRATION_COMPLETE)
-        strcat( pBuf, "REGISTRATION_COMPLETE " );
+    if (mask & CS_EVENT_REGISTRATION_COMPLETE)
+        strcat(pBuf, "REGISTRATION_COMPLETE ");
 
     // if(mask & CS_EVENT_RESET_COMPLETE)
     //     strcat( pBuf, "RESET_COMPLETE " );
 
-    if(mask & CS_EVENT_PM_SUSPEND)
-        strcat( pBuf, "PM_SUSPEND " );
+    if (mask & CS_EVENT_PM_SUSPEND)
+        strcat(pBuf, "PM_SUSPEND ");
 
-    if(mask & CS_EVENT_PM_RESUME)
-        strcat( pBuf, "PM_RESUME " );
+    if (mask & CS_EVENT_PM_RESUME)
+        strcat(pBuf, "PM_RESUME ");
 
-    if(mask & CS_EVENT_INSERTION_REQUEST)
-        strcat( pBuf, "INSERTION_REQUEST " );
+    if (mask & CS_EVENT_INSERTION_REQUEST)
+        strcat(pBuf, "INSERTION_REQUEST ");
 
-    if(mask & CS_EVENT_EJECTION_REQUEST)
-        strcat( pBuf, "EJECTION_REQUEST " );
+    if (mask & CS_EVENT_EJECTION_REQUEST)
+        strcat(pBuf, "EJECTION_REQUEST ");
 
-    if(mask & CS_EVENT_MTD_REQUEST)
-        strcat( pBuf, "MTD_REQUEST " );
+    if (mask & CS_EVENT_MTD_REQUEST)
+        strcat(pBuf, "MTD_REQUEST ");
 
-    if(mask & CS_EVENT_ERASE_COMPLETE)
-        strcat( pBuf, "ERASE_COMPLETE " );
+    if (mask & CS_EVENT_ERASE_COMPLETE)
+        strcat(pBuf, "ERASE_COMPLETE ");
 
-    if(mask & CS_EVENT_REQUEST_ATTENTION)
-        strcat( pBuf, "REQUEST_ATTENTION " );
+    if (mask & CS_EVENT_REQUEST_ATTENTION)
+        strcat(pBuf, "REQUEST_ATTENTION ");
 
-    if(mask & CS_EVENT_CB_DETECT)
-        strcat( pBuf, "CB_DETECT " );
+    if (mask & CS_EVENT_CB_DETECT)
+        strcat(pBuf, "CB_DETECT ");
 
-    if(mask & CS_EVENT_3VCARD)
-        strcat( pBuf, "3VCARD " );
+    if (mask & CS_EVENT_3VCARD)
+        strcat(pBuf, "3VCARD ");
 
-    if(mask & CS_EVENT_XVCARD)
-        strcat( pBuf, "XVCARD " );
+    if (mask & CS_EVENT_XVCARD)
+        strcat(pBuf, "XVCARD ");
 
 
-    if( *pBuf ) {
+    if (*pBuf) {
         pBuf[strlen(pBuf) - 1] = '\0';
     } else {
-        if( mask != 0x0 ) {
-            sprintf( pBuf, "<<0x%08x>>", mask );
+        if (mask != 0x0) {
+            sprintf(pBuf, "<<0x%08x>>", mask);
         }
     }
 
-- 
1.6.0.4

