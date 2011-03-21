Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1CUXOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:14:16 -0400
Received: from kroah.org ([198.145.64.141]:49135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab1CUXOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:14:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:54 2011
Message-Id: <20110321231054.600920736@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roman Fietze <roman.fietze@telemotive.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: [38/44] i2c: Fix typo in instantiating-devices document
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Roman Fietze <roman.fietze@telemotive.de>

commit 6ced9e6b3901af4ab6ac0a11231402c888286ea6 upstream.

The struct i2c_board_info member holding the name is "type", not
"name".

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/i2c/instantiating-devices |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/i2c/instantiating-devices
+++ b/Documentation/i2c/instantiating-devices
@@ -100,7 +100,7 @@ static int __devinit usb_hcd_pnx4008_pro
 	(...)
 	i2c_adap = i2c_get_adapter(2);
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(i2c_info.name, "isp1301_pnx", I2C_NAME_SIZE);
+	strlcpy(i2c_info.type, "isp1301_pnx", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
 						   normal_i2c);
 	i2c_put_adapter(i2c_adap);


