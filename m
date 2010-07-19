Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966976Ab0GSVjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:39:51 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53695 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966884Ab0GSViz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:55 -0400
Message-Id: <20100719213854.560796807@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:39 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 21/25] GRU - delete unused gru statistics structure
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_delete_chiplet_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Delete unused structure that was left over from debugging.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru.h |   15 ---------------
 1 file changed, 15 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru.h	2010-06-09 08:11:45.375993599 -0500
+++ linux/drivers/misc/sgi-gru/gru.h	2010-06-09 08:11:48.856038221 -0500
@@ -39,21 +39,6 @@
 #endif
 
 /*
- * Structure for obtaining GRU resource information
- */
-struct gru_chiplet_info {
-	int	node;
-	int	chiplet;
-	int	blade;
-	int	total_dsr_bytes;
-	int	total_cbr;
-	int	total_user_dsr_bytes;
-	int	total_user_cbr;
-	int	free_user_dsr_bytes;
-	int	free_user_cbr;
-};
-
-/*
  * Statictics kept for each context.
  */
 struct gru_gseg_statistics {

