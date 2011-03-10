Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1CKACi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:02:38 -0500
Received: from kroah.org ([198.145.64.141]:46822 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab1CJX5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:36 2011
Message-Id: <20110310235536.747224966@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>, Shubhrajyoti D <shubhrajyoti@ti.com>,
        Christoph Mair <christoph.mair@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [patch 07/29] drivers/misc/bmp085.c: add MODULE_DEVICE_TABLE
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 97e419a082461f8a3a0818834eb88ad41219a1da upstream.

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: Christoph Mair <christoph.mair@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/bmp085.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -449,6 +449,7 @@ static const struct i2c_device_id bmp085
 	{ "bmp085", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, bmp085_id);
 
 static struct i2c_driver bmp085_driver = {
 	.driver = {


