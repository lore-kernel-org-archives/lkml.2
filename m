Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946039Ab2E0BVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:21:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946005Ab2E0BU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:20:57 -0400
Message-Id: <20120527002525.891696936@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:34 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Warren <swarren@nvidia.com>
Subject: [ 88/91] ARM: dt: tegra cardhu: fix typo in SDHCI node name
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 1dfebb426cfd16e2080f8c95e00ca2462f2325d4 upstream.

Cardhu's eMMC controller is on sdhci@78000600, not sdhci@78000400.
Fix the typo. This roughly doubles the IO performance, since the
support-8bit property actually takes effect.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/tegra-cardhu.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/tegra-cardhu.dts
+++ b/arch/arm/boot/dts/tegra-cardhu.dts
@@ -64,7 +64,7 @@
 		status = "disable";
 	};
 
-	sdhci@78000400 {
+	sdhci@78000600 {
 		support-8bit;
 	};
 };


