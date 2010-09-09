Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab0IIWp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:45:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57020 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259Ab0IIWpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HIplWUPfaEjMQfjI/m421Rm7JmjSm8HYF5YawLoIZv+P/hjnuGciTLYuTeUhHqzpmS
         0n0+R+n7nR4ET4inf7PMedHaxbwIcMm1Jm/V9VrC5vGUQWNbx0AeUkINxihm41QZvKF+
         4TiYaknTBhf/EwjI30ziHg54oLAolBmbrKRZk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 204/223]drivers/usb/serial/mct_u232.h Update broken web addresses.
Date: Thu,  9 Sep 2010 15:45:03 -0700
Message-Id: <1284072309-8452-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
References: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/serial/mct_u232.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/mct_u232.h b/drivers/usb/serial/mct_u232.h
index 3a3f5e6..850a152 100644
--- a/drivers/usb/serial/mct_u232.h
+++ b/drivers/usb/serial/mct_u232.h
@@ -10,10 +10,10 @@
  *
  * This driver is for the device MCT USB-RS232 Converter (25 pin, Model No.
  * U232-P25) from Magic Control Technology Corp. (there is also a 9 pin
- * Model No. U232-P9). See http://www.mct.com.tw/p_u232.html for further
+ * Model No. U232-P9). See http://www.mct.com.tw/ for further
  * information. The properties of this device are listed at the end of this
- * file. This device is available from various distributors. I know Hana,
- * http://www.hana.de and D-Link, http://www.dlink.com/products/usb/dsbs25.
+ * file. This device is available from various distributors.
+ * D-Link, http://www.dlink.com/products/usb/dsbs25.
  *
  * All of the information about the device was acquired by using SniffUSB
  * on Windows98. The technical details of the reverse engineering are
@@ -457,8 +457,8 @@ static int mct_u232_calculate_baud_rate(struct usb_serial *serial,
  * USB endpoint chip and a Philips P87C52UBAA microcontroller with
  * embedded UART.  Exhaustive documentation for these is available at:
  *
+ *   http://www.nxp.com/ 
  *   http://www.semiconductors.philips.com/pip/p87c52ubaa
- *   http://www.semiconductors.philips.com/pip/pdiusbd12
  *
  * Thanks to Julian Highfield for the pointer to the Philips database.
  *
-- 
1.7.2.1

