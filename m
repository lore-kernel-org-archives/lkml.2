Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0IIXJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:09:49 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39116 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab0IIWZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BFJvWT8buQaLnyv0w6AxbWTC/CttcoDL6kgIgxlQLInWsJOQ7Afonkj/+kAsmAKqZb
         Q8Xgv9MhUx/zAB1JoIOAu7pb9UeBV4il+yElA+azaEUK5G0OGi+VwfVtn9E3uewv/kix
         3GuRUWiyQb456MSCGzOIc0Z1+m0XfaDTcziws=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 022/223]drivers/hwmon/adcxx.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:25:41 -0700
Message-Id: <1284071149-7723-7-git-send-email-justinmattock@gmail.com>
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
 drivers/hwmon/adcxx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index fbdc765..8803ed9 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -14,7 +14,7 @@
  *   and 101 for 1 MSPS)
  *
  * Complete datasheets are available at National's website here:
- * http://www.national.com/ds/DC/ADC<bb><c>S<sss>.pdf
+ * http://www.national.com/products/catalog.do 
  *
  * Handling of 8, 10 and 12 bits converters are the same, the
  * unavailable bits are 0 :)
-- 
1.7.2.1

