Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0HQE0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:26:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34991 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0HQE0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:26:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=wG5Lf1Q5CxuJ+4majgNzTnPM8CmCl9tqlh2EcUij2idx3GzZMsW+s0zW4kLC2jrhO/
         RJWr9S+u82aMvmJsLdBfu+PWpJFBV5Ouk1pFtJnspHCQzIlecqsK/Z+t2ZsSWMoxlXd4
         Xj5ql4HzgV/VlByE8GqAsGO4XttnVVt72VH4s=
From: =?UTF-8?q?=C3=86var=20Arnfj=C3=B6r=C3=B0=20Bjarmason?= 
	<avar@v.nix.is>
To: torvalds@linux-foundation.org
Cc: David Woodhouse <dwmw2@tylersburg.infradead.org>,
        Linux is full of bugs <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?=C3=86var=20Arnfj=C3=B6r=C3=B0=20Bjarmason?= 
	<avar@v.nix.is>
Subject: [PATCH] .gitignore: Ignore generated files in lib/raid6
Date: Tue, 17 Aug 2010 04:25:31 +0000
Message-Id: <1282019131-30813-1-git-send-email-avar@v.nix.is>
X-Mailer: git-send-email 1.7.2.1.389.gc3d0b
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Makefile in lib/raid6 will generate these files, and the clean
target will remove them, but they weren't being ignored by git.

Signed-off-by: Ævar Arnfjörð Bjarmason <avar@v.nix.is>
---
 lib/raid6/.gitignore |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 lib/raid6/.gitignore

diff --git a/lib/raid6/.gitignore b/lib/raid6/.gitignore
new file mode 100644
index 0000000..ce56377
--- /dev/null
+++ b/lib/raid6/.gitignore
@@ -0,0 +1,16 @@
+#
+# Generated files
+#
+
+altivec1.c
+altivec2.c
+altivec4.c
+altivec8.c
+int1.c
+int16.c
+int2.c
+int32.c
+int4.c
+int8.c
+mktables
+tables.c
-- 
1.7.2.1.389.gc3d0b

