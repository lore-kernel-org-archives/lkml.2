Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1KQCWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:22:45 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49104 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755148Ab1KQCWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:22:44 -0500
Message-ID: <4EC46F83.2030901@xenotime.net>
Date: Wed, 16 Nov 2011 18:20:51 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] platform/x86: fix dell-laptop function prototypes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build warnings:
drivers/platform/x86/dell-laptop.c:592:13: warning: function declaration isn't a prototype
drivers/platform/x86/dell-laptop.c:599:13: warning: function declaration isn't a prototype

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/dell-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-32-rc2.orig/drivers/platform/x86/dell-laptop.c
+++ lnx-32-rc2/drivers/platform/x86/dell-laptop.c
@@ -589,14 +589,14 @@ static const struct backlight_ops dell_o
 	.update_status  = dell_send_intensity,
 };
 
-static void touchpad_led_on()
+static void touchpad_led_on(void)
 {
 	int command = 0x97;
 	char data = 1;
 	i8042_command(&data, command | 1 << 12);
 }
 
-static void touchpad_led_off()
+static void touchpad_led_off(void)
 {
 	int command = 0x97;
 	char data = 2;
