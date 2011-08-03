Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1HCOBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:01:11 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:35158 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1HCOAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:00:55 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: ngupta@vflare.org
Cc: dan.magenheimer@oracle.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        paul.gortmaker@windriver.com, linux-next@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] zcache: include module.h for MODULE_LICENSE
Date: Wed,  3 Aug 2011 11:00:40 -0300
Message-Id: <1312380040-28249-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20110803141641.00402b8e49dd68aa58c458ac@canb.auug.org.au>
References: <20110803141641.00402b8e49dd68aa58c458ac@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oncoming cleanup of module.h usage requires the explicit inclusion
of module.h when it was otherwise being included indirectly. Otherwise,
building zcache will fail.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/staging/zcache/zcache-main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index a58a03f..66469ac 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -19,6 +19,7 @@
  *   http://marc.info/?l=linux-mm&m=127811271605009
  */
 
+#include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/highmem.h>
 #include <linux/list.h>
-- 
1.7.5.4

