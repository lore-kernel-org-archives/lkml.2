Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1G0EFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:05:41 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36963 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790Ab1G0EFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:05:38 -0400
X-Sasl-enc: HSwQm3Yjvf9zbZLIf7LECC3YGxZVloLxS6+AcRYG+wdJ 1311739537
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/11] driver-core: modify FIRMWARE_IN_KERNEL help message
Date: Tue, 26 Jul 2011 21:05:15 -0700
Message-Id: <1311739521-11014-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311739521-11014-1-git-send-email-gregkh@suse.de>
References: <20110726045707.GA2321@kroah.com>
 <1311739521-11014-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

The help message for the configuration variable was inconsistent
with the way "make firmware_install" really works.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 5fe7fd2..52c6758 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -84,10 +84,10 @@ config FIRMWARE_IN_KERNEL
 	help
 	  The kernel source tree includes a number of firmware 'blobs'
 	  that are used by various drivers. The recommended way to
-	  use these is to run "make firmware_install" and to copy the
-	  resulting binary files created in usr/lib/firmware/ of the
-	  kernel tree to /lib/firmware/ on your system so that they can
-	  be loaded by userspace helpers on request.
+	  use these is to run "make firmware_install", which, after
+	  converting ihex files to binary, copies all of the needed
+	  binary files in firmware/ to /lib/firmware/ on your system so
+	  that they can be loaded by userspace helpers on request.
 
 	  Enabling this option will build each required firmware blob
 	  into the kernel directly, where request_firmware() will find
-- 
1.7.6

