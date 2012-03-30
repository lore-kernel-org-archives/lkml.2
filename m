Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966173Ab2C3VjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:39:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43949 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936213Ab2C3VcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:08 -0400
X-Sasl-enc: IdSJlhmQh+EIeKuo2bDMui7nA6pl/RYumrmUwo1i3EYo 1333143127
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:57 2012
Message-Id: <20120330194856.957378841@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Masanari Iida <standby24x7@gmail.com>
Subject: [ 153/175] backlight: fix typo in tosa_lcd.c
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masanari Iida <standby24x7@gmail.com>

commit 8da00edc1069f01c34510fa405dc15d96c090a3f upstream.

Fix typo in drivers/video/backlight/tosa_lcd.c
"tosa_lcd_reume" should be "tosa_lcd_resume".

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/backlight/tosa_lcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -271,7 +271,7 @@ static int tosa_lcd_resume(struct spi_de
 }
 #else
 #define tosa_lcd_suspend	NULL
-#define tosa_lcd_reume NULL
+#define tosa_lcd_resume NULL
 #endif
 
 static struct spi_driver tosa_lcd_driver = {


