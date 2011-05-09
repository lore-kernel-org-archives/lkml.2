Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1EIVpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:45:52 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48802
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755102Ab1EIVo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:56 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 119/206] Staging: hv: Get rid of some dead code in connection.c
Date: Mon,  9 May 2011 14:56:41 -0700
Message-Id: <1304978288-22999-119-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid some commented code and dated comments.T

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/connection.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 3632bcc..dd62585 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -263,11 +263,6 @@ static void process_chn_event(u32 relid)
 
 	if (channel) {
 		vmbus_onchannel_event(channel);
-		/*
-		 * WorkQueueQueueWorkItem(channel->dataWorkQueue,
-		 *			  vmbus_onchannel_event,
-		 *			  (void*)channel);
-		 */
 	} else {
 		pr_err("channel not found for relid - %u\n", relid);
 	}
@@ -295,7 +290,10 @@ void vmbus_on_event(unsigned long data)
 				relid = (dword << 5) + bit;
 
 				if (relid == 0) {
-					/* special case - vmbus channel protocol msg */
+					/*
+					 * Special case - vmbus
+					 * channel protocol msg
+					 */
 					continue;
 				}
 				process_chn_event(relid);
-- 
1.7.4.1

