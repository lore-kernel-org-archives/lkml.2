Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2JOJZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:25:20 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:46018 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab2JOJZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:25:18 -0400
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kbuild@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] unicore32: Use Kbuild infrastructure for kvm_para.h
Date: Mon, 15 Oct 2012 17:23:27 +0800
Message-Id: <1350293007-10237-1-git-send-email-gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the headers but kvm_para.h use the Kbuild infrastructure to
get to the asm-generic headers.

Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/uapi/asm/Kbuild     |    2 ++
 arch/unicore32/include/uapi/asm/kvm_para.h |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)
 delete mode 100644 arch/unicore32/include/uapi/asm/kvm_para.h

diff --git a/arch/unicore32/include/uapi/asm/Kbuild b/arch/unicore32/include/uapi/asm/Kbuild
index a44b1c4..0514d7a 100644
--- a/arch/unicore32/include/uapi/asm/Kbuild
+++ b/arch/unicore32/include/uapi/asm/Kbuild
@@ -6,3 +6,5 @@ header-y += kvm_para.h
 header-y += ptrace.h
 header-y += sigcontext.h
 header-y += unistd.h
+
+generic-y += kvm_para.h
diff --git a/arch/unicore32/include/uapi/asm/kvm_para.h b/arch/unicore32/include/uapi/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/unicore32/include/uapi/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
-- 
1.7.0.4

