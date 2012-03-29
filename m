Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab2C2QSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:18:44 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:42798 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751845Ab2C2QSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:18:36 -0400
Message-ID: <4F748B5B.9010104@xenotime.net>
Date: Thu, 29 Mar 2012 09:18:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Subject: [PATCH -next] hid: fix WACOM Kconfig warning
References: <20120329144217.6cacd2f040fa9abb9190ae1e@canb.auug.org.au>
In-Reply-To: <20120329144217.6cacd2f040fa9abb9190ae1e@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix hid Kconfig warning:

drivers/hid/Kconfig:595:error: recursive dependency detected!
drivers/hid/Kconfig:595:	symbol HID_WACOM depends on HID_WACOM

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/hid/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- linux-next-20120329.orig/drivers/hid/Kconfig
+++ linux-next-20120329/drivers/hid/Kconfig
@@ -595,7 +595,6 @@ config THRUSTMASTER_FF
 config HID_WACOM
 	tristate "Wacom Bluetooth devices support"
 	depends on BT_HIDP
-	depends on HID_WACOM
 	select POWER_SUPPLY
 	---help---
 	Support for Wacom Graphire Bluetooth and Intuos4 WL tablets.
