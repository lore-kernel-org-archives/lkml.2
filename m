Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1LAWb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:31:27 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53383
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754710Ab1LAWb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:31:26 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: =?UTF-8?q?=5BPATCH=201/1=5D=20hv=3A=20Update=20MAINTAINERS?=
Date: Thu,  1 Dec 2011 14:31:30 -0800
Message-Id: <1322778690-17381-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the MAINTAINERS file to reflect the current state
of the Hyper-V drivers.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 MAINTAINERS |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3523ab0..809cad8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3197,6 +3197,16 @@ M:	William Irwin <wli@holomorphy.com>
 S:	Maintained
 F:	fs/hugetlbfs/
 
+Hyper-V CORE AND DRIVERS
+M:	K. Y. Srinivasan <kys@microsoft.com>
+M:	Haiyang Zhang <haiyangz@microsoft.com>
+L:	devel@linuxdriverproject.org
+S:	Maintained
+F:	drivers/hv/
+F:	drivers/hid/hid-hyperv.c
+F:	drivers/net/hyperv/
+F:	drivers/staging/hv/
+
 I2C/SMBUS STUB DRIVER
 M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	linux-i2c@vger.kernel.org
@@ -6322,12 +6332,6 @@ M:	David Täht <d@teklibre.com>
 S:	Odd Fixes
 F:	drivers/staging/frontier/
 
-STAGING - HYPER-V (MICROSOFT)
-M:	Hank Janssen <hjanssen@microsoft.com>
-M:	Haiyang Zhang <haiyangz@microsoft.com>
-S:	Odd Fixes
-F:	drivers/staging/hv/
-
 STAGING - INDUSTRIAL IO
 M:	Jonathan Cameron <jic23@cam.ac.uk>
 L:	linux-iio@vger.kernel.org
-- 
1.7.4.1

