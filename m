Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2IXHWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:22:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:10088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab2IXHWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:22:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,474,1344236400"; 
   d="scan'208,223";a="225855740"
Message-ID: <50600A49.7040902@linux.intel.com>
Date: Mon, 24 Sep 2012 15:22:49 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120306 Thunderbird/3.1.20
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>
CC: Takahiroi Shimizu <tshimizu818@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        haicheng.lee@gmail.com
Subject: [PATCH 2/2] Fix wrong description in PTP_1588_CLOCK_PCH help info.
References: <506009A4.8000202@linux.intel.com>
In-Reply-To: <506009A4.8000202@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From a206a006d82c327ba308674c608fbd6c9ce1e702 Mon Sep 17 00:00:00 2001
From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Mon, 24 Sep 2012 15:02:41 +0800
Subject: [PATCH 2/2] Fix wrong description in PTP_1588_CLOCK_PCH help info.

Signed-off-by: Haicheng Li <haicheng.lee@gmail.com>
---
  drivers/ptp/Kconfig |    3 +--
  1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index ffdf712..988786d 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -86,7 +86,6 @@ config PTP_1588_CLOCK_PCH
  	  hardware time stamps on the PTP Ethernet packets using the
  	  SO_TIMESTAMPING API.

-	  To compile this driver as a module, choose M here: the module
-	  will be called ptp_pch.
+	  Choose Y here if you want to enable PCH PTP clock support.

  endmenu
-- 
1.7.1

