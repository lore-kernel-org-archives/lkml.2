Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab2JORY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:24:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34948 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2JORYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:24:54 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 05/14] staging: csr: Removed spaces between ( and arguments and ) on io.c
Date: Tue, 16 Oct 2012 02:24:24 +0900
Message-Id: <1350321868-2613-5-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found many coding style errors including spaces like this:
foo ( arg );
So, I fixed them as follows->   foo (arg);

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index 6f89556..ed34914 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -349,7 +349,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 		priv->totalInterfaceCount =0;
 
 		for(i=1;i<CSR_WIFI_NUM_INTERFACES;i++) {
-			if( !uf_alloc_netdevice_for_other_interfaces(priv,i) ) {
+			if(!uf_alloc_netdevice_for_other_interfaces(priv,i)) {
 				/* error occured while allocating the
 				 * net_device for interface[i].
 				 * The net_device are allocated for the
@@ -896,7 +896,7 @@ uf_read_proc(char *page, char **start, off_t offset, int count,
 		return 0;
 	}
 
-	p = kmalloc( UNIFI_DEBUG_TXT_BUFFER, GFP_KERNEL );
+	p = kmalloc(UNIFI_DEBUG_TXT_BUFFER, GFP_KERNEL);
 
 	orig_p = p;
 
@@ -953,24 +953,24 @@ uf_read_proc(char *page, char **start, off_t offset, int count,
 
 	written = UNIFI_DEBUG_TXT_BUFFER - remain;
 
-	if( offset >= written ) {
+	if(offset >= written) {
 		*eof = 1;
-		kfree( orig_p );
+		kfree(orig_p);
 		return(0);
 	}
 
-	if( offset + count > written ) {
+	if(offset + count > written) {
 		actual_amount_to_copy = written - offset;
 		*eof = 1;
 	} else {
 		actual_amount_to_copy = count;
 	}
 
-	memcpy( page, &(orig_p[offset]), actual_amount_to_copy );
+	memcpy(page, &(orig_p[offset]), actual_amount_to_copy);
 
-	kfree( orig_p );
+	kfree(orig_p);
 
-	return( actual_amount_to_copy );
+	return(actual_amount_to_copy);
 } /* uf_read_proc() */
 #endif
 
-- 
1.7.9.5

