Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1KHQhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:37:48 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42059
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753803Ab1KHQg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:36:26 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 09/11] Staging: hv: storvsc: Upgrade the vmstor protocol version
Date: Tue,  8 Nov 2011 09:01:48 -0800
Message-Id: <1320771710-29139-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1320771710-29139-1-git-send-email-kys@microsoft.com>
References: <1320771677-29095-1-git-send-email-kys@microsoft.com>
 <1320771710-29139-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for supporting hot add/remove of scsi devices,
upgrade the vmstor protocol version.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 4cdb417..9153641 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -80,7 +80,7 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 /* V1 Beta                    0.1 */
 /* V1 RC < 2008/1/31          1.0 */
 /* V1 RC > 2008/1/31          2.0 */
-#define VMSTOR_PROTOCOL_VERSION_CURRENT VMSTOR_PROTOCOL_VERSION(2, 0)
+#define VMSTOR_PROTOCOL_VERSION_CURRENT VMSTOR_PROTOCOL_VERSION(4, 2)
 
 
 
@@ -106,7 +106,8 @@ enum vstor_packet_operation {
 	VSTOR_OPERATION_END_INITIALIZATION	= 8,
 	VSTOR_OPERATION_QUERY_PROTOCOL_VERSION	= 9,
 	VSTOR_OPERATION_QUERY_PROPERTIES	= 10,
-	VSTOR_OPERATION_MAXIMUM			= 10
+	VSTOR_OPERATION_ENUMERATE_BUS		= 11,
+	VSTOR_OPERATION_MAXIMUM			= 11
 };
 
 /*
-- 
1.7.4.1

