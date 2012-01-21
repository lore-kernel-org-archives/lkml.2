Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab2AUSES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:04:18 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55207 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751098Ab2AUSED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:03 -0500
Message-ID: <4F1B0BC4.6090406@xenotime.net>
Date: Sat, 21 Jan 2012 11:02:28 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: [PATCH 2/14] kernel-doc: fix new warnings in driver-core
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warnings:

Warning(drivers/base/bus.c:925): No description found for parameter 'key'
Warning(drivers/base/bus.c:1241): No description found for parameter 'subsys'
Warning(drivers/base/bus.c:1241): No description found for parameter 'groups'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- lnx-33-rc1.orig/drivers/base/bus.c
+++ lnx-33-rc1/drivers/base/bus.c
@@ -915,9 +915,10 @@ static BUS_ATTR(uevent, S_IWUSR, NULL, b
 
 /**
  * __bus_register - register a driver-core subsystem
- * @bus: bus.
+ * @bus: bus to register
+ * @key: lockdep class key
  *
- * Once we have that, we registered the bus with the kobject
+ * Once we have that, we register the bus with the kobject
  * infrastructure, then register the children subsystems it has:
  * the devices and drivers that belong to the subsystem.
  */
@@ -1220,8 +1221,8 @@ static void system_root_device_release(s
 }
 /**
  * subsys_system_register - register a subsystem at /sys/devices/system/
- * @subsys - system subsystem
- * @groups - default attributes for the root device
+ * @subsys: system subsystem
+ * @groups: default attributes for the root device
  *
  * All 'system' subsystems have a /sys/devices/system/<name> root device
  * with the name of the subsystem. The root device can carry subsystem-
