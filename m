Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2FTITr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:19:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:38872 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab2FTITn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:19:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="155889876"
From: "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Subject: [PATCH V2 2/2] Documentation: sysfs for Physical Presence Interface
Thread-Topic: [PATCH V2 2/2] Documentation: sysfs for Physical Presence
 Interface
Thread-Index: Ac1OvW/i/lznAHP2Rm6FNMU+myxHhA==
Date: Wed, 20 Jun 2012 08:19:39 +0000
Message-ID: <1340122655.8068.5.camel@localhost>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.48.101]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5K8Jr7C000889

From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>

Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-ppi |   70 ++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ppi

diff --git a/Documentation/ABI/testing/sysfs-driver-ppi b/Documentation/ABI/testing/sysfs-driver-ppi
new file mode 100644
index 0000000..5da9acd
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ppi
@@ -0,0 +1,70 @@
+What:		/sys/devices/pnp0/<bus-num>/ppi/
+Date:		June 2012
+Kernel Version:	3.4
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This folder includes the attributes related with PPI (Physical
+		Presence Interface). Only if TPM is supported by BIOS, this
+		folder makes sence. The folder path can be got by command
+		'find /sys/ -name 'pcrs''. For the detail information of PPI,
+		please refer to the PPI specification from
+		http://www.trustedcomputinggroup.org/
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/version
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the version of the PPI supported by the
+		platform.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/request
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the request for an operation to be
+		executed in the pre-OS environment. It is the only input from
+		the OS to the pre-OS environment. The request should be an
+		integer value range from 1 to 160, and 0 means no request.
+		This file can be read and written.
+
+What:		/sys/devices/pnp0/00:<bus-num>/ppi/response
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the response to the most recent operation
+		request it acted upon. The format is "<request> <response num>
+		: <response description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/transition_action
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the platform-specific action that should
+		take place in order to transition to the BIOS for execution of
+		a requested operation. The format is "<action num>: <action
+		description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/tcg_operations
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the requests defined by TCG, i.e. requests from 1 to 22.
+		The format is "<request> <status num>: <status description>".
+		This attribute is only supported by PPI version 1.2+.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/vs_operations
+Date:		June 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the verdor specific requests, i.e. requests from 128 to
+		255. The format is same with tcg_operations. This attribute
+		is also only supported by PPI version 1.2+.
+		This file is readonly.
-- 
1.7.6.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
