Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab0DAUCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:02:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56335 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab0DAUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:02:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 1 Apr 2010 22:01:52 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] Documentation: -stable rules: upstream commit ID requirement
 reworded
To: Greg KH <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>
cc: David Miller <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <20100401153547.GB12944@suse.de>
Message-ID: <tkrat.768beea282d5d26b@s5r6.in-berlin.de>
References: <20100331215332.GH7671@dastard> <20100331224755.GA23284@suse.de>
 <20100401044048.GD16238@1wt.eu>
 <20100401.002622.179174704.davem@davemloft.net>
 <4BB4823F.7040408@s5r6.in-berlin.de> <20100401153547.GB12944@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a hard requirement to include the upstream commit ID in the
changelog of a -stable submission, not just a courtesy to the stable
team.  This concerns only mail submission though, which is no longer
the only way into stable.  (Also, fix a double "the".)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/stable_kernel_rules.txt |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: b/Documentation/stable_kernel_rules.txt
===================================================================
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -18,16 +18,15 @@ Rules on what kind of patches are accept
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
Stefan Richter
-=====-==-=- -=-- ----=
http://arcgraph.de/sr/

