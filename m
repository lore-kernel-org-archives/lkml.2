Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702Ab1KCBl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:41:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934672Ab1KCBlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:46 2011
Message-Id: <20111102222746.055891789@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josh Boyer <jwboyer@redhat.com>
Subject: [069/101] Update email address for stable patch submission
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 5fa224295f0e0358c8bc0e5390702338df889def upstream.

The stable@kernel.org email address has been replaced with the
stable@vger.kernel.org mailing list.  Change the stable kernel rules to
reference the new list instead of the semi-defunct email alias.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/stable_kernel_rules.txt |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -25,10 +25,10 @@ Rules on what kind of patches are accept
 Procedure for submitting patches to the -stable tree:
 
  - Send the patch, after verifying that it follows the above rules, to
-   stable@kernel.org.
+   stable@vger.kernel.org.
  - To have the patch automatically included in the stable tree, add the
    the tag
-     Cc: stable@kernel.org
+     Cc: stable@vger.kernel.org
    in the sign-off area. Once the patch is merged it will be applied to
    the stable tree without anything else needing to be done by the author
    or subsystem maintainer.
@@ -36,10 +36,10 @@ Procedure for submitting patches to the
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


