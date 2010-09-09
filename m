Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0IIWZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:25:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49828 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0IIWZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:25:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=a2pHYjVbNBBnjV6WzJENYWm/Wu2fEzvMFijCX+AQolP2zIZbYbsuXaavgGR3a7wxjR
         o/Dw47aBF4NNZy/dSxhAvM0E11DgHiIXFwrcT51KvjpjxKKIC3Cgo/TO/A3Pmq4lseIg
         EB2jx1lyqgs4OfVBIhtu8WOIoTpma1Lu1VI6A=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 023/223]drivers/hwmon/adm1025.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:25:42 -0700
Message-Id: <1284071149-7723-8-git-send-email-justinmattock@gmail.com>
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
 drivers/hwmon/adm1025.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
index 251b631..7b7f9c2 100644
--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -12,7 +12,7 @@
  * resolution of about 0.5% of the nominal value). Temperature values are
  * reported with a 1 deg resolution and a 3 deg accuracy. Complete
  * datasheet can be obtained from Analog's website at:
- *   http://www.analog.com/Analog_Root/productPage/productHome/0,2121,ADM1025,00.html
+ *  http://www.analog.com/en/content/Parts_List_Sold_to_On_Semiconductor/fca.html 
  *
  * This driver also supports the ADM1025A, which differs from the ADM1025
  * only in that it has "open-drain VID inputs while the ADM1025 has
-- 
1.7.2.1

