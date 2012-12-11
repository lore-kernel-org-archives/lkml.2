Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2LKVx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:53:59 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:49951 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab2LKVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:19 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
Subject: [PATCH 08/19] MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*
Date: Tue, 11 Dec 2012 19:49:50 -0200
Message-Id: <1355262601-4263-9-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was never at dvb-usb-v2, as far as I could see.

Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8265764..b8dfc72 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2594,7 +2594,7 @@ W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
-F:	drivers/media/usb/dvb-usb-v2/cxusb*
+F:	drivers/media/usb/dvb-usb/cxusb*
 
 DVB_USB_CYPRESS_FIRMWARE MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
-- 
1.7.11.7

