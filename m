Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0HZNVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:21:49 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38431 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752144Ab0HZNV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:28 -0400
Message-Id: <20100826132126.900149667@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:20:02 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 25/25] GRU - update cbrstate definitions
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_update_cbrstate
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Update the CBRSTATE definitions to match what was actually
implemented in hardware.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gruhandles.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux/drivers/misc/sgi-gru/gruhandles.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.h	2010-07-19 10:25:57.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gruhandles.h	2010-07-19 13:03:39.982295167 -0500
@@ -478,15 +478,19 @@ enum gru_cbr_state {
 	CBRSTATE_INACTIVE,
 	CBRSTATE_IDLE,
 	CBRSTATE_PE_CHECK,
+	CBRSTATE_DSR_PRE,
 	CBRSTATE_QUEUED,
+	CBRSTATE_ISSUED,
 	CBRSTATE_WAIT_RESPONSE,
-	CBRSTATE_INTERRUPTED,
-	CBRSTATE_INTERRUPTED_MISS_FMM,
+	CBRSTATE_DSR_POST,
 	CBRSTATE_BUSY_INTERRUPT_MISS_FMM,
+	CBRSTATE_INTERRUPTED_MISS_FMM,
+	CBRSTATE_BUSY_INTERRUPT_MISS_UPM,
 	CBRSTATE_INTERRUPTED_MISS_UPM,
-	CBRSTATE_BUSY_INTERRUPTED_MISS_UPM,
-	CBRSTATE_REQUEST_ISSUE,
 	CBRSTATE_BUSY_INTERRUPT,
+	CBRSTATE_INTERRUPTED,
+	CBRSTATE_BCPY_CHECK,
+	CBRSTATE_WAIT_DONE,
 };
 
 /* CBE cbrexecstatus bits  - defined in gru_instructions.h*/

