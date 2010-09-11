Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0IKDMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 23:12:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63956 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0IKDMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 23:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vgR3sglc/XCkqz+pnXQILoRYZnJmWhaNauAJfHFVo4XjF5DZVjFpFXVNhQ/xj5LVJE
         zqdYVmga1nP3xDBrmJjWe1vlfn6KzpPg6ziUN3bioVSVA9KCEHvgU+fgfdCUnGBx6jVp
         QwEbRozgSISpdPHAeXNXOhNvlXrWDLFOmcj9A=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 01/11]fs/hostfs/hostfs.h Update broken web addresses.
Date: Fri, 10 Sep 2010 20:12:42 -0700
Message-Id: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/hostfs/hostfs.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
index 6bbd75c..2e58848 100644
--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -28,12 +28,7 @@
  * #define ATTR_KILL_SUID	2048
  * #define ATTR_KILL_SGID	4096
  *
- * and this is because they were added in 2.5 development in this patch:
- *
- * http://linux.bkbits.net:8080/linux-2.5/
- * cset@3caf4a12k4XgDzK7wyK-TGpSZ9u2Ww?nav=index.html
- * |src/.|src/include|src/include/linux|related/include/linux/fs.h
- *
+ * and this is because they were added in 2.5 development.  
  * Actually, they are not needed by most ->setattr() methods - they are set by
  * callers of notify_change() to notify that the setuid/setgid bits must be
  * dropped.
-- 
1.7.2.1

