Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0HZNV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:21:58 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38429 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752122Ab0HZNV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:28 -0400
Message-Id: <20100826132126.255219416@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:58 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 21/25] GRU - delete unused gru statistics structure
References: <20100826131937.108920216@sgi.com>
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

