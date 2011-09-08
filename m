Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab1IHOHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:07:19 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:44629
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933078Ab1IHODP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:15 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 21/25] Staging: hv: vmbus: Get rid of the ext field in struct hv_device
Date: Thu,  8 Sep 2011 07:24:32 -0700
Message-Id: <1315491876-9554-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have eliminated all uses of the ext field in struct hv_device,
get rid of the ext field.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index 2879750..7ba274f 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -827,9 +827,6 @@ struct hv_device {
 	struct device device;
 
 	struct vmbus_channel *channel;
-
-	/* Device extension; */
-	void *ext;
 };
 
 
-- 
1.7.4.1

