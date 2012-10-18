Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab2JRUkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:40:37 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:43694
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab2JRUkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:40:35 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net-next,1/1] hyperv: Remove unnecessary comments in rndis_filter_receive_data()
Date: Thu, 18 Oct 2012 14:00:52 -0700
Message-Id: <1350594052-15714-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checked with Windows networking team, there is only one RNDIS message
in each netvsc packet.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/net/hyperv/rndis_filter.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 928148c..7fdeb52 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -363,11 +363,6 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 
 	rndis_pkt = &msg->msg.pkt;
 
-	/*
-	 * FIXME: Handle multiple rndis pkt msgs that maybe enclosed in this
-	 * netvsc packet (ie TotalDataBufferLength != MessageLength)
-	 */
-
 	/* Remove the rndis header and pass it back up the stack */
 	data_offset = RNDIS_HEADER_SIZE + rndis_pkt->data_offset;
 
-- 
1.7.4.1

