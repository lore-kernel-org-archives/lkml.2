Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0F2KRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:17:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab0F2KQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ASCN4FwVrorKY1VN31Ff9G5h6Ro8nG2lXNBd3ZRuGd7N9rO/r7vlxNn5ZXGXNjh4kr
         KBEIp8Y00oMMfX0zw5j1kKVqj/iMeyN+u8vdnJnlAujSOYWTOHeChRVnLXxGlz16w+wG
         fYHCFPsu7Zzr36U1z/hpmvsOLe/gaCyWZCIE0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       Henk de Groot <pe1dnn@amsat.org>,
       Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 23/25] wl_netdev: remove casts from void*
Date: Tue, 29 Jun 2010 14:16:25 +0400
Message-Id: <1277806586-31486-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/wlags49_h2/wl_netdev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 1aa61db..e2a7ad0 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -1905,8 +1905,8 @@ int wl_rx_dma( struct net_device *dev )
     DBG_FUNC("wl_rx")
     DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
 
-    if((( lp = (struct wl_private *)dev->priv ) != NULL ) &&
-          !( lp->flags & WVLAN2_UIL_BUSY )) {
+    if((( lp = dev->priv ) != NULL ) &&
+	!( lp->flags & WVLAN2_UIL_BUSY )) {
 
 #ifdef USE_RTS
         if( lp->useRTS == 1 ) {
-- 
1.7.0.4

