Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab0IBVHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:07:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60848 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab0IBVHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rZLuso3XSwScCXaH+o6XczlMRTv2HXBqq/f9D+z5STB6sK+WLU2m6cl7XEWCz3Dbxd
         NqnLOxOTqs0FF9YdMYZgzomGzE1LByQt3YyXM4sR6fP2WLWKLIsXFCsqVK9saDZDLh45
         yj2qb+JW+pM+KHVLW7t5dY5RnSKuUyqrdoABs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 16/91] arch/arm/mach-footbridge/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:45 -0700
Message-Id: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mach-footbridge/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index bdd2579..81d66fb 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -29,7 +29,8 @@ config ARCH_PERSONAL_SERVER
 	  There are no product plans beyond the current research
 	  prototypes at this time.  Information is available at:
 
-	  <http://www.crl.hpl.hp.com/projects/personalserver/>
+	  <http://web.archive.org/web/*/http://www.crl.hpl.hp.com
+	  /projects/personalserver/>
 
 	  If you have any questions or comments about the  Compaq Personal
 	  Server, send e-mail to <skiff@crl.dec.com>.
-- 
1.7.2.1

