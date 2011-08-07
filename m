Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1HGBld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 21:41:33 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54974 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753492Ab1HGBlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 21:41:31 -0400
Date: Sat, 6 Aug 2011 18:41:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>, jlee@novell.com,
        joeyli.kernel@gmail.com, akpm <akpm@linux-foundation.org>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH] gpu/stub: try to make help text readable
Message-Id: <20110806184129.287dd4f9.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

I couldn't parse the STUB_POULSBO help text and the module names
were misleading, so try to make it more readable, use corrected
module names, and spell "acpi" as "ACPI".

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Lee, Chun-Yi <jlee@novell.com>
Cc: Lee, Chun-Yi <joeyli.kernel@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/stub/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-3.0-git22.orig/drivers/gpu/stub/Kconfig
+++ linux-3.0-git22/drivers/gpu/stub/Kconfig
@@ -12,7 +12,7 @@ config STUB_POULSBO
 	help
 	  Choose this option if you have a system that has Intel GMA500
 	  (Poulsbo) integrated graphics. If M is selected, the module will
-	  be called Poulsbo. This driver is a stub driver for Poulsbo that
-	  will call poulsbo.ko to enable the acpi backlight control sysfs
-	  entry file because there have no poulsbo native driver can support
+	  be called poulsbo. This driver is a stub driver for Poulsbo that
+	  will call psb_gfx.ko to enable the ACPI backlight control sysfs
+	  entry file because there is no poulsbo native driver that supports
 	  intel opregion.
