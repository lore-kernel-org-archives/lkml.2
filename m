Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2HOTwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:52:22 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63077 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab2HOTwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Josh Boyer <jwboyer@redhat.com>, <stable@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 080/165] Update email address for stable patch submission
Date: Wed, 15 Aug 2012 15:47:04 -0400
Message-ID: <1345060109-9187-81-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5fa224295f0e0358c8bc0e5390702338df889def upstream.

The stable@kernel.org email address has been replaced with the
stable@vger.kernel.org mailing list.  Change the stable kernel rules to
reference the new list instead of the semi-defunct email alias.

CC: <stable@kernel.org>
CC: <stable@vger.kernel.org>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/stable_kernel_rules.txt | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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
-- 
1.7.12.rc2

