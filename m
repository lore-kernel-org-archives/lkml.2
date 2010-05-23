Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0EWSI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 14:08:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27688 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0EWSIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 14:08:55 -0400
Date: Sun, 23 May 2010 11:07:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Roald Frederickx <roald.frederickx@gmail.com>
Subject: [PATCH -mmotm] compal-laptop: uses hwmon interfaces, depends on
 HWMON
Message-Id: <20100523110751.73c760a7.randy.dunlap@oracle.com>
In-Reply-To: <201005212333.o4LNXu2P008079@imap1.linux-foundation.org>
References: <201005212333.o4LNXu2P008079@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BF96F2D.0116:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

compal-laptop uses hwmon interfaces, so it should depend on HWMON.

compal-laptop.c:(.devinit.text+0x4071f): undefined reference to `hwmon_device_register'
compal-laptop.c:(.devexit.text+0x6ec0): undefined reference to `hwmon_device_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roald Frederickx <roald.frederickx@gmail.com>
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2010-0521-1605.orig/drivers/platform/x86/Kconfig
+++ mmotm-2010-0521-1605/drivers/platform/x86/Kconfig
@@ -181,6 +181,7 @@ config COMPAL_LAPTOP
 	depends on ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL
+	depends on HWMON
 	---help---
 	  This is a driver for laptops built by Compal:
 
