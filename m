Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab1IUVxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:53:04 -0400
Received: from jcz.nl ([213.196.18.5]:42541 "EHLO jcz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1IUVxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:53:01 -0400
From: Jaap Crezee <jaap@jcz.nl>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        hjanssen@microsoft.com, haiyangz@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, Jaap Crezee <jaap@jcz.nl>
Subject: [PATCH 2/3] Staging: hv: connection: fixed coding style issue
Date: Wed, 21 Sep 2011 23:53:06 +0200
Message-Id: <1316641986-9666-1-git-send-email-jaap@jcz.nl>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue, removed unneeded braces.

Signed-off-by: Jaap Crezee <jaap@jcz.nl>
---
 drivers/staging/hv/connection.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index e6b4039..0662a3b 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -223,11 +223,10 @@ static void process_chn_event(u32 relid)
 	 */
 	channel = relid2channel(relid);
 
-	if (channel) {
+	if (channel)
 		channel->onchannel_callback(channel->channel_callback_context);
-	} else {
+	else
 		pr_err("channel not found for relid - %u\n", relid);
-	}
 }
 
 /*
-- 
1.7.6.3

