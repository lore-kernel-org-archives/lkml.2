Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149Ab0GUFGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:06:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:33149 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762299Ab0GUE6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PCV6RtpCqUaSUjD/u9dXSrNE0W/0N/CLdGljHvzYcTun+DUiX023uZG6DekBlqi5Yo
         b648r9xc2JhPUuZr/cz/ERBbv9CK5XIa56hTn2RPRa2/EHGSiz9r0f4G1X/5su10/YFn
         C8UFtiYhSKp1JxCaidKYgAElBWky7Uu3ybGAA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 115/115]Documentation/SubmittingDrivers update web address.
Date: Tue, 20 Jul 2010 21:57:54 -0700
Message-Id: <1279688279-29683-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates abroken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/SubmittingDrivers |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/SubmittingDrivers b/Documentation/SubmittingDrivers
index 4947fd8..38d2aab 100644
--- a/Documentation/SubmittingDrivers
+++ b/Documentation/SubmittingDrivers
@@ -161,7 +161,7 @@ How to NOT write kernel driver by Arjan van de Ven:
 	http://www.fenrus.org/how-to-not-write-a-device-driver-paper.pdf
 
 Kernel Janitor:
-	http://janitor.kernelnewbies.org/
+	http://kernelnewbies.org/KernelJanitors
 
 GIT, Fast Version Control System:
 	http://git-scm.com/
-- 
1.7.1.rc1.21.gf3bd6

