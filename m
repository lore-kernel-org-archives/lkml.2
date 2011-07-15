Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1GORmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:42:49 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37307
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754148Ab1GORaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:06 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 074/117] Staging: hv: netvsc: Change the jump label Exit to exit
Date: Fri, 15 Jul 2011 10:47:02 -0700
Message-Id: <1310752065-27895-74-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the jump lable "Exit" to "exit".

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 79dfe78..6db48b9 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -537,7 +537,7 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 		 * We can't deallocate the request since we may still receive a
 		 * send completion for it.
 		 */
-		goto Exit;
+		goto exit;
 	} else {
 		set_complete = &request->response_msg.msg.set_complete;
 		status = set_complete->status;
@@ -546,7 +546,7 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 cleanup:
 	if (request)
 		put_rndis_request(dev, request);
-Exit:
+exit:
 	return ret;
 }
 
-- 
1.7.4.1

