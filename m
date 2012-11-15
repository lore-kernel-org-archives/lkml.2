Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946027Ab2KOA6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:58:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:10409 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab2KOA6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:58:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,254,1352102400"; 
   d="scan'208";a="249300160"
Message-ID: <1352941107.2143.12.camel@rzhang1-mobl4>
Subject: [PATCH] Thermal: Add Linux/Thermal subsystem info in MAINTAINER file
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        durga <durgadoss.r@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>,
        Amit Kachhap <amit.kachhap@linaro.org>, jhbird.choi@samsung.com,
        kuninori.morimoto.gx@renesas.com, eduardo.valentin@ti.com,
        "hongbo.zhang" <hongbo.zhang@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Date: Thu, 15 Nov 2012 08:58:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Linux/Thermal subsystem info in MAINTAINER file.

All the changes made to the generic thermal layer, or
platform thermal drivers that make use of the thermal layer,
should be sent to linux-pm@vger.kernel.org for discussion.

And as the maintainer, I will only apply the patches that have been
sent to linux-pm@vger.kernel.org.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 59203e7..2d8512b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7210,6 +7210,14 @@ L:	linux-xtensa@linux-xtensa.org
 S:	Maintained
 F:	arch/xtensa/
 
+THERMAL
+M:      Zhang Rui <rui.zhang@intel.com>
+L:      linux-pm@vger.kernel.org
+T:      git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
+S:      Supported
+F:      drivers/thermal/
+F:      include/linux/thermal.h
+
 THINKPAD ACPI EXTRAS DRIVER
 M:	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
 L:	ibm-acpi-devel@lists.sourceforge.net
-- 
1.7.9.5



