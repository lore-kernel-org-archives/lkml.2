Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab0IIWqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:46:05 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46296 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350Ab0IIWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:45:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DKAmTRtNm23MlultGqsq5g/8mK63OybmP88I2FsKeV7YCwapMRKfXDeK3h8fT9KH/a
         4Fj8Szn6+b8bHd0Szy0nIoP1anwtJHhtc9JYzoZ2DbyrtTAn9lGTIGugwHUBcoT5yYRw
         y+WZ9uRTS5OC6oKsD9tpoJItN5cpnKhWTLvNk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 216/223]drivers/video/hecubafb.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:46:00 -0700
Message-Id: <1284072367-8485-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072367-8485-1-git-send-email-justinmattock@gmail.com>
References: <1284072367-8485-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/video/hecubafb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
index c77bcc6..3059827 100644
--- a/drivers/video/hecubafb.c
+++ b/drivers/video/hecubafb.c
@@ -10,7 +10,7 @@
  *
  * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
  * This work was possible because of apollo display code from E-Ink's website
- * http://support.eink.com/community
+ * http://eink.com/ 
  * All information used to write this code is from public material made
  * available by E-Ink on its support site. Some commands such as 0xA4
  * were found by looping through cmd=0x00 thru 0xFF and supplying random
-- 
1.7.2.1

