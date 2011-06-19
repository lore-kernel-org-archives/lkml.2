Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1FSUaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 16:30:46 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:46393 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab1FSUao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 16:30:44 -0400
Message-ID: <4DFE5C58.5000400@freemail.hu>
Date: Sun, 19 Jun 2011 22:30:16 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] add more help description for "path to uevent helper"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 188.143.83.101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The kernel configuration UEVENT_HELPER_PATH is a string to
the uevent helper program. Add more description about how
to disable this feature and how to enable it again during
runtime.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-3.0-rc3/drivers/base/Kconfig.orig	2011-06-14 00:29:59.000000000 +0200
+++ linux-3.0-rc3/drivers/base/Kconfig	2011-06-19 23:21:35.000000000 +0200
@@ -16,6 +16,11 @@ config UEVENT_HELPER_PATH
 	  that it creates a high system load, or on smaller systems
 	  it is known to create out-of-memory situations during bootup.

+	  To disable user space helper program execution at early boot
+	  time specify an empty string here. This setting can be altered
+	  via /proc/sys/kernel/hotplug or via /sys/kernel/uevent_helper
+	  later at runtime.
+
 config DEVTMPFS
 	bool "Maintain a devtmpfs filesystem to mount at /dev"
 	depends on HOTPLUG
