Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2JPAkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:40:55 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35718 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2JPAkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:40:52 -0400
From: Chad Williamson <chad@dahc.us>
To: Alan Ott <alan@signal11.us>
Cc: linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH] samples: hidraw: add .gitignore file to ignore hid-example binary.
Date: Mon, 15 Oct 2012 19:39:08 -0500
Message-Id: <1350347948-7801-1-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.12.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git status should be clean following make allmodconfig && make. Add
a .gitignore file to the samples/hidraw directory to ingore the
hid-example binary produced there.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 samples/hidraw/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 samples/hidraw/.gitignore

diff --git a/samples/hidraw/.gitignore b/samples/hidraw/.gitignore
new file mode 100644
index 0000000..05e51a6
--- /dev/null
+++ b/samples/hidraw/.gitignore
@@ -0,0 +1 @@
+hid-example
-- 
1.7.12.3

