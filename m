Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3AHGHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 01:07:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:49720 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab3AHGHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 01:07:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,428,1355126400"; 
   d="scan'208,223";a="274112385"
From: "Zhang, YiX X" <yix.x.zhang@intel.com>
To: "cjb@laptop.org" <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule comment
Thread-Topic: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule comment
Thread-Index: Ac3tZl7MWYZmSAgkROiKKbFrSa0WVg==
Date: Tue, 8 Jan 2013 06:07:39 +0000
Message-ID: <1A230AD7863570458C6CF2BE7CD6618B102BE5CB@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From aaea3405944d844f53679b295d4082584f33d9a3 Mon Sep 17 00:00:00 2001
From: ZhangYi <yix.x.zhang@intel.com>
Date: Tue, 8 Jan 2013 13:50:09 +0800
Subject: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule comment

The right value is 54 according to eMMC 4.5 specification.

Signed-off-by: ZhangYi <yix.x.zhang@intel.com>
---
 include/linux/mmc/card.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 5c69315..ffde1d3 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -83,7 +83,7 @@ struct mmc_ext_csd {
 	unsigned int            data_tag_unit_size;     /* DATA TAG UNIT size */
 	unsigned int		boot_ro_lock;		/* ro lock support */
 	bool			boot_ro_lockable;
-	u8			raw_exception_status;	/* 53 */
+	u8			raw_exception_status;	/* 54 */
 	u8			raw_partition_support;	/* 160 */
 	u8			raw_rpmb_size_mult;	/* 168 */
 	u8			raw_erased_mem_count;	/* 181 */
-- 
1.7.0.4

