Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab1DJTry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 15:47:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58126 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab1DJTru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 15:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=XqhhPHR0aA9y/mRMfswnUj3IosomsBq64ySQAWFg+O2eT9eptnGccvrltX/cH/ZT2X
         iM/Nw16Gw4wzozziWPfH9l0BnN9ZLdN1axEffEQwWO3pImBFoMD1IixffPRZ0uumw/pp
         DiGuJdMAIQUac3vQ6E/cqD1NtWCrGZ7xzeY9M=
Message-ID: <4DA20964.6050806@gmail.com>
Date: Sun, 10 Apr 2011 21:47:48 +0200
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] RDMA/cxgb4: missing parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parens are missing: '|' has a higher presedence than '?'.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/infiniband/hw/cxgb4/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 70a5a3c..80cab20 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -214,7 +214,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		V_FW_RI_RES_WR_HOSTFCMODE(0) |	/* no host cidx updates */
 		V_FW_RI_RES_WR_CPRIO(0) |	/* don't keep in chip cache */
 		V_FW_RI_RES_WR_PCIECHN(0) |	/* set by uP at ri_init time */
-		t4_sq_onchip(&wq->sq) ? F_FW_RI_RES_WR_ONCHIP : 0 |
+		(t4_sq_onchip(&wq->sq) ? F_FW_RI_RES_WR_ONCHIP : 0) |
 		V_FW_RI_RES_WR_IQID(scq->cqid));
 	res->u.sqrq.dcaen_to_eqsize = cpu_to_be32(
 		V_FW_RI_RES_WR_DCAEN(0) |
