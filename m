Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1BYGN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:13:28 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46776 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1BYGN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NTb5LmvL+6lZRG8LsWTHok1WpHSHDAuRZp87yzVeD0EjIaJzuHMgLzqWqcUm8qhreO
         7iUq/ixv4ZJoY8+uEpBEg1Y47asmMJ2MJuL5CqxVOGnF2aHSgBhS6fe1FiHYNGlxQuVA
         BYnSN6O9KeQ+VLc9XFVp4Xvc3uCNqpsnqmFGQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: tj@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 11/21]drivers:uwb:scan.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:13:09 -0800
Message-Id: <1298614389-3880-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/uwb/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/scan.c b/drivers/uwb/scan.c
index 76a1a1e..367aa12 100644
--- a/drivers/uwb/scan.c
+++ b/drivers/uwb/scan.c
@@ -42,7 +42,7 @@
 /**
  * Start/stop scanning in a radio controller
  *
- * @rc:      UWB Radio Controlller
+ * @rc:      UWB Radio Controller
  * @channel: Channel to scan; encodings in WUSB1.0[Table 5.12]
  * @type:    Type of scanning to do.
  * @bpst_offset: value at which to start scanning (if type ==
-- 
1.7.4.1

