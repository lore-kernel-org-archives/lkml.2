Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2FKG41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:56:27 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:44468 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751183Ab2FKG40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:56:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAByW1U9bdWOb/2dsb2JhbABFtFyBB4MYgT4TiA+3KJEQA5UeiSOGWIJi
X-IronPort-AV: E=Sophos;i="4.77,387,1336341600"; 
   d="scan'208";a="525736499"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: ipack: remove pr_fmt definition.
Date: Mon, 11 Jun 2012 08:56:36 +0200
Message-Id: <1339397797-17399-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there is no pr_* function used here, pr_fmt is not needed.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index a1448e6..c1cd97a 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -9,8 +9,6 @@
  * Software Foundation; version 2 of the License.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
-- 
1.7.10

