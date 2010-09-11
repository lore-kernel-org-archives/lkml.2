Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0IKQfr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 12:35:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61097 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0IKQfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 12:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=R4Av+7j8CrzZmeBgMQXHQe+g2DmWkmwSr8dzbxVNNOCdbcTgWlMrhLDzlJ1dexsvy7
         0Ty34YCxlLt9W2lhKWPphXhtct8hCdyqNAfUyG8KDwzTY1Kn9mTdCSxsdAQIaDlTyMqu
         CGuDsv7CorCItV//nrc5nGhxwsLXBwd3Idx5M=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/8]sound/oss/Kconfig Update broken web addresses.
Date: Sat, 11 Sep 2010 09:35:24 -0700
Message-Id: <1284222928-4150-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284222928-4150-1-git-send-email-justinmattock@gmail.com>
References: <1284222928-4150-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 sound/oss/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index a513651..bd6c171 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -36,7 +36,7 @@ config SOUND_MSNDCLAS
 	  See <file:Documentation/sound/oss/MultiSound> for important information
 	  about this driver.  Note that it has been discontinued, but the
 	  Voyetra Turtle Beach knowledge base entry for it is still available
-	  at <http://www.turtlebeach.com/site/kb_ftp/790.asp>.
+	  at <http://www.turtlebeach.com/>.
 
 comment "Compiled-in MSND Classic support requires firmware during compilation."
 	depends on SOUND_PRIME && SOUND_MSNDCLAS=y
@@ -98,7 +98,7 @@ config SOUND_MSNDPIN
 	  See <file:Documentation/sound/oss/MultiSound> for important information
 	  about this driver. Note that it has been discontinued, but the
 	  Voyetra Turtle Beach knowledge base entry for it is still available
-	  at <http://www.turtlebeach.com/site/kb_ftp/600.asp>.
+	  at <http://www.turtlebeach.com/>.
 
 comment "Compiled-in MSND Pinnacle support requires firmware during compilation."
 	depends on SOUND_PRIME && SOUND_MSNDPIN=y
-- 
1.7.2.1

