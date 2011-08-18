Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1HRTCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:02:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44242 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1HRTCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:02:00 -0400
Date: Thu, 18 Aug 2011 20:01:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 18/91] um: trim unused junk from user.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7qp-0007Y9-8p@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/user.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/shared/user.h b/arch/um/include/shared/user.h
index 2d46f63..58c0581 100644
--- a/arch/um/include/shared/user.h
+++ b/arch/um/include/shared/user.h
@@ -36,9 +36,7 @@ static inline int printk(const char *fmt, ...)
 }
 #endif
 
-extern void schedule(void);
 extern int in_aton(char *str);
-extern int open_gdb_chan(void);
 extern size_t strlcpy(char *, const char *, size_t);
 extern size_t strlcat(char *, const char *, size_t);
 
-- 
1.7.2.5


