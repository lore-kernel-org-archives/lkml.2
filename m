Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab0GWQmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:42:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53544 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0GWQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:42:12 -0400
Date: Fri, 23 Jul 2010 09:41:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        Matthew Garrett <mjg@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH -next] compal-laptop: depends on POWER_SUPPLY
Message-Id: <20100723094134.10c86761.randy.dunlap@oracle.com>
In-Reply-To: <20100723164931.7bf2160f.sfr@canb.auug.org.au>
References: <20100723164931.7bf2160f.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C49C655.001F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

compal-laptop uses power_supply interfaces so it should depend
on POWER_SUPPLY.

ERROR: "power_supply_register" [drivers/platform/x86/compal-laptop.ko] undefined!
ERROR: "power_supply_unregister" [drivers/platform/x86/compal-laptop.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Cc:	Matthew Garrett <mjg@redhat.com>
Cc:	platform-driver-x86@vger.kernel.org
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100723.orig/drivers/platform/x86/Kconfig
+++ linux-next-20100723/drivers/platform/x86/Kconfig
@@ -183,6 +183,7 @@ config COMPAL_LAPTOP
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL
 	depends on HWMON
+	depends on POWER_SUPPLY
 	---help---
 	  This is a driver for laptops built by Compal:
 
