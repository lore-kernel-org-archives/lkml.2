Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab1KJFQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:16:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933980Ab1KJDYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:24:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:06 2011
Message-Id: <20111109212706.895786542@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josh Boyer <jwboyer@redhat.com>
Subject: [065/262] Update email address for stable patch submission
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 5fa224295f0e0358c8bc0e5390702338df889def upstream.

The stable@kernel.org email address has been replaced with the
stable@vger.kernel.org mailing list.  Change the stable kernel rules to
reference the new list instead of the semi-defunct email alias.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/stable_kernel_rules.txt |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -24,10 +24,10 @@ Rules on what kind of patches are accept
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
@@ -35,10 +35,10 @@ Procedure for submitting patches to the
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


