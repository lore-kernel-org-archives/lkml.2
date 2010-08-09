Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0HIXj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 19:39:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39937 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab0HIXj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 19:39:27 -0400
Date: Mon, 9 Aug 2010 16:37:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, khali@linux-fr.org
Subject: [PATCH resend] i2c.h: fix kernel-doc warnings
Message-Id: <20100809163716.1b50ac6f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in linux/i2c.h:

Warning(include/linux/i2c.h:176): No description found for parameter 'alert'
Warning(include/linux/i2c.h:259): No description found for parameter 'of_node'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/i2c.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.35-rc5-git1.orig/include/linux/i2c.h
+++ linux-2.6.35-rc5-git1/include/linux/i2c.h
@@ -108,6 +108,7 @@ extern s32 i2c_smbus_write_i2c_block_dat
  * @shutdown: Callback for device shutdown
  * @suspend: Callback for device suspend
  * @resume: Callback for device resume
+ * @alert: Alert callback, for example for the SMBus alert protocol
  * @command: Callback for bus-wide signaling (optional)
  * @driver: Device driver model driver
  * @id_table: List of I2C devices supported by this driver
@@ -233,6 +234,7 @@ static inline void i2c_set_clientdata(st
  * @addr: stored in i2c_client.addr
  * @platform_data: stored in i2c_client.dev.platform_data
  * @archdata: copied into i2c_client.dev.archdata
+ * @of_node: pointer to OpenFirmware device node
  * @irq: stored in i2c_client.irq
  *
  * I2C doesn't actually support hardware probing, although controllers and
