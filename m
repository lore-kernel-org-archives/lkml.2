Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017Ab2JXOjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:39:06 -0400
Received: from dupo.coraid.com ([208.71.232.133]:61167 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934928Ab2JXOjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:39:03 -0400
X-Greylist: delayed 956 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2012 10:39:02 EDT
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH] Documentation/SubmittingPatches: implicit permission for public reports
To: rob@landley.net
Cc: linux-doc@vger.kernel.org, ecashin@coraid.com, dan.carpenter@oracle.com,
        kernel-janitors@vger.kernel.org, corbet@lwn.net,
        linux-kernel@vger.kernel.org
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 24 Oct 2012 10:22:02 -0400
Message-ID: <623a994357ba3348d5a4a0a2003b4dc0@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current text of SubmittingPatches recommends asking permission
before using "Reported-By:" even when the report was made to a
public forum.  This patch updates the text to better reflect the
current convention of including the tag when the report was public.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 Documentation/SubmittingPatches |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index c379a2a..d30b692 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -423,12 +423,12 @@ have been included in the discussion
 
 14) Using Reported-by:, Tested-by: and Reviewed-by:
 
-If this patch fixes a problem reported by somebody else, consider adding a
-Reported-by: tag to credit the reporter for their contribution.  Please
-note that this tag should not be added without the reporter's permission,
-especially if the problem was not reported in a public forum.  That said,
-if we diligently credit our bug reporters, they will, hopefully, be
-inspired to help us again in the future.
+If this patch fixes a problem reported by somebody else, consider
+adding a Reported-by: tag to credit the reporter for their
+contribution.  Please note that this tag should not be added without
+the reporter's permission unless the problem was reported in a public
+forum.  That said, if we diligently credit our bug reporters, they
+will, hopefully, be inspired to help us again in the future.
 
 A Tested-by: tag indicates that the patch has been successfully tested (in
 some environment) by the person named.  This tag informs maintainers that
-- 
1.7.1

