Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab2IXIOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:14:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:39575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab2IXIOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:14:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,474,1344236400"; 
   d="scan'208";a="225661415"
Message-ID: <5060164A.5070708@linux.intel.com>
Date: Mon, 24 Sep 2012 16:14:02 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120306 Thunderbird/3.1.20
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>,
        Takahiroi Shimizu <tshimizu818@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        haicheng.lee@gmail.com
Subject: [Updated PATCH 2/2] Fix a typo in PTP_1588_CLOCK_PCH Kconfig help
 info.
References: <506009A4.8000202@linux.intel.com> <50600A49.7040902@linux.intel.com>
In-Reply-To: <50600A49.7040902@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pls. ignore original one, and use this instead:

 From 5911413366d37aafcc19ddfc9c0f2db31855431e Mon Sep 17 00:00:00 2001
From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Mon, 24 Sep 2012 15:55:27 +0800
Subject: [PATCH 2/2] Fix a typo in PTP_1588_CLOCK_PCH Kconfig help info.

Signed-off-by: Haicheng Li <haicheng.lee@gmail.com>
---
  drivers/ptp/Kconfig |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index ffdf712..82c4a26 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -87,6 +87,6 @@ config PTP_1588_CLOCK_PCH
  	  SO_TIMESTAMPING API.

  	  To compile this driver as a module, choose M here: the module
-	  will be called ptp_pch.
+	  will be called by pch_ptp.

  endmenu
-- 
1.7.1
