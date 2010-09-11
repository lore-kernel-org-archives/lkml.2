Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0IKE1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 00:27:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55585 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab0IKE1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 00:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AXEqiLmEXpKQ+N4sE7Wm9ICGrbkg13LXMsQjr+jlD/tmoV7z/ADy0NW7rbKyGJ6fJY
         B5tabmE3jV5si0SHqSpuXXUVWifM7bqsqtmL7/9iXX0UNg7alHepUYLjcmzjN0L2pA50
         J00aqSr6rpLVa3bCrx5HVuDOwf13zlY3dmx7k=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 06/10]include/linux/edd.h Update broken web addresses.
Date: Fri, 10 Sep 2010 21:27:53 -0700
Message-Id: <1284179277-7788-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284179277-7788-1-git-send-email-justinmattock@gmail.com>
References: <1284179277-7788-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/linux/edd.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/edd.h b/include/linux/edd.h
index 4cbd0fe..557227c 100644
--- a/include/linux/edd.h
+++ b/include/linux/edd.h
@@ -6,8 +6,9 @@
  * structures and definitions for the int 13h, ax={41,48}h
  * BIOS Enhanced Disk Drive Services
  * This is based on the T13 group document D1572 Revision 0 (August 14 2002)
- * available at http://www.t13.org/docs2002/d1572r0.pdf.  It is
- * very similar to D1484 Revision 3 http://www.t13.org/docs2002/d1484r3.pdf
+ * available at http://web.archive.org/web/*/http://www.t13.org/docs2002/d1572r0.pdf.
+ * It is very similar to D1484 Revision 3 
+ * http://web.archive.org/web/*/http://www.t13.org/docs2002/d1484r3.pdf
  *
  * In a nutshell, arch/{i386,x86_64}/boot/setup.S populates a scratch
  * table in the boot_params that contains a list of BIOS-enumerated
-- 
1.7.2.1

