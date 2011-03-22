Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1CVJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:29:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34423 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1CVJ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qfPNQ4JPu/Eb/aXeoVS1YvKkofiz23tvcdl07UplC3bXEN1qPhMQiluGH0cdUosFs+
         JJclR7m1sQQgAgHGxtgEZ1vqjEsxQ93EWZII4rQ5MhEnjoDTyqDSlki6vBq8KcQ8GDWL
         Qm5gV7oHyrwBx5T8OnH/2hbqliTqVBlQPyfgk=
From: Stephen Boyd <bebarino@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH/TRIVIAL] HID: Fix typo Keyoutch -> Keytouch
Date: Tue, 22 Mar 2011 02:29:17 -0700
Message-Id: <1300786157-29746-1-git-send-email-bebarino@gmail.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Boyd <bebarino@gmail.com>
---
 drivers/hid/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index b7ec405..7c28ad9 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -185,7 +185,7 @@ config HID_EZKEY
 	Support for Ezkey BTC 8193 keyboard.
 
 config HID_KEYTOUCH
-	tristate "Keyoutch HID devices"
+	tristate "Keytouch HID devices"
 	depends on USB_HID
 	---help---
 	Support for Keytouch HID devices not fully compliant with
-- 
1.7.4.1.343.ga91df

