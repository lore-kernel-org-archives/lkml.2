Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808Ab2HGDxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:53:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59647 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757295Ab2HGDiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:13 -0400
Message-Id: <20120807032756.884754501@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 05/70] stable: update references to older 2.6 versions for 3.x
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit 2584f5212d97b664be250ad5700a2d0fee31a10d upstream.

Also add information on where the respective trees are.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: Rob Landley <rob@landley.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/stable_kernel_rules.txt |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

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
 


