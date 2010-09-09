Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab0IIW2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:28:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58564 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab0IIW2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=q0GQ+tkKLhP9r2oIPwcl1gvsZnLuDry+pCMSpu4QKCgRmU3rDXsjig2ZsXm0S+X9VH
         F1FJU0o0yI5i8sAjlpf9NQYDrNJAIPfBXU0KzVbkkjaqHztxAcOOb1QuCE18y9fVBvlh
         K+hHUCzZjocMRGW3x5Arrrpwqap5kplsgN2Tg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 075/223]drivers/misc/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:28:36 -0700
Message-Id: <1284071316-7834-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071316-7834-1-git-send-email-justinmattock@gmail.com>
References: <1284071316-7834-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/misc/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0b591b6..c6744ea 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -112,8 +112,8 @@ config IBM_ASM
 
 	  WARNING: This software may not be supported or function
 	  correctly on your IBM server. Please consult the IBM ServerProven
-	  website <http://www.pc.ibm.com/ww/eserver/xseries/serverproven> for
-	  information on the specific driver level and support statement
+	  website <http://www-03.ibm.com/systems/info/x86servers/serverproven/compat/us/> 
+	  for information on the specific driver level and support statement
 	  for your IBM server.
 
 config PHANTOM
-- 
1.7.2.1

