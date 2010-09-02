Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0IBVJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:09:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab0IBVJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tlvppRxhPrULCAS101LBltIo6CQJV7SJXAT8/LOhEGMl+FY/CP/tvtFq5dm6Lem9zm
         4J9q7g4cWv5C88AvpWvgjkO9+7Plv8OMC3B7SG4oDN4GuT5ICKzjHPf5UhcxqhTbJk67
         xwYvd6f5uUYGkYzjYzYfu2niTtqd1iKL6nZUY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 34/91] arch/m32r/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:08:55 -0700
Message-Id: <1283461746-7905-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
References: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/m32r/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 836abbb..3867fd2 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -315,7 +315,7 @@ config SMP
 	  Management" code will be disabled if you say Y here.
 
 	  See also the SMP-HOWTO available at
-	  <http://www.linuxdoc.org/docs.html#howto>.
+	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
 	  If you don't know what to do here, say N.
 
-- 
1.7.2.1

