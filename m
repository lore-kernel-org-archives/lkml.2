Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab0IBVIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:08:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60848 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab0IBVIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ICfdFK16NAhfmxXztuq9ES7NccSIW3H+JlUcRS4RITTh0znUc/cqV7tyAfKCEXmiMq
         6DEiJ0tabY/94V2jotCT8PQk2XmC88WnwmtLGYerd75BKvh11i6wTkX2OArEpK0LfoYI
         eOmL4ayUyAz/S7eLK7pFY7docrp6CFHl+kTMQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 26/91] arch/h8300/README Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:55 -0700
Message-Id: <1283461679-7851-11-git-send-email-justinmattock@gmail.com>
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
 arch/h8300/README |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/h8300/README b/arch/h8300/README
index 2fd6f6d..4254b15 100644
--- a/arch/h8300/README
+++ b/arch/h8300/README
@@ -11,18 +11,18 @@ H8/300H and H8S
 2.AE 3068/AE 3069
   more information 
   MICROTRONIQUE <http://www.microtronique.com/>
-  Akizuki Denshi Tsusho Ltd. <http://www.akizuki.ne.jp> (Japanese Only)
+  Akizuki Denshi Tsusho Ltd. <http://web.archive.org/web
+  /*/http://www.akizuki.ne.jp> (Japanese Only)
 
 3.H8MAX 
-  see http://ip-sol.jp/h8max/ (Japanese Only)
+  see http://strawberry-linux.com/h8/h8max.html (Japanese Only)
 
 4.EDOSK2674
-  see http://www.eu.renesas.com/products/mpumcu/tool/edk/support/edosk2674.html
-      http://www.azpower.com/H8-uClinux/
+  see http://www.renesas.eu/ 
+      http://h8-uclinux.sourceforge.net/ 
 
 * Toolchain Version
 gcc-3.1 or higher and patch
-see arch/h8300/tools_patch/README
 binutils-2.12 or higher
 gdb-5.2 or higher
 The environment that can compile a h8300-elf binary is necessary.
@@ -33,5 +33,4 @@ see http://www.uclinux.org/pub/uClinux/ports/h8/
 
 * A few words of thanks
 Porting to H8/300 serieses is support of Information-technology Promotion Agency, Japan.
-I thank support.
-and All developer/user.
+I thank support, and All developer/user.
-- 
1.7.2.1

