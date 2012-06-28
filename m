Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2F1RVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:21:04 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:38870 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054Ab2F1RUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:20:47 -0400
From: Kevin Hilman <khilman@ti.com>
To: arm@kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cpufreq@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add OMAP CPUfreq driver to OMAP Power Management section
Date: Thu, 28 Jun 2012 10:20:21 -0700
Message-Id: <1340904021-25872-1-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the OMAP CPUFreq driver to the list of files in the OMAP Power
Management section.

I've already been maintaining this driver, this just makes it
official.

Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55f0fda..bee9d2e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4836,6 +4836,7 @@ M:	Kevin Hilman <khilman@ti.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*pm*
+F:	drivers/cpufreq/omap-cpufreq.c
 
 OMAP POWERDOMAIN/CLOCKDOMAIN SOC ADAPTATION LAYER SUPPORT
 M:	Rajendra Nayak <rnayak@ti.com>
-- 
1.7.9.2

