Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab0IBVNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:13:54 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58129 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964Ab0IBVNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EBaSqWOlSzrozTx397NbTxqdidxI7Ri2eR9VxItDLOU8HB8qSYFKfR6poM2B0tG7Bt
         TNoPAhslvo04m2kcBx6oa2acNUA39PkNuCuSb22Wf6opdagMJo7ubpaLBym3qYF4ITsY
         UCDImdQrKk1CjKz/Sj6SIQruDc/Fxbo5Jyu8M=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 82/91] arch/mips/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:13:33 -0700
Message-Id: <1283462022-8024-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283462022-8024-1-git-send-email-justinmattock@gmail.com>
References: <1283462022-8024-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/mips/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3ad59dd..984b14e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2178,7 +2178,8 @@ config TC
 	  TurboChannel is a DEC (now Compaq (now HP)) bus for Alpha and MIPS
 	  processors.  Documentation on writing device drivers for TurboChannel
 	  is available at:
-	  <http://www.cs.arizona.edu/computer.help/policy/DIGITAL_unix/AA-PS3HD-TET1_html/TITLE.html>.
+	  <http://web.archive.org/web/*/http://www.cs.arizona.edu/computer.help/
+	  policy/DIGITAL_unix/AA-PS3HD-TET1_html/TITLE.html>.
 
 #config ACCESSBUS
 #	bool "Access.Bus support"
-- 
1.7.2.1

