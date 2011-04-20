Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1DTUKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:10:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58242 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab1DTUKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:10:22 -0400
Subject: Re: [PATCH V3 2/8] Add a new zerocopy device flag
From: Shirley Ma <mashirle@us.ibm.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303328906.2823.24.camel@bwh-desktop>
References: <1303328216.19336.18.camel@localhost.localdomain>
	 <1303328648.19336.24.camel@localhost.localdomain>
	 <1303328906.2823.24.camel@bwh-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 13:09:33 -0700
Message-ID: <1303330173.19336.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmit this patch with the new bit.

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 include/linux/netdevice.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0249fe7..0998d3d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1067,6 +1067,9 @@ struct net_device {
 #define NETIF_F_RXHASH		(1 << 28) /* Receive hashing offload */
 #define NETIF_F_RXCSUM		(1 << 29) /* Receive checksumming offload */
 
+/* Bit 30 is for device to map userspace buffers -- zerocopy */
+#define NETIF_F_ZEROCOPY	(1 << 30)
+
 	/* Segmentation offload features */
 #define NETIF_F_GSO_SHIFT	16
 #define NETIF_F_GSO_MASK	0x00ff0000


