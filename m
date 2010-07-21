Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab0GUFBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:01:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58117 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762278Ab0GUE7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lCPuBmOW8f4n4OLGZQAJkAx8BTcZTBKBSQXw8fjio9rc3Cvc1FyBKVxdFAXZnyYPOO
         8wEqva9vgyURmtEWZ+/l9VXJ4YC15uEMkjNm+AfkUQ7jQphrph6pCWl6EKQ+zS8hSvT2
         YWDCr30Sic4Dcp4js1498mY4dK0hLL+c5AbS0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 137/137]Documentation/zh_CN/HOWTO update web address.
Date: Tue, 20 Jul 2010 21:58:54 -0700
Message-Id: <1279688336-29735-17-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/zh_CN/HOWTO |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
index 3d80e8a..05169e5 100644
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -112,7 +112,7 @@ Linux内核代码中包含有大量的文档。这些文档对于学习如何与
 
     其他关于如何正确地生成补丁的优秀文档包括：
     "The Perfect Patch"
-        http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+        http://userweb.kernel.org/~akpm/stuff/tpp.txt
     "Linux kernel patch submission format"
         http://linux.yyz.us/patch-format.html
 
@@ -168,7 +168,7 @@ Linux内核代码中包含有大量的文档。这些文档对于学习如何与
 
 如果你想加入内核开发社区并协助完成一些任务，却找不到从哪里开始，可以访问
 “Linux内核房管员”计划：
-	http://janitor.kernelnewbies.org/
+	http://kernelnewbies.org/KernelJanitors
 这是极佳的起点。它提供一个相对简单的任务列表，列出内核代码中需要被重新
 整理或者改正的地方。通过和负责这个计划的开发者们一同工作，你会学到将补丁
 集成进内核的基本原理。如果还没有决定下一步要做什么的话，你还可能会得到方
@@ -515,7 +515,7 @@ Linux内核社区并不喜欢一下接收大段的代码。修改需要被恰当
 
 想了解它具体应该看起来像什么，请查阅以下文档中的“ChangeLog”章节：
   “The Perfect Patch”
-      http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+      http://userweb.kernel.org/~akpm/stuff/tpp.txt
 
 
 这些事情有时候做起来很难。要在任何方面都做到完美可能需要好几年时间。这是
@@ -525,7 +525,7 @@ Linux内核社区并不喜欢一下接收大段的代码。修改需要被恰当
 
 ---------------
 感谢Paolo Ciarrocchi允许“开发流程”部分基于他所写的文章
-(http://linux.tar.bz/articles/2.6-development_process)，感谢Randy
+(http://www.kerneltravel.net/newbie/2.6-development_process)，感谢Randy
 Dunlap和Gerrit Huizenga完善了应该说和不该说的列表。感谢Pat Mochel, Hanna
 Linder, Randy Dunlap, Kay Sievers, Vojtech Pavlik, Jan Kara, Josh Boyer,
 Kees Cook, Andrew Morton, Andi Kleen, Vadim Lobanov, Jesper Juhl, Adrian
-- 
1.7.1.rc1.21.gf3bd6

