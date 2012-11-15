Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083Ab2KOVUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:20:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2KOVUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:20:47 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] Device tree updates for host1x support
Date: Thu, 15 Nov 2012 22:07:53 +0100
Message-Id: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:U3b7waTu6UzUH/CbsicxPlnYRlF4fQCtW5uM+vVXQVA
 e66/E+mOMjUPvTS599UTF4PcC6roDPI3lBM1gmtbfLD/WHYD3T
 /Wcd9TGp2X09QurKJ5T7sUNPA+5EkaQFyZphYSUOLo5Gjknmns
 mFxCGssR6fai2tYQbK1XujA+kIR7Eye5cB4VYkxAJNkQf9av8l
 xGTPYnsQ/iBnsBh+aecksM4xSS3Nhm8M7u0WOhbo3Nd0TZP2wM
 NMJpI7o1+0456kTzkaolMnVymJCYne2/pyNXzCdSpHoHFOFMfU
 G6pR9PKPcczaQTI72t7DUsBd3yxpYO+vc4yLumi+HPu7UDw7vq
 +j05iCeVWreu5JAdaOeZX0TK+q5hqM6WqYenjIVAjeIVjY5nxi
 fgZzVr49lK0Cw0pgmnfCpbmErBOLimF4bRjbj7Fr4oSdZahBog
 JZAfY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This second version of this patch series splits the patches up into more
logical chunks as requested by Stephen. Instead of renaming the matching
parameters in the clock driver, this version renames the AUXDATA entries
to match what the clock driver expects. Furthermore the host1x clock is
initialized to 150 MHz instead of the unsupported 144 MHz.

Thierry

Thierry Reding (6):
  ARM: tegra: Add Tegra20 host1x support
  ARM: tegra: Add AUXDATA for Tegra20 host1x
  ARM: tegra: Add Tegra20 host1x clock support
  ARM: tegra: Add Tegra30 host1x support
  ARM: tegra: Add AUXDATA for Tegra30 host1x
  ARM: tegra: Add Tegra30 host1x clock support

 arch/arm/boot/dts/tegra20.dtsi            | 87 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra30.dtsi            | 87 +++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/board-dt-tegra20.c    |  9 ++++
 arch/arm/mach-tegra/board-dt-tegra30.c    |  9 ++++
 arch/arm/mach-tegra/tegra20_clocks_data.c | 11 ++--
 arch/arm/mach-tegra/tegra30_clocks_data.c |  5 +-
 6 files changed, 203 insertions(+), 5 deletions(-)

-- 
1.8.0

