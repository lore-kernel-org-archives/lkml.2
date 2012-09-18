Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2IRRLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:11:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50544 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2IRRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:11:03 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: jesse@nicira.com
Cc: davem@davemloft.net, dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 2/3] net/openvswitch/vport.c: Remove unecessary semicolon
Date: Tue, 18 Sep 2012 19:10:44 +0200
Message-Id: <1347988245-31413-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347988245-31413-1-git-send-email-peter.senna@gmail.com>
References: <1347988245-31413-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 net/openvswitch/vport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 9055dd6..03779e8 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -398,7 +398,7 @@ void ovs_vport_record_error(struct vport *vport, enum vport_err_type err_type)
 	case VPORT_E_TX_ERROR:
 		vport->err_stats.tx_errors++;
 		break;
-	};
+	}
 
 	spin_unlock(&vport->stats_lock);
 }
-- 
1.7.11.4

