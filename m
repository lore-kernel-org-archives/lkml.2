Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2KQK4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 05:56:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50221 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab2KQK4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 05:56:10 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCHv9 3/3] Take maintainership of power sequences
Date: Sat, 17 Nov 2012 19:55:47 +0900
Message-Id: <1353149747-31871-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entry for power sequences into MAINTAINERS with all the needed
contact and SCM info.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb0b27d..e9098f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5745,6 +5745,16 @@ F:	fs/timerfd.c
 F:	include/linux/timer*
 F:	kernel/*timer*
 
+POWER SEQUENCES
+M:	Alexandre Courbot <acourbot@nvidia.com>
+S:	Supported
+W:	https://github.com/Gnurou/linux
+T:	git git://github.com/Gnurou/linux.git power-seq/for-next
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

