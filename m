Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448Ab1KJDYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:24:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933980Ab1KJDYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:24:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:06 2011
Message-Id: <20111109212706.697053537@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sergei Kolzun <x0r@dv-life.ru>,
        Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Subject: [063/262] HID: ACRUX - fix enabling force feedback support
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Kolzun <x0r@dv-life.ru>

commit 364b936fc38dec7653c690d710e10657af235a36 upstream.

The config option needs to be a 'bool' and not a tristate, otheriwse
force feedback support never makes it into the module.

Signed-off-by: Sergei Kolzun <x0r@dv-life.ru>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -69,7 +69,7 @@ config HID_ACRUX
 	Say Y here if you want to enable support for ACRUX game controllers.
 
 config HID_ACRUX_FF
-	tristate "ACRUX force feedback support"
+	bool "ACRUX force feedback support"
 	depends on HID_ACRUX
 	select INPUT_FF_MEMLESS
 	---help---


