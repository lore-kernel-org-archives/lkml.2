Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab2DQKNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:13:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33851 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2DQKNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:13:23 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] devtmpfs: fix 'the the' typo
Date: Tue, 17 Apr 2012 12:13:18 +0200
Message-Id: <1334657598-16895-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/base/devtmpfs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 8493536..765c3a2 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -7,9 +7,9 @@
  * devtmpfs, a tmpfs-based filesystem is created. Every driver-core
  * device which requests a device node, will add a node in this
  * filesystem.
- * By default, all devices are named after the the name of the
- * device, owned by root and have a default mode of 0600. Subsystems
- * can overwrite the default setting if needed.
+ * By default, all devices are named after the name of the device,
+ * owned by root and have a default mode of 0600. Subsystems can
+ * overwrite the default setting if needed.
  */
 
 #include <linux/kernel.h>
-- 
1.7.8.3

