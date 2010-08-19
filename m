Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0HSRh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:37:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:4185 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0HSRh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:37:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,234,1280732400"; 
   d="scan'208";a="546877084"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Rudolf Marek" <r.marek@assembler.cz>,
        "Huaxu Wan" <huaxu.wan@intel.com>, "H Peter Anvin" <hpa@zytor.com>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>,
        "Jean Delvare" <khali@linux-fr.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] MAINTAINERS: hwmon/coretemp: Change coretemp maintainers
Date: Thu, 19 Aug 2010 10:28:16 -0700
Message-Id: <1282238896-23026-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Huaxu and Rudolf want me to be the hwmon coretemp driver maintainer and remove
their names from the coretemp maintainer entry.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Rudolf Marek <r.marek@assembler.cz>
Acked-by: Huaxu Wan <huaxu.wan@intel.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b5b8baa..ff0cd1e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1665,8 +1665,7 @@ F:	kernel/cgroup*
 F:	mm/*cgroup*
 
 CORETEMP HARDWARE MONITORING DRIVER
-M:	Rudolf Marek <r.marek@assembler.cz>
-M:	Huaxu Wan <huaxu.wan@intel.com>
+M:	Fenghua Yu <fenghua.yu@intel.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/coretemp
-- 
1.6.0.3

