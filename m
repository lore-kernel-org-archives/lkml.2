Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1EYVu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:50:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:1731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab1EYVu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:50:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,269,1304319600"; 
   d="scan'208";a="4880114"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, christophe.guerard@intel.com,
        james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com
Subject: [PATCH] pti_tty_install documentation mispelling.
Date: Wed, 25 May 2011 14:50:26 -0700
Message-Id: <1306360226-6971-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch tidies up the documentation for pti_tty_install()
function.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index e74e7d2..62b7ba4 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -445,9 +445,9 @@ static void pti_tty_driver_close(struct tty_struct *tty, struct file *filp)
 }
 
 /**
- * pti_tty_intstall()- Used to set up specific master-channels
- *		       to tty ports for organizational purposes when
- *		       tracing viewed from debuging tools.
+ * pti_tty_install()- Used to set up specific master-channels
+ *		      to tty ports for organizational purposes when
+ *		      tracing viewed from debuging tools.
  *
  * @driver: tty driver information.
  * @tty: tty struct containing pti information.
-- 
1.7.2.3

