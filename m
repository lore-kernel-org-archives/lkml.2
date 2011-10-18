Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab1JRBQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab1JRBQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:16:46 -0400
Date: Mon, 17 Oct 2011 21:16:39 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] Update email address for stable patch submission
Message-ID: <20111018011638.GQ1165@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stable@kernel.org email address has been replaced with the
stable@vger.kernel.org mailing list.  Change the stable kernel rules to
reference the new list instead of the semi-defunct email alias.

CC: <stable@kernel.org>
CC: <stable@vger.kernel.org>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>

---

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index e213f45..21fd05c 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -24,10 +24,10 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 Procedure for submitting patches to the -stable tree:
 
  - Send the patch, after verifying that it follows the above rules, to
-   stable@kernel.org.  You must note the upstream commit ID in the changelog
-   of your submission.
+   stable@vger.kernel.org.  You must note the upstream commit ID in the
+   changelog of your submission.
  - To have the patch automatically included in the stable tree, add the tag
-     Cc: stable@kernel.org
+     Cc: stable@vger.kernel.org
    in the sign-off area. Once the patch is merged it will be applied to
    the stable tree without anything else needing to be done by the author
    or subsystem maintainer.
@@ -35,10 +35,10 @@ Procedure for submitting patches to the -stable tree:
    cherry-picked than this can be specified in the following format in
    the sign-off area:
 
-     Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for idle
-     Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
-     Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
-     Cc: <stable@kernel.org> # .32.x
+     Cc: <stable@vger.kernel.org> # .32.x: a1f84a3: sched: Check for idle
+     Cc: <stable@vger.kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
+     Cc: <stable@vger.kernel.org> # .32.x: fd21073: sched: Fix affinity logic
+     Cc: <stable@vger.kernel.org> # .32.x
     Signed-off-by: Ingo Molnar <mingo@elte.hu>
 
    The tag sequence has the meaning of:
