Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2FROmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:42:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48498 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2FROme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:42:34 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/2]staging "serqt_usb2" Fix some typos. 
Date: Mon, 18 Jun 2012 07:42:23 -0700
Message-Id: <1340030544-21245-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes some typos that was found while reading through
"staging" "serqt_usb2"

 drivers/staging/serqt_usb2/serqt_usb2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 43045db..26fd038 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -609,7 +609,7 @@ static int BoxSetRegister(struct usb_serial *serial, unsigned short Uart_Number,
 
 /*
  * qt_setuart
- * issuse a SET_UART vendor-spcific request on the default control pipe
+ * issues a SET_UART vendor-specific request on the default control pipe
  * If successful sets baud rate divisor and LCR value
  */
 static int qt_setuart(struct usb_serial *serial, unsigned short Uart_Number,
@@ -1388,7 +1388,7 @@ static inline int qt_real_tiocmset(struct tty_struct *tty,
 		return -ESPIPE;
 
 	/*
-	 * Turn off the RTS and DTR and loopbcck and then only turn on what was
+	 * Turn off the RTS and DTR and loopback and then only turn on what was
 	 * asked for
 	 */
 	mcr &= ~(SERIAL_MCR_RTS | SERIAL_MCR_DTR | SERIAL_MCR_LOOP);
-- 
1.7.5.4

