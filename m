Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0G1RQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:16:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25575 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0G1RQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:16:23 -0400
Date: Wed, 28 Jul 2010 10:16:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        Angelo Arrifano <miknix@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging/quickstart: depends on INPUT
Message-Id: <20100728101607.6e6e5260.randy.dunlap@oracle.com>
In-Reply-To: <20100728162855.4968e561.sfr@canb.auug.org.au>
References: <20100728162855.4968e561.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C5065DC.0006:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

quickstart uses input_*() functions so it should depend on INPUT.

ERROR: "input_register_device" [drivers/staging/quickstart/quickstart.ko] undefined!
ERROR: "input_allocate_device" [drivers/staging/quickstart/quickstart.ko] undefined!
ERROR: "input_event" [drivers/staging/quickstart/quickstart.ko] undefined!
ERROR: "input_free_device" [drivers/staging/quickstart/quickstart.ko] undefined!
ERROR: "input_unregister_device" [drivers/staging/quickstart/quickstart.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Angelo Arrifano <miknix@gmail.com>
---
 drivers/staging/quickstart/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100728.orig/drivers/staging/quickstart/Kconfig
+++ linux-next-20100728/drivers/staging/quickstart/Kconfig
@@ -1,6 +1,6 @@
 config ACPI_QUICKSTART
 	tristate "ACPI Quickstart key driver"
-	depends on ACPI
+	depends on ACPI && INPUT
 	help
 	  Say Y here if you have a platform that supports the ACPI
 	  quickstart key protocol.
