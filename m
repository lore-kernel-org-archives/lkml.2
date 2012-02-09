Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab2BIXss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:48:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18258 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab2BIXsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:48:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 09 Feb 2012 15:48:42 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/10] ARM: tegra: export Tegra chipid
Date: Fri, 10 Feb 2012 01:47:42 +0200
Message-Id: <1328831277-21002-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powergating and reset handling code needs to differentiate between Tegra
variants. Therefore we export the chipid here.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/fuse.c |    2 +-
 arch/arm/mach-tegra/fuse.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index 032a936..3298880 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -34,7 +34,7 @@
 int tegra_sku_id;
 int tegra_cpu_process_id;
 int tegra_core_process_id;
-static int tegra_chip_id;
+int tegra_chip_id;
 enum tegra_revision tegra_revision;
 
 /* The BCT to use at boot is specified by board straps that can be read
diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
index c554572..d2107b2 100644
--- a/arch/arm/mach-tegra/fuse.h
+++ b/arch/arm/mach-tegra/fuse.h
@@ -41,6 +41,7 @@ enum tegra_revision {
 extern int tegra_sku_id;
 extern int tegra_cpu_process_id;
 extern int tegra_core_process_id;
+extern int tegra_chip_id;
 extern enum tegra_revision tegra_revision;
 
 extern int tegra_bct_strapping;
-- 
1.7.4.1

