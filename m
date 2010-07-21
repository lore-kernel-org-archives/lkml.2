Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab0GUFBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:01:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44627 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933356Ab0GUE7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RX5W6cvVPYBkK12SQhNX/3RQyRwubIg0ySIz0Bjnm7mivffcXeuAXi4Vt/N4yVsF7Q
         0wF8NBkFB8DcK5nOg7SBMqty8LcY4vJI4fioNpbZx5aDznNPpPAceLDaFIxGt6ZOIxbo
         1F7EOnO607nSUazCQHmQ3EBceR5w6/zQsJwvc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 139/139]Documentation/zh_CN/SubmittingPatches update web address.
Date: Tue, 20 Jul 2010 21:58:56 -0700
Message-Id: <1279688336-29735-19-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/zh_CN/SubmittingPatches |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
index 985c92e..9a1a6e1 100644
--- a/Documentation/zh_CN/SubmittingPatches
+++ b/Documentation/zh_CN/SubmittingPatches
@@ -83,7 +83,7 @@ Quilt:
 http://savannah.nongnu.org/projects/quilt
 
 Andrew Morton 的补丁脚本:
-http://www.zip.com.au/~akpm/linux/patches/
+http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
 作为这些脚本的替代，quilt 是值得推荐的补丁管理工具(看上面的链接)。
 
 2)描述你的改动。
@@ -166,7 +166,7 @@ MAITAINERS 文件里的）发送一个手册页（man-pages）补丁，或者至
   人拷贝，只要它是琐碎的）
   任何文件的作者/维护者对该文件的改动（例如 patch monkey 在重传模式下）
 
-URL: <http://www.kernel.org/pub/linux/kernel/people/bunk/trivial/>
+EMAIL: trivial@kernel.org
 
 (译注，关于“琐碎补丁”的一些说明：因为原文的这一部分写得比较简单，所以不得不
 违例写一下译注。"trivial"这个英文单词的本意是“琐碎的，不重要的。”但是在这里
@@ -394,7 +394,7 @@ Static inline 函数相比宏来说，是好得多的选择。Static inline 函
 ----------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt>
+  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
-- 
1.7.1.rc1.21.gf3bd6

