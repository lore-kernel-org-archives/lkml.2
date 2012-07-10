Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2GJBgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:36:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57387 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab2GJBgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:36:02 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        klmckinney1@gmail.com, dan.carpenter@oracle.com, standby24x7@gmail.com,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 3/3] staging: bcm: Misc.c: Remove unused macros
Date: Mon,  9 Jul 2012 22:32:40 -0300
Message-Id: <1341883960-21635-4-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros were reported by forgotten-macros tool
(https://github.com/marcosps/forgotten_macros).

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/bcm/Misc.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index d7c662d..9a60d4c 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -1206,9 +1206,6 @@ static void convertEndian(B_UINT8 rwFlag, PUINT puiBuffer, UINT uiByteCount)
 	}
 }
 
-#define CACHE_ADDRESS_MASK 0x80000000
-#define UNCACHE_ADDRESS_MASK 0xa0000000
-
 int rdm(struct bcm_mini_adapter *Adapter, UINT uiAddress, PCHAR pucBuff, size_t sSize)
 {
 	return Adapter->interface_rdm(Adapter->pvInterfaceAdapter,
-- 
1.7.10.4

