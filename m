Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab1LGUee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:34:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33519 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab1LGUec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:34:32 -0500
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-input@vger.kernel.org
Cc: rdunlap@xenotime.net, linux-next@vger.kernel.org, jkosina@suse.cz,
        linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH] HID: wiimote: Select INPUT_FF_MEMLESS
Date: Wed,  7 Dec 2011 21:33:59 +0100
Message-Id: <1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <4EDFD23D.4030703@xenotime.net>
References: <4EDFD23D.4030703@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We depend on memless force-feedback support, therefore correctly select the
related config options.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
Hi Randy

Thanks for reporting this. This patch should fix this. I don't know whether such
fixes belong to stable tree, if they do, Jiri could you CC stable when applying
it?

Cheers
David

 drivers/hid/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index edf2b2b..dae04a0 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -591,6 +591,7 @@ config HID_WIIMOTE
 	depends on BT_HIDP
 	depends on LEDS_CLASS
 	select POWER_SUPPLY
+	select INPUT_FF_MEMLESS
 	---help---
 	Support for the Nintendo Wii Remote bluetooth device.
 
-- 
1.7.8

