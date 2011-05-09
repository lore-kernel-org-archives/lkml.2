Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1EJIbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:31:19 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42711
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756060Ab1EJIav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 178/206] Staging: hv: Include the contents of rndis_filter.h
Date: Mon,  9 May 2011 14:57:40 -0700
Message-Id: <1304978288-22999-178-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index c1557ac..1eaac1a 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -1051,4 +1051,29 @@ struct rndis_message {
 #define RNDIS_MESSAGE_RAW_PTR_TO_MESSAGE_PTR(rndis_msg)	\
 	((void *) rndis_msg)
 
+
+#define __struct_bcount(x)
+
+
+#define RNDIS_HEADER_SIZE	(sizeof(struct rndis_message) - \
+				 sizeof(union rndis_message_container))
+
+#define NDIS_PACKET_TYPE_DIRECTED	0x00000001
+#define NDIS_PACKET_TYPE_MULTICAST	0x00000002
+#define NDIS_PACKET_TYPE_ALL_MULTICAST	0x00000004
+#define NDIS_PACKET_TYPE_BROADCAST	0x00000008
+#define NDIS_PACKET_TYPE_SOURCE_ROUTING	0x00000010
+#define NDIS_PACKET_TYPE_PROMISCUOUS	0x00000020
+#define NDIS_PACKET_TYPE_SMT		0x00000040
+#define NDIS_PACKET_TYPE_ALL_LOCAL	0x00000080
+#define NDIS_PACKET_TYPE_GROUP		0x00000100
+#define NDIS_PACKET_TYPE_ALL_FUNCTIONAL	0x00000200
+#define NDIS_PACKET_TYPE_FUNCTIONAL	0x00000400
+#define NDIS_PACKET_TYPE_MAC_FRAME	0x00000800
+
+
+/* Interface */
+
+extern int rndis_filter_init(struct netvsc_driver *driver);
+
 #endif /* _HYPERV_NET_H */
-- 
1.7.4.1

