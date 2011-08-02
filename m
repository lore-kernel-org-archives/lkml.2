Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1HBRU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:20:57 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:55821 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1HBRUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:20:42 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH resend 2/2] zcache: module is GPL
Date: Tue,  2 Aug 2011 14:20:27 -0300
Message-Id: <1312305627-4837-2-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312305627-4837-1-git-send-email-cascardo@holoscopio.com>
References: <1312305627-4837-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids tainting the kernel as if a proprietary module was loaded.
The kernel will still be tainted because this is a staging driver.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/staging/zcache/zcache-main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 65a81a0..a58a03f 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -53,6 +53,9 @@
 
 #define MAX_CLIENTS 16
 #define LOCAL_CLIENT ((uint16_t)-1)
+
+MODULE_LICENSE("GPL");
+
 struct zcache_client {
 	struct tmem_pool *tmem_pools[MAX_POOLS_PER_CLIENT];
 	struct xv_pool *xvpool;
-- 
1.7.5.4

