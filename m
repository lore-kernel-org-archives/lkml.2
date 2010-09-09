Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab0IIXJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:09:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49828 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab0IIWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QUDWukzKmHMjNgpioppwsYz1npS1q0shdDP9U2Beka/daUhEerxEvWomwHAaXNf6mR
         fotAGKrFSYsmzAE6TjMYtmuJ/S2hJIDPucUm0AH2lhwx1TvsQKq+MqfdfcLXSB5X9JR2
         qzF6aq4KPO2VtI4MZ+pURUlBlGZSjOATjB4mU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 026/223]drivers/hwmon/hwmon-vid.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:25:45 -0700
Message-Id: <1284071149-7723-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
References: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/hwmon/hwmon-vid.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
index bf0862a..ce42c21 100644
--- a/drivers/hwmon/hwmon-vid.c
+++ b/drivers/hwmon/hwmon-vid.c
@@ -38,20 +38,20 @@
  * available at http://developer.intel.com/.
  *
  * AMD Athlon 64 and AMD Opteron Processors, AMD Publication 26094,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/26094.PDF
+ * http://developer.amd.com/documentation/articles/pages/1212200690_2.aspx 
  * Table 74. VID Code Voltages
  * This corresponds to an arbitrary VRM code of 24 in the functions below.
  * These CPU models (K8 revision <= E) have 5 VID pins. See also:
  * Revision Guide for AMD Athlon 64 and AMD Opteron Processors, AMD Publication 25759,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25759.pdf
+ * http://web.archive.org/web/*/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25759.pdf
  *
  * AMD NPT Family 0Fh Processors, AMD Publication 32559,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/32559.pdf
+ * http://web.archive.org/web/*/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/32559.pdf
  * Table 71. VID Code Voltages
  * This corresponds to an arbitrary VRM code of 25 in the functions below.
  * These CPU models (K8 revision >= F) have 6 VID pins. See also:
  * Revision Guide for AMD NPT Family 0Fh Processors, AMD Publication 33610,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/33610.pdf
+ * http://web.archive.org/web/*/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/33610.pdf
  *
  * The 17 specification is in fact Intel Mobile Voltage Positioning -
  * (IMVP-II). You can find more information in the datasheet of Max1718
-- 
1.7.2.1

