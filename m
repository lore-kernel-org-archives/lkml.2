Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2KSF2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:28:53 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57271 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2KSF2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:28:51 -0500
X-Originating-IP: 217.70.178.146
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 02/58] drivers/tty/vt/vt_ioctl.c: Include <linux/suspend.h> for pm_set_vt_switch
Date: Sun, 18 Nov 2012 21:27:41 -0800
Message-Id: <1353302917-13995-3-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C files should include the header files that prototype their functions.
This keeps the types in sync, and eliminates warnings from GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/tty/vt/vt_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index b841f56..98ff173 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -25,6 +25,7 @@
 #include <linux/console.h>
 #include <linux/consolemap.h>
 #include <linux/signal.h>
+#include <linux/suspend.h>
 #include <linux/timex.h>
 
 #include <asm/io.h>
-- 
1.7.10.4

