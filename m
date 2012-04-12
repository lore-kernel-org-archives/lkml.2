Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130Ab2DLHUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:20:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12169 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab2DLHUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:20:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 12 Apr 2012 00:20:01 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, jbrenner@taosinc.com, rklein@nvidia.com,
        max@stro.at
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/2] staging: Documentation: add proximity_sampling_period as sysfs details
Date: Thu, 12 Apr 2012 12:38:12 +0530
Message-Id: <1334214492-23044-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1334214492-23044-1-git-send-email-ldewangan@nvidia.com>
References: <1334214492-23044-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the sysfs proximity_sampling_period for sampling period of
proximity sensing.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 .../staging/iio/Documentation/sysfs-bus-iio-light  |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
index edbf470..9d6108b 100644
--- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
+++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
@@ -83,3 +83,10 @@ Description:
 		Hardware or software applied calibration scale factor assumed
 		to account for attenuation due to industrial design (glass
 		filters or aperture holes).
+
+What:		/sys/bus/iio/devices/device[n]/proximity_sampling_period
+KernelVersion:	3.5
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Hardware dependent mode for proximity sensor device to set/get
+		the sampling rate of proximity sensing and conversion.
-- 
1.7.1.1

