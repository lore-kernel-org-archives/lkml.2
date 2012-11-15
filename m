Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab2KOV23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:28:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2KOV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:28:28 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dave Airlie <airlied@redhat.com>
Cc: Rob Clark <rob@ti.com>, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] NVIDIA Tegra DRM driver
Date: Thu, 15 Nov 2012 22:28:21 +0100
Message-Id: <1353014903-17429-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:NsRXl4zkgdiACBkYVL+O/rggBOamo19TV44TojyVVGo
 5sHaG9Fr/OXrNh0PuPjEB36BGkIaj+tJ0GaNn2CqbcWThKsLOJ
 oBIJYrhV7HiC5VcUaSOCvuc58LqmeJAxKolRgKQB6ZD5uLMfu9
 rV78ipBvScEMMhdeDaBdUB9XUHYExxQxzrJMWdW4K1RyWrrMib
 aNLTej6pXDVBluW4gskoXmKPthtEtPch1vizbCu2IWt7hqGbTu
 9uNgPsK9Rv3YVFGjpRc3sWJFZBp81xxMc/RxkLXmIK/yci5J1v
 Antmak4+nXcBMCWBRKGceSgojUrvlV8TMde7ZnC6fS863usuhG
 vOnG2/rkDQ5mv4+fxgL3nW/LTimQo7vwuFr5dvWY4sOIJTZ1Yt
 5SneBUaVlZ+Yl3n22VfcVIyK4KoCzqPos/W0Q6zheUxj4oejAS
 EKM+x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This third version of the patch series cleans up some minor issues that
were found in the previous versions, such as deferred probe not working
properly and the display remaining enabled after the driver is removed.

I've also put the two patches in this series into the tegra/drm/for-3.8
branch of my repository on gitorious[0].

Thierry

[0]: git://gitorious.org/thierryreding/linux.git

Thierry Reding (2):
  drm: Add NVIDIA Tegra20 support
  drm: tegra: Add HDMI support

 .../bindings/gpu/nvidia,tegra20-host1x.txt         |  191 +++
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    1 +
 drivers/gpu/drm/tegra/Kconfig                      |   23 +
 drivers/gpu/drm/tegra/Makefile                     |    7 +
 drivers/gpu/drm/tegra/dc.c                         |  833 ++++++++++++
 drivers/gpu/drm/tegra/dc.h                         |  388 ++++++
 drivers/gpu/drm/tegra/drm.c                        |  115 ++
 drivers/gpu/drm/tegra/drm.h                        |  234 ++++
 drivers/gpu/drm/tegra/fb.c                         |   56 +
 drivers/gpu/drm/tegra/hdmi.c                       | 1334 ++++++++++++++++++++
 drivers/gpu/drm/tegra/hdmi.h                       |  575 +++++++++
 drivers/gpu/drm/tegra/host1x.c                     |  322 +++++
 drivers/gpu/drm/tegra/output.c                     |  272 ++++
 drivers/gpu/drm/tegra/rgb.c                        |  228 ++++
 15 files changed, 4581 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
 create mode 100644 drivers/gpu/drm/tegra/Kconfig
 create mode 100644 drivers/gpu/drm/tegra/Makefile
 create mode 100644 drivers/gpu/drm/tegra/dc.c
 create mode 100644 drivers/gpu/drm/tegra/dc.h
 create mode 100644 drivers/gpu/drm/tegra/drm.c
 create mode 100644 drivers/gpu/drm/tegra/drm.h
 create mode 100644 drivers/gpu/drm/tegra/fb.c
 create mode 100644 drivers/gpu/drm/tegra/hdmi.c
 create mode 100644 drivers/gpu/drm/tegra/hdmi.h
 create mode 100644 drivers/gpu/drm/tegra/host1x.c
 create mode 100644 drivers/gpu/drm/tegra/output.c
 create mode 100644 drivers/gpu/drm/tegra/rgb.c

-- 
1.8.0

