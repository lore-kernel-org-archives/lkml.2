Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2K1TSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:18:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58151 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab2K1TSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:18:50 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dave Airlie <airlied@redhat.com>
Cc: Joe Perches <joe@perches.com>, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] drm: tegra: Add maintainers entry
Date: Wed, 28 Nov 2012 20:18:42 +0100
Message-Id: <1354130322-24509-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0.1
X-Provags-ID: V02:K0:VNVmMsKd1t/pv15ZlJNZbocZogJigjR7T5ssHOZPDwi
 5CW88XfBGKmvf9+kvLqK+8UMMvIoTE6tX2eFbWJcqu54aH9vXq
 aPxIXt59rKuUgrX6+S+BqRw33kWdCAdCjG0ZzBtZ1n2fFhPIP4
 tlhrlX/cisEk0mP/Ldgi5kOjk4OPD1tBuIfrXeng6psr3YUS8V
 RmQiVHkEkdCedW8Vd4UhlqXtde3K82Pv3QJJpNrLP+vZNRKHnI
 vdpzK/ddZXYemjsRADfKNSTI9TefqIHKI7GokZTYRWcSkiGT1u
 iKphwHEjiImCuzJUs7PFsN25mVMEp2IpK6CslVlnIkduPkUmL5
 75R4TrQGHLkRpn+3D0lWoI2tJxNUtygXBGkXOhrMuCSQ/KVtsX
 E+lxkxF6ZfUcIXFgtvWQ2LidEwXiLqNl0LU5EcLmGwtn1MwimH
 JCqNi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as the maintainer of the NVIDIA Tegra DRM driver.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- insert entry in alphabetical order
- fix reference to driver directory
- fix reference to git tree

 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0cfc0f1..b085409 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2549,6 +2549,14 @@ S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
 
+DRM DRIVERS FOR NVIDIA TEGRA
+M:	Thierry Reding <thierry.reding@avionic-design.de>
+L:	dri-devel@lists.freedesktop.org
+T:	git git://gitorious.org/thierryreding/linux.git
+S:	Maintained
+F:	drivers/gpu/drm/tegra/
+F:	Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
+
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
-- 
1.8.0.1

