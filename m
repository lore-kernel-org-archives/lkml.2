Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0DUVLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:11:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64510 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab0DUVLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:11:08 -0400
From: Cory Fields <FOSS@AtlasTechnologiesInc.com>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, jkosina@suse.cz
Subject: [PATCH] hid: Remove annoying non-error printk
Date: Wed, 21 Apr 2010 17:08:24 -0400
Message-Id: <1271884104-31884-1-git-send-email-FOSS@AtlasTechnologiesInc.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the only line printed on my "quiet" boot and seems completely
unnecessary.

Signed-off-by: Cory Fields <FOSS@AtlasTechnologiesInc.com>
---
 drivers/hid/hid-wacom.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index f7700cf..f947d83 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -277,7 +277,6 @@ static int __init wacom_init(void)
 	ret = hid_register_driver(&wacom_driver);
 	if (ret)
 		printk(KERN_ERR "can't register wacom driver\n");
-	printk(KERN_ERR "wacom driver registered\n");
 	return ret;
 }
 
-- 
1.7.0

