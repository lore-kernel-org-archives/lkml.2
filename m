Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab2GFVi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:38:58 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37386 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab2GFViw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:38:52 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
Cc: gregkh@linuxfoundation.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] Documentation: talk about "Cc: stable@vger.kernel.org"
Date: Fri,  6 Jul 2012 17:38:50 -0400
Message-Id: <1341610730-6277-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't remember whether the canonical marking is stable@kernel.org
or stable@vger.kernel.org, so I went looking, and discovered that it
wasn't mentioned in the kernel sources.  You can find mention of it in
Greg K-H's blog, but not everyone would necessarily find this blog
entry.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 Documentation/SubmittingPatches | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index c379a2a..d802ee2 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -418,7 +418,13 @@ If a person has had the opportunity to comment on a patch, but has not
 provided such comments, you may optionally add a "Cc:" tag to the patch.
 This is the only tag which might be added without an explicit action by the
 person it names.  This tag documents that potentially interested parties
-have been included in the discussion
+have been included in the discussion.
+
+If a patch is a bug fix which you believe should be backported to the
+stable kernel trees, you should add a simple "Cc: stable@vger.kernel.org>"
+marking in the Signed-off-by: area.  Once the patch hits Linus's tree,
+the patch will be automatically applied to the currently active stable
+trees if possible.  If it does not apply, you will be notified of that fact.
 
 
 14) Using Reported-by:, Tested-by: and Reviewed-by:
-- 
1.7.11.1.108.gb129051

