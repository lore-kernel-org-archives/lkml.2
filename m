Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab0KRXEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:04:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34492 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab0KRXEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:04:33 -0500
Date: Thu, 18 Nov 2010 15:02:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: fix kernel-doc for set_consumer_device_supply
Message-Id: <20101118150226.d0614b85.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning for set_consumer_device_supply():

Warning(drivers/regulator/core.c:912): missing initial short description on line:
 * set_consumer_device_supply: Bind a regulator to a symbolic supply

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Liam Girdwood <lrg@slimlogic.co.uk>
Cc:	Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2637-r2g4-kerndoc.orig/drivers/regulator/core.c
+++ lnx-2637-r2g4-kerndoc/drivers/regulator/core.c
@@ -911,7 +911,7 @@ out:
 }
 
 /**
- * set_consumer_device_supply: Bind a regulator to a symbolic supply
+ * set_consumer_device_supply - Bind a regulator to a symbolic supply
  * @rdev:         regulator source
  * @consumer_dev: device the supply applies to
  * @consumer_dev_name: dev_name() string for device supply applies to
