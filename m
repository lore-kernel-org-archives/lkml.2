Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0LaRiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:38:54 -0500
Received: from mail-pw0-f66.google.com ([209.85.160.66]:47976 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab0LaRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LUH+NFDNMHPDhRQkjey+pr1Xbof/9QlgBCTHWMVyK8HUaZ3PSk81X5EhYF7qCDqbyc
         uxA6sWLPfO7GKYBE8k1/zI3NURep+4yjnmn0TYK5N8O5xovcCaiKppUS9Ua18XdSQ4nE
         Q6ndEubZf4dcl8mSdbh+Czl5/lU2r7wwCZ/X0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/7] net/atl1c/atl1c.h Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:39:03 -0800
Message-Id: <1293817143-8013-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/atl1c/atl1c.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/atl1c/atl1c.h b/drivers/net/atl1c/atl1c.h
index 9ab5809..7cb375e 100644
--- a/drivers/net/atl1c/atl1c.h
+++ b/drivers/net/atl1c/atl1c.h
@@ -265,7 +265,7 @@ struct atl1c_recv_ret_status {
 	__le32	word3;
 };
 
-/* RFD desciptor */
+/* RFD descriptor */
 struct atl1c_rx_free_desc {
 	__le64	buffer_addr;
 };
@@ -531,7 +531,7 @@ struct atl1c_rfd_ring {
 	struct atl1c_buffer *buffer_info;
 };
 
-/* receive return desciptor (rrd) ring */
+/* receive return descriptor (rrd) ring */
 struct atl1c_rrd_ring {
 	void *desc;		/* descriptor ring virtual address */
 	dma_addr_t dma;		/* descriptor ring physical address */
-- 
1.6.5.2.180.gc5b3e

