Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2JIAjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 20:39:00 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54183 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2JIAi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:38:58 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>,
        Chad Reese <kreese@caviumnetworks.com>
Subject: [PATCH] RapidIO: Fix trivial comment error.
Date: Mon,  8 Oct 2012 17:38:32 -0700
Message-Id: <1349743112-27667-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chad Reese <kreese@caviumnetworks.com>

The resource index for the mailboxes was incorrect.

Signed-off-by: Chad Reese <kreese@caviumnetworks.com>
---
 include/linux/rio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rio.h b/include/linux/rio.h
index dc0c755..dd418d1 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -58,7 +58,7 @@
  *
  *	0	RapidIO inbound doorbells
  *	1	RapidIO inbound mailboxes
- *	1	RapidIO outbound mailboxes
+ *	2	RapidIO outbound mailboxes
  */
 #define RIO_DOORBELL_RESOURCE	0
 #define RIO_INB_MBOX_RESOURCE	1
-- 
1.7.11.4

