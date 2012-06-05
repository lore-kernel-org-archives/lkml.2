Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2FEPRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:17:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:63001 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2FEPQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:16:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] stable: update references to older 2.6 versions for 3.x
Date: Tue,  5 Jun 2012 11:15:50 -0400
Message-Id: <1338909350-1271-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add information on where the respective trees are.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index f0ab5cf..2edf833 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -1,4 +1,4 @@
-Everything you ever wanted to know about Linux 2.6 -stable releases.
+Everything you ever wanted to know about Linux -stable releases.
 
 Rules on what kind of patches are accepted, and which ones are not, into the
 "-stable" tree:
@@ -36,10 +36,10 @@ Procedure for submitting patches to the -stable tree:
    cherry-picked than this can be specified in the following format in
    the sign-off area:
 
-     Cc: <stable@vger.kernel.org> # .32.x: a1f84a3: sched: Check for idle
-     Cc: <stable@vger.kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
-     Cc: <stable@vger.kernel.org> # .32.x: fd21073: sched: Fix affinity logic
-     Cc: <stable@vger.kernel.org> # .32.x
+     Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched: Check for idle
+     Cc: <stable@vger.kernel.org> # 3.3.x: 1b9508f: sched: Rate-limit newidle
+     Cc: <stable@vger.kernel.org> # 3.3.x: fd21073: sched: Fix affinity logic
+     Cc: <stable@vger.kernel.org> # 3.3.x
     Signed-off-by: Ingo Molnar <mingo@elte.hu>
 
    The tag sequence has the meaning of:
@@ -73,6 +73,15 @@ Review cycle:
    security kernel team, and not go through the normal review cycle.
    Contact the kernel security team for more details on this procedure.
 
+Trees:
+
+ - The queues of patches, for both completed versions and in progress
+   versions can be found at:
+	http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git
+ - The finalized and tagged releases of all stable kernels can be found
+   in separate branches per version at:
+	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git
+
 
 Review committee:
 
-- 
1.7.9.1

