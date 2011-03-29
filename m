Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab1C2WXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:23:34 -0400
Received: from mail.perches.com ([173.55.12.10]:4388 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab1C2WWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:41 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>,
        Herton Ronaldo Krzesinski <herton@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/23] topstar-laptop: Convert remaining printk to pr_info
Date: Tue, 29 Mar 2011 15:21:51 -0700
Message-Id: <a96da1fe175d7dc123f12433e30df14c60a67ce2.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be similar to all other uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/topstar-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
index 1d07d6d..4c20447 100644
--- a/drivers/platform/x86/topstar-laptop.c
+++ b/drivers/platform/x86/topstar-laptop.c
@@ -194,7 +194,7 @@ static int __init topstar_laptop_init(void)
 	if (ret < 0)
 		return ret;
 
-	printk(KERN_INFO "Topstar Laptop ACPI extras driver loaded\n");
+	pr_info("ACPI extras driver loaded\n");
 
 	return 0;
 }
-- 
1.7.4.2.g597a6.dirty

