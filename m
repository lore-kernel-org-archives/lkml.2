Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1DSUmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:42:33 -0400
Received: from kroah.org ([198.145.64.141]:58902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1DSUmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:17 2011
Message-Id: <20110419204116.934318750@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:30:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Luca Risolia <luca.risolia@studio.unibo.it>
Subject: [02/28] [media] video: sn9c102: world-wirtable sysfs files
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 14ddc3188d50855ae2a419a6aced995e2834e5d4 upstream.

Don't allow everybody to change video settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Luca Risolia <luca.risolia@studio.unibo.it>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/sn9c102/sn9c102_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -1430,9 +1430,9 @@ static DEVICE_ATTR(i2c_reg, S_IRUGO | S_
 		   sn9c102_show_i2c_reg, sn9c102_store_i2c_reg);
 static DEVICE_ATTR(i2c_val, S_IRUGO | S_IWUSR,
 		   sn9c102_show_i2c_val, sn9c102_store_i2c_val);
-static DEVICE_ATTR(green, S_IWUGO, NULL, sn9c102_store_green);
-static DEVICE_ATTR(blue, S_IWUGO, NULL, sn9c102_store_blue);
-static DEVICE_ATTR(red, S_IWUGO, NULL, sn9c102_store_red);
+static DEVICE_ATTR(green, S_IWUSR, NULL, sn9c102_store_green);
+static DEVICE_ATTR(blue, S_IWUSR, NULL, sn9c102_store_blue);
+static DEVICE_ATTR(red, S_IWUSR, NULL, sn9c102_store_red);
 static DEVICE_ATTR(frame_header, S_IRUGO, sn9c102_show_frame_header, NULL);
 
 


