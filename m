Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab2AXCyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:54:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785Ab2AXCsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:34 2012
Message-Id: <20120124023934.010418090@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexander Aring <a.aring@phytec.de>,
        Kevin Hilman <khilman@ti.com>
Subject: [113/129] I2C: OMAP: correct SYSC register offset for OMAP4
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 868
Lines: 28

From: Alexander Aring <a.aring@phytec.de>

commit 2727b1753934e154931d6b3bdf20c9b2398457a2 upstream.

Correct OMAP_I2C_SYSC_REG offset in omap4 register map.
Offset 0x20 is reserved and OMAP_I2C_SYSC_REG has 0x10 as offset.

Signed-off-by: Alexander Aring <a.aring@phytec.de>
[khilman@ti.com: minor changelog edits]
Signed-off-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -235,7 +235,7 @@ static const u8 reg_map_ip_v2[] = {
 	[OMAP_I2C_BUF_REG] = 0x94,
 	[OMAP_I2C_CNT_REG] = 0x98,
 	[OMAP_I2C_DATA_REG] = 0x9c,
-	[OMAP_I2C_SYSC_REG] = 0x20,
+	[OMAP_I2C_SYSC_REG] = 0x10,
 	[OMAP_I2C_CON_REG] = 0xa4,
 	[OMAP_I2C_OA_REG] = 0xa8,
 	[OMAP_I2C_SA_REG] = 0xac,


