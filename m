Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652Ab2FGI1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:27:37 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:33020 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757513Ab2FGIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:25:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAPdk0E9bdWOb/2dsb2JhbABFhU6uToEHghkBBSMECwFGECUCJgICVwcSiA+mFJJlgSOKA4RtgRIDlR2JI4ZXgmKBVA
X-IronPort-AV: E=Sophos;i="4.75,730,1330902000"; 
   d="scan'208";a="923788923"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: gregkh@linuxfoundation.org, siglesias@igalia.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 3/9] Staging: ipack/bridges/tpci200: remove useless break in tpci200_slot_map_space()
Date: Thu,  7 Jun 2012 10:24:52 +0200
Message-Id: <1339057498-5256-3-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339057498-5256-1-git-send-email-magomez@igalia.com>
References: <1339057498-5256-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 3eaf387..216c6df 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -685,7 +685,6 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 			tpci200->number, dev->slot, space);
 		res = -EINVAL;
 		goto out_unlock;
-		break;
 	}
 
 	virt_addr_space->size = size_to_map;
-- 
1.7.9.5

