Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2APSs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:48:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab2APSsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:48:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:18 2012
Message-Id: <20120116184518.205969311@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [29/48] HID: wiimote: Select INPUT_FF_MEMLESS
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
@@ -583,6 +583,7 @@ config HID_WACOM_POWER_SUPPLY
 	bool "Wacom Bluetooth devices power supply status support"
 	depends on HID_WACOM
 	select POWER_SUPPLY
+	select INPUT_FF_MEMLESS
 	---help---
 	  Say Y here if you want to enable power supply status monitoring for
 	  Wacom Bluetooth devices.


