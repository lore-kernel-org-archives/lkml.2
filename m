Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0IKQfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 12:35:18 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61097 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0IKQfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 12:35:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F8mIPhFbV6Ox0e+cNMYVujWSiXjEafiFubViQGeNFUUK4cxS0RS7y5Jx4UHQAD4CZd
         qW+Y8qUaoILLXXvqPyMPyIBtvwfepYbRsIk4c72yP9rOMA56zcKNxfYoiJ94n5HQjqVg
         Rs6bCKq9Ydk4l5WERG4oStprIf+o6UPJkl/oI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/8]sound/isa/Kconfig Update broken web addresses.
Date: Sat, 11 Sep 2010 09:35:22 -0700
Message-Id: <1284222928-4150-2-git-send-email-justinmattock@gmail.com>
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
 sound/isa/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index c6990c6..e12cc63 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -421,7 +421,7 @@ config SND_MSND_CLASSIC
 	  See <file:Documentation/sound/oss/MultiSound> for important information
 	  about this driver.  Note that it has been discontinued, but the
 	  Voyetra Turtle Beach knowledge base entry for it is still available
-	  at <http://www.turtlebeach.com/site/kb_ftp/790.asp>.
+	  at <http://www.turtlebeach.com/>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-msnd-classic.
-- 
1.7.2.1

