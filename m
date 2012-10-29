Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab2J2GXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:23:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2J2GXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:23:49 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: maxk@qualcomm.com, edumazet@google.com, krkumar2@in.ibm.com,
        ernesto.martin@viasat.com, haixiao@juniper.net,
        Jason Wang <jasowang@redhat.com>
Subject: [net-next resend v4 4/7] tuntap: introduce multiqueue flags
Date: Mon, 29 Oct 2012 14:15:48 +0800
Message-Id: <1351491351-11477-5-git-send-email-jasowang@redhat.com>
In-Reply-To: <1351491351-11477-1-git-send-email-jasowang@redhat.com>
References: <1351491351-11477-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add flags to be used by creating multiqueue tuntap device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/uapi/linux/if_tun.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 25a585c..8ef3a87 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -34,6 +34,7 @@
 #define TUN_ONE_QUEUE	0x0080
 #define TUN_PERSIST 	0x0100	
 #define TUN_VNET_HDR 	0x0200
+#define TUN_TAP_MQ      0x0400
 
 /* Ioctl defines */
 #define TUNSETNOCSUM  _IOW('T', 200, int) 
@@ -61,6 +62,7 @@
 #define IFF_ONE_QUEUE	0x2000
 #define IFF_VNET_HDR	0x4000
 #define IFF_TUN_EXCL	0x8000
+#define IFF_MULTI_QUEUE 0x0100
 
 /* Features for GSO (TUNSETOFFLOAD). */
 #define TUN_F_CSUM	0x01	/* You can hand me unchecksummed packets. */
-- 
1.7.1

