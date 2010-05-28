Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab0E1DMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 23:12:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14927 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab0E1DMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 23:12:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5995"; a="42664045"
X-IronPort-AV: E=Sophos;i="4.53,315,1272870000"; 
   d="scan'208";a="72693472"
From: Ron Shaffer <rshaffer@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Ron Shaffer <rshaffer@codeaurora.org>
Subject: [PATCH 1/3] Bluetooth: Remove extraneous white space
Date: Thu, 27 May 2010 23:12:04 -0400
Message-Id: <1275016326-15795-2-git-send-email-rshaffer@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1275016326-15795-1-git-send-email-rshaffer@codeaurora.org>
References: <1275016326-15795-1-git-send-email-rshaffer@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deleted extraneous white space from the end of several lines

Signed-off-by: Ron Shaffer <rshaffer@codeaurora.org>
---
 include/net/bluetooth/hci_core.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index e42f6ed..4a664e6 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1,4 +1,4 @@
-/* 
+/*
    BlueZ - Bluetooth protocol stack for Linux
    Copyright (C) 2000-2001 Qualcomm Incorporated
 
@@ -12,13 +12,13 @@
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS.
    IN NO EVENT SHALL THE COPYRIGHT HOLDER(S) AND AUTHOR(S) BE LIABLE FOR ANY
-   CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES 
-   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN 
-   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF 
+   CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES
+   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
-   ALL LIABILITY, INCLUDING LIABILITY FOR INFRINGEMENT OF ANY PATENTS, 
-   COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS 
+   ALL LIABILITY, INCLUDING LIABILITY FOR INFRINGEMENT OF ANY PATENTS,
+   COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS
    SOFTWARE IS DISCLAIMED.
 */
 
@@ -380,7 +380,7 @@ static inline void __hci_dev_put(struct hci_dev *d)
 }
 
 static inline void hci_dev_put(struct hci_dev *d)
-{ 
+{
 	__hci_dev_put(d);
 	module_put(d->owner);
 }
-- 
1.7.0.2

--
Ron Shaffer
Qualcomm Innocation Center, Inc.
Qualcomm Innocation Center, Inc. is a member of Code Aurora Forum
