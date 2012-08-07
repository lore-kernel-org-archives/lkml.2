Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab2HGXck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:32:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab2HGWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:30:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rob Landley <rob@landley.net>
Subject: [ 063/122] stable: update references to older 2.6 versions for 3.x
Date: Tue,  7 Aug 2012 15:25:51 -0700
Message-Id: <20120807221953.992001781@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit 2584f5212d97b664be250ad5700a2d0fee31a10d upstream.

Also add information on where the respective trees are.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: Rob Landley <rob@landley.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/stable_kernel_rules.txt |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -1,4 +1,4 @@
-Everything you ever wanted to know about Linux 2.6 -stable releases.
+Everything you ever wanted to know about Linux -stable releases.
 
 Rules on what kind of patches are accepted, and which ones are not, into the
 "-stable" tree:
@@ -42,10 +42,10 @@ Procedure for submitting patches to the
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
@@ -79,6 +79,15 @@ Review cycle:
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
 


