Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0IMTs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:27 -0400
Received: from mail.perches.com ([173.55.12.10]:1866 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab0IMTsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:24 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 04/25] drivers/char: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:42 -0700
Message-Id: <a2936d6a439d294efa41dd567d29d0d301e844de.1284406638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/hvc_vio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hvc_vio.c b/drivers/char/hvc_vio.c
index 27370e9..5e2f52b 100644
--- a/drivers/char/hvc_vio.c
+++ b/drivers/char/hvc_vio.c
@@ -39,7 +39,7 @@
 
 #include "hvc_console.h"
 
-char hvc_driver_name[] = "hvc_console";
+static const char hvc_driver_name[] = "hvc_console";
 
 static struct vio_device_id hvc_driver_table[] __devinitdata = {
 	{"serial", "hvterm1"},
-- 
1.7.3.rc1

