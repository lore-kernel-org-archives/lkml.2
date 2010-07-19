Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966931Ab0GSVj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:39:29 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40077 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966895Ab0GSVi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:56 -0400
Message-Id: <20100719213855.185637111@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:43 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 25/25] GRU - update cbrstate definitions
References: <20100719213651.362618144@sgi.com>
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

