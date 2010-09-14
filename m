Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0INEZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:25:10 -0400
Received: from mail.perches.com ([173.55.12.10]:2011 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab0INEYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:19 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH next 13/16] drivers/watchdog: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:59 -0700
Message-Id: <5ef1550b16f1ae6cb2f60c8c8ecc7b1df6dc27b5.1284435710.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/watchdog/machzwd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 2d118cf..edffe68 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -388,7 +388,7 @@ static struct notifier_block zf_notifier = {
 
 static void __init zf_show_action(int act)
 {
-	char *str[] = { "RESET", "SMI", "NMI", "SCI" };
+	static const char * const str[] = { "RESET", "SMI", "NMI", "SCI" };
 
 	printk(KERN_INFO PFX ": Watchdog using action = %s\n", str[act]);
 }
-- 
1.7.3.rc1

