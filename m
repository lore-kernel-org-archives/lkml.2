Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab1DZVas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:30:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:48614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1DZVOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483593"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segoon@openwall.com, mchehab@redhat.com, luca.risolia@studio.unibo.it,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [54/106] video: sn9c102: world-wirtable sysfs files
Message-Id: <20110426211334.8E62E3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit 14ddc3188d50855ae2a419a6aced995e2834e5d4 upstream.

Don't allow everybody to change video settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Luca Risolia <luca.risolia@studio.unibo.it>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/sn9c102/sn9c102_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/media/video/sn9c102/sn9c102_core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/sn9c102/sn9c102_core.c
+++ linux-2.6.35.y/drivers/media/video/sn9c102/sn9c102_core.c
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
 
 
