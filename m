Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1HRTCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:02:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44245 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1HRTCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:02:10 -0400
Date: Thu, 18 Aug 2011 20:02:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 19/91] um: get rid of sysdep/checksum.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7qz-0007YJ-92@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move those to sys-.../asm/checksum.h, kill include/asm/checksum.h

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/checksum.h                     |    6 ------
 arch/um/sys-i386/{shared/sysdep => asm}/checksum.h |    2 +-
 .../sys-x86_64/{shared/sysdep => asm}/checksum.h   |    0
 3 files changed, 1 insertions(+), 7 deletions(-)
 delete mode 100644 arch/um/include/asm/checksum.h
 rename arch/um/sys-i386/{shared/sysdep => asm}/checksum.h (99%)
 rename arch/um/sys-x86_64/{shared/sysdep => asm}/checksum.h (100%)

diff --git a/arch/um/include/asm/checksum.h b/arch/um/include/asm/checksum.h
deleted file mode 100644
index 5b50136..0000000
--- a/arch/um/include/asm/checksum.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_CHECKSUM_H
-#define __UM_CHECKSUM_H
-
-#include "sysdep/checksum.h"
-
-#endif
diff --git a/arch/um/sys-i386/shared/sysdep/checksum.h b/arch/um/sys-i386/asm/checksum.h
similarity index 99%
rename from arch/um/sys-i386/shared/sysdep/checksum.h
rename to arch/um/sys-i386/asm/checksum.h
index ed47445..caab742 100644
--- a/arch/um/sys-i386/shared/sysdep/checksum.h
+++ b/arch/um/sys-i386/asm/checksum.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Licensed under the GPL
  */
 
diff --git a/arch/um/sys-x86_64/shared/sysdep/checksum.h b/arch/um/sys-x86_64/asm/checksum.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/checksum.h
rename to arch/um/sys-x86_64/asm/checksum.h
-- 
1.7.2.5


