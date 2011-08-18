Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1HRTHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:07:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47487 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab1HRTHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:07:20 -0400
Date: Thu, 18 Aug 2011 20:07:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 50/91] ... and don't include kern.h unless it's
 needed
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7vz-0007o5-N3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/drivers/ssl.c      |    1 -
 arch/um/drivers/ubd_kern.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index f1786e6..678e205 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -15,7 +15,6 @@
 #include "line.h"
 #include "ssl.h"
 #include "chan_kern.h"
-#include "kern.h"
 #include "init.h"
 #include "irq_user.h"
 #include "mconsole_kern.h"
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 620f5b7..0136be1 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -46,7 +46,6 @@
 #include "asm/tlbflush.h"
 #include "mem_user.h"
 #include "kern_util.h"
-#include "kern.h"
 #include "mconsole_kern.h"
 #include "init.h"
 #include "irq_user.h"
-- 
1.7.2.5


