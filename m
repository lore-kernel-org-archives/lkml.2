Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab2LNXGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:06:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:41193 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116Ab2LNXGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:06:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Ren=C3=A9=20B=C3=BCrgel?= <rene.buergel@sohard.de>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [ 05/27] ezusb: add dependency to USB
Date: Fri, 14 Dec 2012 15:01:18 -0800
Message-Id: <20121214222252.300406519@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222251.229078963@linuxfoundation.org>
References: <20121214222251.229078963@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rene Buergel <rene.buergel@sohard.de>

commit 9db72fe6c943852032d9ed863c87e8c02d3cb9da upstream.

This fixes an error during modpost, when ezusb is built into the kernel
while USB is built as module.

Signed-off-by: René Bürgel <rene.buergel@sohard.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/usb/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -246,6 +246,7 @@ config USB_YUREX
 
 config USB_EZUSB_FX2
 	tristate "Functions for loading firmware on EZUSB chips"
+	depends on USB
 	help
 	  Say Y here if you need EZUSB device support.
 	  (Cypress FX/FX2/FX2LP microcontrollers)


