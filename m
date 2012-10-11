Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2JKQ70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:59:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56024 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab2JKQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:59:24 -0400
From: Yang Bai <hamo.by@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Bai <hamo.by@gmail.com>
Subject: [PATCH] ignore generated binary file scripts/basic/hash
Date: Fri, 12 Oct 2012 00:58:13 +0800
Message-Id: <1349974693-5923-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 scripts/basic/.gitignore |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/basic/.gitignore b/scripts/basic/.gitignore
index a776371..b372870 100644
--- a/scripts/basic/.gitignore
+++ b/scripts/basic/.gitignore
@@ -1 +1,2 @@
 fixdep
+hash
-- 
1.7.10.4

