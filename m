Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161319Ab2CSPSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:18:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56306 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758854Ab2CSPSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:18:11 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/5]NEXT:drivers:staging:quatech_usb2:quatech_usb2.c Fix typo in staging:quatech_usb2
Date: Mon, 19 Mar 2012 08:17:53 -0700
Message-Id: <1332170273-3482-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
References: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo that I found while reading.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/quatech_usb2/quatech_usb2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index bb977e0..cb7d906 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -732,7 +732,7 @@ static int qt2_write(struct tty_struct *tty, struct usb_serial_port *port,
 	}
 
 	/* We must fill the first 5 bytes of anything we sent with a transmit
-	 * header which directes the data to the correct port. The maximum
+	 * header which directs the data to the correct port. The maximum
 	 * size we can send out in one URB is port->bulk_out_size, which caps
 	 * the number of bytes of real data we can send in each write. As the
 	 * semantics of write allow us to write less than we were give, we cap
-- 
1.7.5.4

