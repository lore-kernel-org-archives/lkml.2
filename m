Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab1DYUZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:39 -0400
Received: from 1wt.eu ([62.212.114.60]:34610 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab1DYUZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:32 -0400
Message-Id: <20110425200240.032440592@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Luca Risolia <luca.risolia@studio.unibo.it>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 162/173] [media] video: sn9c102: world-wirtable sysfs files
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
 
 


