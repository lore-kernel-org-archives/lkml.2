Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2BPN4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:56:21 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51495 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab2BPN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:56:18 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Jonas Bonn <jonas@southpole.se>
Cc: Danny Kukawka <dkukawka@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/openrisc/include/asm/uaccess.h: included linux/thread_info.h twice
Date: Thu, 16 Feb 2012 14:56:14 +0100
Message-Id: <1329400574-32014-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329400578;13ee4191;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/openrisc/include/asm/uaccess.h: included 'linux/thread_info.h'
twice, remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/openrisc/include/asm/uaccess.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/openrisc/include/asm/uaccess.h b/arch/openrisc/include/asm/uaccess.h
index c310e45..f5abaa0 100644
--- a/arch/openrisc/include/asm/uaccess.h
+++ b/arch/openrisc/include/asm/uaccess.h
@@ -26,7 +26,6 @@
 #include <linux/thread_info.h>
 #include <linux/prefetch.h>
 #include <linux/string.h>
-#include <linux/thread_info.h>
 #include <asm/page.h>
 
 #define VERIFY_READ	0
-- 
1.7.8.3

