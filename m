Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1HRTCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:02:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44250 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1HRTCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:02:20 -0400
Date: Thu, 18 Aug 2011 20:02:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 20/91] um: take vm-flags.h to sys-*/asm
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7r9-0007Yf-9F@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/page.h                         |    2 +-
 arch/um/sys-i386/{shared/sysdep => asm}/vm-flags.h |    0
 .../sys-x86_64/{shared/sysdep => asm}/vm-flags.h   |    0
 3 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/um/sys-i386/{shared/sysdep => asm}/vm-flags.h (100%)
 rename arch/um/sys-x86_64/{shared/sysdep => asm}/vm-flags.h (100%)

diff --git a/arch/um/include/asm/page.h b/arch/um/include/asm/page.h
index 4cc9b6c..7cfc3ce 100644
--- a/arch/um/include/asm/page.h
+++ b/arch/um/include/asm/page.h
@@ -19,7 +19,7 @@
 struct page;
 
 #include <linux/types.h>
-#include <sysdep/vm-flags.h>
+#include <asm/vm-flags.h>
 
 /*
  * These are used to make use of C type-checking..
diff --git a/arch/um/sys-i386/shared/sysdep/vm-flags.h b/arch/um/sys-i386/asm/vm-flags.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/vm-flags.h
rename to arch/um/sys-i386/asm/vm-flags.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/vm-flags.h b/arch/um/sys-x86_64/asm/vm-flags.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/vm-flags.h
rename to arch/um/sys-x86_64/asm/vm-flags.h
-- 
1.7.2.5


