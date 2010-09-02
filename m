Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0IBVIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:08:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60848 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab0IBVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LWIK3lfQe29E/4Hxwi6iwVkH0NLO73q0BSlUvUoQke3tIrRDnsy3rkDIgNr3d6lC9n
         ENGQ2JUul+UwaQxGWsD4dLzkDSj7OqGyez0a7LyEOZ8x9zWgLDvqgvz2h5n+/yhtkvIx
         4aqRTsx0lTKNsALIXWYE7wzkNzFE6pQYSaUQ4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 23/91] arch/arm/mm/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:52 -0700
Message-Id: <1283461679-7851-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
References: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 33c3f57..9516aaf 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -314,7 +314,7 @@ config CPU_SA110
 	  The Intel StrongARM(R) SA-110 is a 32-bit microprocessor and
 	  is available at five speeds ranging from 100 MHz to 233 MHz.
 	  More information is available at
-	  <http://developer.intel.com/design/strong/sa110.htm>.
+	  <http://developer.intel.com/design/>.
 
 	  Say Y if you want support for the SA-110 processor.
 	  Otherwise, say N.
-- 
1.7.2.1

