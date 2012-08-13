Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2HMR2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:28:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46596 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2HMR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:28:40 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: martyn.welch@ge.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v2]staging "vme" Fix typos.
Date: Mon, 13 Aug 2012 10:28:22 -0700
Message-Id: <1344878902-22059-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
Note:resend with minor adjustments.
The below patch fixes typos found while reading through staging "vme"

 drivers/staging/vme/devices/vme_user.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index e25645e..0170788 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -64,13 +64,13 @@ static unsigned int bus_num;
  *
  * However the VME driver at http://www.vmelinux.org/ is rather old and doesn't
  * even support the tsi148 chipset (which has 8 master and 8 slave windows).
- * We'll run with this or now as far as possible, however it probably makes
+ * We'll run with this for now as far as possible, however it probably makes
  * sense to get rid of the old mappings and just do everything dynamically.
  *
  * So for now, we'll restrict the driver to providing 4 masters and 4 slaves as
  * defined above and try to support at least some of the interface from
- * http://www.vmelinux.org/ as an alternative drive can be written providing a
- * saner interface later.
+ * http://www.vmelinux.org/ as an alternative the driver can be written
+ * providing a saner interface later.
  *
  * The vmelinux.org driver never supported slave images, the devices reserved
  * for slaves were repurposed to support all 8 master images on the UniverseII!
@@ -242,7 +242,7 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
 }
 
 /*
- * We are going ot alloc a page during init per window for small transfers.
+ * We are going to alloc a page during init per window for small transfers.
  * Small transfers will go user space -> buffer -> VME. Larger (more than a
  * page) transfers will lock the user space buffer into memory and then
  * transfer the data directly from the user space buffers out to VME.
-- 
1.7.5.4

