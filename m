Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2IMFcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 01:32:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18541 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2IMFcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 01:32:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 12 Sep 2012 22:32:18 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] arm: tegra: fixing compilation error
Date: Thu, 13 Sep 2012 10:46:25 +0530
Message-ID: <1347513385-14158-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As usb_phy.h got moved from mach to include/linux/usb
and renamed as tegra_usb_phy.h, correcting it in the include
path.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index adc6b98..3308a65 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -41,7 +41,7 @@
 
 #include <mach/iomap.h>
 #include <mach/irqs.h>
-#include <mach/usb_phy.h>
+#include <linux/usb/tegra_usb_phy.h>
 
 #include "board.h"
 #include "clock.h"
-- 
1.7.1.1

