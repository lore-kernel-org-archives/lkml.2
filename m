Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162830Ab1FAIYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:24:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:44839 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162818Ab1FAIY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:24:29 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:54 2011
Message-Id: <20110601081153.601369612@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:16 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vikram Narayanan <vikram186@gmail.com>,
        Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [106/165] i2c/writing-clients: Fix foo_driver.id_table
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 748
Lines: 27

From: Vikram Narayanan <vikram186@gmail.com>

commit 3116c86033079a1d4d4e84c40028f96b614843b8 upstream.

The i2c_device_id structure variable's name is not used in the
i2c_driver structure.

Signed-off-by: Vikram Narayanan <vikram186@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/i2c/writing-clients |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/i2c/writing-clients
+++ b/Documentation/i2c/writing-clients
@@ -38,7 +38,7 @@ static struct i2c_driver foo_driver = {
 		.name	= "foo",
 	},
 
-	.id_table	= foo_ids,
+	.id_table	= foo_idtable,
 	.probe		= foo_probe,
 	.remove		= foo_remove,
 	/* if device autodetection is needed: */


