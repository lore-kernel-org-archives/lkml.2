Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab2JKRE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:04:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51670 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab2JKRE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:04:26 -0400
From: Yang Bai <hamo.by@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Bai <hamo.by@gmail.com>
Subject: [PATCH][RESEND] ignore generated binary file scripts/basic/hash
Date: Fri, 12 Oct 2012 01:04:09 +0800
Message-Id: <1349975049-6317-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yang Bai <hamo.by@gmail.com>
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

