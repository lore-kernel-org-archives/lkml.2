Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1KAVx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:53:58 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:47846 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753565Ab1KAVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:53:55 -0400
Message-ID: <4EB06A55.5080500@xenotime.net>
Date: Tue, 01 Nov 2011 14:53:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH -next] platform/X86: fix dell-laptop function prototypes
References: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au>
In-Reply-To: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au>
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

--- next-2011-1101.orig/drivers/platform/x86/dell-laptop.c
+++ next-2011-1101/drivers/platform/x86/dell-laptop.c
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
