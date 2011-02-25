Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1BYGMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:12:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49465 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1BYGMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:12:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fAqutP4XXurrb7olGhHebP/AsGF6yOEkinF/bJRlZ7CEJUyNzrNgE9WSiKHrG0wXkK
         X996LmoTPkaACMBpIOO35yTydt2JM1sVpqO8YsJaOjXrSA6ndMt6lW+wDgmMW0e8CAja
         3pdXXaCsB5XpD+xGiTyA3Uhn4mrWv3YrC2lzc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 08/21]drivers:usb:wusbhc.h remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:11:55 -0800
Message-Id: <1298614315-3727-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/wusbcore/wusbhc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/wusbcore/wusbhc.h b/drivers/usb/wusbcore/wusbhc.h
index 3d94c42..6bd426b 100644
--- a/drivers/usb/wusbcore/wusbhc.h
+++ b/drivers/usb/wusbcore/wusbhc.h
@@ -132,7 +132,7 @@ static inline void wusb_dev_put(struct wusb_dev *wusb_dev)
 }
 
 /**
- * Wireless USB Host Controlller root hub "fake" ports
+ * Wireless USB Host Controller root hub "fake" ports
  * (state and device information)
  *
  * Wireless USB is wireless, so there are no ports; but we
-- 
1.7.4.1

