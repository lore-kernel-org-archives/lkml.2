Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196Ab1C3VXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:23:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:37491 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965115Ab1C3VJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278839"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: roman.fietze@telemotive.de, khali@linux-fr.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [217/275] i2c: Fix typo in instantiating-devices document
Message-Id: <20110330210742.2FF1D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Roman Fietze <roman.fietze@telemotive.de>

commit 6ced9e6b3901af4ab6ac0a11231402c888286ea6 upstream.

The struct i2c_board_info member holding the name is "type", not
"name".

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/i2c/instantiating-devices |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/Documentation/i2c/instantiating-devices
===================================================================
--- linux-2.6.35.y.orig/Documentation/i2c/instantiating-devices	2011-03-29 22:50:30.672473587 -0700
+++ linux-2.6.35.y/Documentation/i2c/instantiating-devices	2011-03-29 23:03:02.768229338 -0700
@@ -100,7 +100,7 @@
 	(...)
 	i2c_adap = i2c_get_adapter(2);
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(i2c_info.name, "isp1301_pnx", I2C_NAME_SIZE);
+	strlcpy(i2c_info.type, "isp1301_pnx", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
 						   normal_i2c);
 	i2c_put_adapter(i2c_adap);
