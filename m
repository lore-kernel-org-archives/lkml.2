Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1HLB56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 21:57:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1HLB54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 21:57:56 -0400
Subject: [net-next RFC PATCH 3/7] tuntap: introduce multiqueue related flags
To: mst@redhat.com, netdev@vger.kernel.org, jasowang@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Cc: krkumar2@in.ibm.com, rusty@rustcorp.com.au, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mirq-linux@rere.qmqm.pl
Date: Fri, 12 Aug 2011 09:55:10 +0800
Message-ID: <20110812015510.31613.18945.stgit@intel-e5620-16-2.englab.nay.redhat.com>
In-Reply-To: <20110812015221.31613.95001.stgit@intel-e5620-16-2.englab.nay.redhat.com>
References: <20110812015221.31613.95001.stgit@intel-e5620-16-2.englab.nay.redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/if_tun.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 06b1829..c92a291 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
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

