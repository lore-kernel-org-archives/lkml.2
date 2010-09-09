Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab0IIWh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:37:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59224 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab0IIWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ky6tJxXCVOBe+tNcuE+d+tcIenhJwxEF6jsr+04fr6bWslCigytBG5XCLcnyM3BFlL
         Z2PD6R7sfdCL3yR9LKBtg7ejkTXuRCMXQHwv9yuPFERXJHP31UTLGQ+q4OjG3P6wxsWW
         1ym2y7pCQFDCxFBsneoDOtPzm63Mpwv+zRrR8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 123/223]drivers/parport/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:30 -0700
Message-Id: <1284071862-8194-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/parport/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 855f389..b578d2c 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -18,8 +18,8 @@ menuconfig PARPORT
 	  <file:drivers/parport/BUGS-parport>.
 
 	  For extensive information about drivers for many devices attaching
-	  to the parallel port see <http://www.torque.net/linux-pp.html> on
-	  the WWW.
+	  to the parallel port see 
+	  http://web.archive.org/web/*/http://www.torque.net/linux-pp.html.
 
 	  It is possible to share a single parallel port among several devices
 	  and it is safe to compile all the corresponding drivers into the
-- 
1.7.2.1

