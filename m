Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab1G0EF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:05:28 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53273 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702Ab1G0EF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:05:26 -0400
X-Sasl-enc: We0Ytgrv25AMjV5zT50BqGlwtrRcPqFALv20CGX4DALl 1311739525
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: J Freyensee <james_p_freyensee@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/11] pti: pti_tty_install documentation mispelling.
Date: Tue, 26 Jul 2011 21:05:11 -0700
Message-Id: <1311739521-11014-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <20110726045707.GA2321@kroah.com>
References: <20110726045707.GA2321@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch tidies up the documentation for pti_tty_install()
function.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/pti.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index bb6f925..7281438 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -444,9 +444,9 @@ static void pti_tty_driver_close(struct tty_struct *tty, struct file *filp)
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
1.7.6

