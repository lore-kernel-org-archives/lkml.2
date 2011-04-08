Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab1DHPXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:23:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50933 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1DHPXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FYFsL5mw5HD0OaA/IN9e7scSsCzeX3VI88LUc8b2wDhXfpNhDCrJlHlhwTogQ6mPmk
         XLSUj1siDv7Js8ZTeHtQ0WYfRft2YQQvjg3yq3PITphEsePZAENoSl5Q6HBQrDg6flq2
         jPS9PGZ1qbzqeetcC5p9iBoFcjWBhqj2OiyY0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:misc:ibmasm:ibmasmfs.c Fix typo dymamically.
Date: Fri,  8 Apr 2011 08:23:23 -0700
Message-Id: <1302276203-4460-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes a typo in a comment.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/misc/ibmasm/ibmasmfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index d2d5d23..8994772 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -29,7 +29,7 @@
 
 /*
  * The IBMASM file virtual filesystem. It creates the following hierarchy
- * dymamically when mounted from user space:
+ * dynamically when mounted from user space:
  *
  *    /ibmasm
  *    |-- 0
-- 
1.7.4.2

