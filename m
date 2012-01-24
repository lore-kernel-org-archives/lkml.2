Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2AXC7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:59:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab2AXC72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:59:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:34 2012
Message-Id: <20120124023934.617092918@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Dooks <ben-linux@fluff.org>
Subject: [120/129] i2c-eg20t: modified the setting of transfer rate.
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 864
Lines: 27

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

commit ff35e8b18984ad2a82cbd259fc07f0be4b34b1aa upstream.

This patch modified the setting value of
I2C Bus Transfer Rate Setting Counter regisrer.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-eg20t.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -243,7 +243,7 @@ static void pch_i2c_init(struct i2c_algo
 	if (pch_clk > PCH_MAX_CLK)
 		pch_clk = 62500;
 
-	pch_i2cbc = (pch_clk + (pch_i2c_speed * 4)) / pch_i2c_speed * 8;
+	pch_i2cbc = (pch_clk + (pch_i2c_speed * 4)) / (pch_i2c_speed * 8);
 	/* Set transfer speed in I2CBC */
 	iowrite32(pch_i2cbc, p + PCH_I2CBC);
 


