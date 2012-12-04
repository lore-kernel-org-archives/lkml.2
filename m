Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab2LDKof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:44:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36090 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab2LDKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:44:34 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, zach.pfeffer@linaro.org, Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 0/2] Android: Add support for a 32bit Android file system in a 64bit kernel
Date: Tue,  4 Dec 2012 10:44:12 +0000
Message-Id: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following set of patches will provide support for a 32-bit Android file
system running on top of 64-bit kernel. We have tested them successfully on
64-bit platforms (Real Time Simulation Model ARMv8) as well as on 32-bit ones
(4xA9 Versatile Express). For RTSMv8 we have been using 64-bit kernel build,
running the CPU in the AArch64 state, and an ARMv7 file system build, running
in AArch32 state of ARMv8.

Please take a look and let me know if you have any feedback.

Note: This set of patches will affect only an Android build of the Linux
kernel, the drivers(binder, ashmem) are not pulled in for a default Linux
build.

Best Regards,
Serban Constantinescu
PDSW Engineer ARM Ltd.

Serban Constantinescu (2):
  Staging: android: binder: Add support for 32bit binder calls in a
    64bit kernel
  Staging: android: ashmem: Add support for 32bit ashmem calls in a
    64bit kernel

 drivers/staging/android/ashmem.c |   60 +++++---
 drivers/staging/android/ashmem.h |    6 +-
 drivers/staging/android/binder.c |  298 ++++++++++++++++++++------------------
 drivers/staging/android/binder.h |   56 +++----
 4 files changed, 233 insertions(+), 187 deletions(-)

-- 
1.7.9.5

