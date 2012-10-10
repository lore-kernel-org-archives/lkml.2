Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab2JKAX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:23:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55462 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933179Ab2JKAXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:23:45 -0400
X-Sasl-enc: iCdR8Zo38vTNFDusDUdXg511wZx09/rfqIcwelx7fqtO 1349915022
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel@quora.org>, Jean Delvare <khali@linux-fr.org>
Subject: [ 005/122] i2c-piix4: Fix build failure
Date: Thu, 11 Oct 2012 07:52:51 +0900
Message-Id: <20121010225338.952572928@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel J Blueman <daniel@quora.org>

commit c415b303a704e5c5f766fc0404093910c36cc4ab upstream.

Fix build failure in Intel PIIX4 I2C driver.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-piix4.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -37,6 +37,7 @@
 #include <linux/stddef.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/acpi.h>


