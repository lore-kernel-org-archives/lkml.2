Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1I0Bmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 21:42:36 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:35912 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1I0Bmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 21:42:35 -0400
From: Barry Song <Baohua.Song@csr.com>
To: <pavel@ucw.cz>, <rjw@sisk.pl>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] PM: HIBERNATION: fix typo
Date: Mon, 26 Sep 2011 18:41:39 -0700
Message-ID: <1317087699-13143-1-git-send-email-Baohua.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 kernel/power/hibernate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 8f7b1db..243f648 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -463,7 +463,7 @@ static int resume_target_kernel(bool platform_mode)
  * @platform_mode: If set, use platform driver to prepare for the transition.
  *
  * This routine must be called with pm_mutex held.  If it is successful, control
- * reappears in the restored target kernel in hibernation_snaphot().
+ * reappears in the restored target kernel in hibernation_snapshot().
  */
 int hibernation_restore(int platform_mode)
 {
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
