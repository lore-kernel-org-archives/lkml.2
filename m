Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0GUEwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:52:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0GUEvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Jo0Sqp+YZYaXilVkzYt4PG5SyQwOjrhomJu/JNZX3JGLT5NUrXN67O26xMbmtQjPU9
         /WqmxPXxAGno2yMPteuhKYNriWWgyrPNts+lAk2HIYZmRazqpZlr0Pm27KhGc2ga7FKv
         Y1A4alGTD8xrGCrE5CzhdgBKLxh+oEdFQel34=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 9/9]Documentation/arm/SA1100/Brutus update web address.
Date: Tue, 20 Jul 2010 21:50:55 -0700
Message-Id: <1279687861-29282-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a brooken web address to the comapny site
due to me unable to locate the original content. If anybody
knows where this is let me know and I'll resend an updated patch.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/arm/SA1100/Brutus |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/arm/SA1100/Brutus b/Documentation/arm/SA1100/Brutus
index b1cfd40..6a3aa95 100644
--- a/Documentation/arm/SA1100/Brutus
+++ b/Documentation/arm/SA1100/Brutus
@@ -1,7 +1,7 @@
 Brutus is an evaluation platform for the SA1100 manufactured by Intel.  
 For more details, see:
 
-http://developer.intel.com/design/strong/applnots/sa1100lx/getstart.htm
+http://developer.intel.com
 
 To compile for Brutus, you must issue the following commands:
 
-- 
1.7.1.rc1.21.gf3bd6

