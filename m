Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2GLGOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:14:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49516 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2GLGOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:14:31 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sage Ahn <syahn@gctsemi.com>, Devendra Naga <devendra.aaru@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging/gdm72xx: coding style fixes gdm_qos.c
Date: Thu, 12 Jul 2012 11:59:22 +0545
Message-Id: <1342073662-12217-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

following warnings were fixed

drivers/staging/gdm72xx/gdm_qos.c:198: ERROR: "foo* bar" should be "foo *bar"
drivers/staging/gdm72xx/gdm_qos.c:198: ERROR: "foo* bar" should be "foo *bar"
drivers/staging/gdm72xx/gdm_qos.c:244: WARNING: quoted string split across lines

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/gdm72xx/gdm_qos.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index e7134e2..80bde05 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -195,7 +195,7 @@ static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *Stream, u8 *port)
 	return 0;
 }
 
-static u32 get_qos_index(struct nic *nic, u8* iph, u8* tcpudph)
+static u32 get_qos_index(struct nic *nic, u8 *iph, u8 *tcpudph)
 {
 	u32	IP_Ver, Header_Len, i;
 	struct qos_cb_s *qcb = &nic->qos;
@@ -240,8 +240,7 @@ static u32 extract_qos_list(struct nic *nic, struct list_head *head)
 					qcb->csr[i].QoSBufCount++;
 
 					if (!list_empty(&qcb->qos_list[i]))
-						wprintk("QoS Index(%d) "
-							"is piled!!\n", i);
+						wprintk("QoS Index(%d) is piled!!\n", i);
 				}
 			}
 		}
-- 
1.7.9.5

