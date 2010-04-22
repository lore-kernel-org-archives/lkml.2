Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0DVWkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:40:23 -0400
Received: from kroah.org ([198.145.64.141]:42675 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab0DVWkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:40:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] Documentation: -stable rules: upstream commit ID requirement reworded
Date: Thu, 22 Apr 2010 15:40:14 -0700
Message-Id: <1271976016-3584-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100422222928.GA3268@kroah.com>
References: <20100422222928.GA3268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

It is a hard requirement to include the upstream commit ID in the
changelog of a -stable submission, not just a courtesy to the stable
team.  This concerns only mail submission though, which is no longer
the only way into stable.  (Also, fix a double "the".)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/stable_kernel_rules.txt |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index 5effa5b..e213f45 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -18,16 +18,15 @@ Rules on what kind of patches are accepted, and which ones are not, into the
  - It cannot contain any "trivial" fixes in it (spelling changes,
    whitespace cleanups, etc).
  - It must follow the Documentation/SubmittingPatches rules.
- - It or an equivalent fix must already exist in Linus' tree.  Quote the
-   respective commit ID in Linus' tree in your patch submission to -stable.
+ - It or an equivalent fix must already exist in Linus' tree (upstream).
 
 
 Procedure for submitting patches to the -stable tree:
 
  - Send the patch, after verifying that it follows the above rules, to
-   stable@kernel.org.
- - To have the patch automatically included in the stable tree, add the
-   the tag
+   stable@kernel.org.  You must note the upstream commit ID in the changelog
+   of your submission.
+ - To have the patch automatically included in the stable tree, add the tag
      Cc: stable@kernel.org
    in the sign-off area. Once the patch is merged it will be applied to
    the stable tree without anything else needing to be done by the author
-- 
1.7.0.4

