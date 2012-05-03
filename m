Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2ECJil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:38:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54265 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2ECJik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:38:40 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/2] ideapad: remove unused define and fix a typo
Date: Thu,  3 May 2012 17:38:35 +0800
Message-Id: <1336037915-9953-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336037865-9918-1-git-send-email-ike.pan@canonical.com>
References: <1336037865-9918-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After review the current ideapad-laptop, found an unused define and
a typo.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index ac902f7..00d82f1 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -194,7 +194,6 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
 /*
  * debugfs
  */
-#define DEBUGFS_EVENT_LEN (4096)
 static int debugfs_status_show(struct seq_file *s, void *data)
 {
 	unsigned long value;
@@ -315,7 +314,7 @@ static int __devinit ideapad_debugfs_init(struct ideapad_private *priv)
 	node = debugfs_create_file("status", S_IRUGO, priv->debug, NULL,
 				   &debugfs_status_fops);
 	if (!node) {
-		pr_err("failed to create event in debugfs");
+		pr_err("failed to create status in debugfs");
 		goto errout;
 	}
 
-- 
1.7.9.5

