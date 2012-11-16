Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab2KPGjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:39:24 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7671 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2KPGjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:39:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 15 Nov 2012 22:38:56 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <l.krishna@samsung.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-pm@vger.kernel.org>, Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v8 3/3] Take maintainership of power sequences
Date: Fri, 16 Nov 2012 15:38:23 +0900
Message-ID: <1353047903-14363-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entry for power sequences into MAINTAINERS with all the needed
contact and SCM info.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 59203e7..c86a93b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5696,6 +5696,16 @@ F:	fs/timerfd.c
 F:	include/linux/timer*
 F:	kernel/*timer*
 
+POWER SEQUENCES
+M:	Alexandre Courbot <acourbot@nvidia.com>
+S:	Maintained
+W:	https://github.com/Gnurou/linux-power-seqs
+T:	git https://github.com/Gnurou/linux-power-seqs.git
+F:	Documentation/devicetree/bindings/power/power_seq.txt
+F:	Documentation/power/power_seq.txt
+F:	include/linux/power_seq.h
+F:	drivers/power/power_seq/
+
 POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
 M:	Anton Vorontsov <cbou@mail.ru>
 M:	David Woodhouse <dwmw2@infradead.org>
-- 
1.8.0

