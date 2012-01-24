Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2AXDLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:11:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab2AXCnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:43:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:26 2012
Message-Id: <20120124023926.407605175@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [028/129] HID: wiimote: Select INPUT_FF_MEMLESS
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 739
Lines: 27

From: David Herrmann <dh.herrmann@googlemail.com>

commit ef6f41157f3864d9bf42671b2ed66062dcafb72e upstream.

We depend on memless force-feedback support, therefore correctly select the
related config options.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -620,6 +620,7 @@ config HID_WIIMOTE
 	depends on BT_HIDP
 	depends on LEDS_CLASS
 	select POWER_SUPPLY
+	select INPUT_FF_MEMLESS
 	---help---
 	Support for the Nintendo Wii Remote bluetooth device.
 


