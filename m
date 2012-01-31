Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2AaOYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:24:19 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:36670
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754424Ab2AaOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:24:17 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: samuel.ortiz@intel.com, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] iwmc3200wifi: Fix typo in trace.h
Date: Tue, 31 Jan 2012 23:23:45 +0900
Message-Id: <1328019825-2067-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "embeded" to "embedded" in
drivers/net/wireless/iwmc3200wifi/trace.h

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/iwmc3200wifi/trace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/trace.h b/drivers/net/wireless/iwmc3200wifi/trace.h
index abb4805..f5f7070 100644
--- a/drivers/net/wireless/iwmc3200wifi/trace.h
+++ b/drivers/net/wireless/iwmc3200wifi/trace.h
@@ -144,7 +144,7 @@ TRACE_EVENT(iwm_tx_packets,
 
 	TP_printk(
 		IWM_PR_FMT " Tx %spacket: eot %d, seq 0x%x, sta_color 0x%x, "
-		"ra_tid 0x%x, credit_group 0x%x, embeded_packets %d, %d bytes",
+		"ra_tid 0x%x, credit_group 0x%x, embedded_packets %d, %d bytes",
 		IWM_PR_ARG, !__entry->eot ? "concatenated " : "",
 		__entry->eot, __entry->seq, __entry->color, __entry->ra_tid,
 		__entry->credit_group, __entry->npkt, __entry->bytes
-- 
1.7.6.5

