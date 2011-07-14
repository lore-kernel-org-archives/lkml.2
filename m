Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1GNVwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:52:46 -0400
Received: from csmtp2.one.com ([91.198.169.22]:21405 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab1GNVwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:52:45 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCH v3 0/1] input: add driver for Bosch Sensortec's BMA150 accelerometer
Date: Thu, 14 Jul 2011 23:56:11 +0200
Message-Id: <1310680572-27410-1-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 3 of the driver for Bosch Sensortec's accelerometers BMA150
and SMB380.

Since last time around, the following has happened:
* community review: Register the driver as a input_polled_device.
* community review: added runtime_pm support.
* community review: removed sysfs enable node
* community review: removed the value sysfs node
* community review: rephrased delay sysfs description
* Removed mode sysfs node
* Removed delay sysfs node
* Listed both bma150 & smb380 as supported i2c device id's.
* Added hw initialization function which will be called upon probing.
* Added soft reset function to be called from the probe.
* Minor consistency changes.

-- 
Best regards,
 Eric

 http://www.unixphere.com


Eric Andersson (1):
  input: add driver for Bosch Sensortec's BMA150 accelerometer

 Documentation/ABI/testing/sysfs-i2c-bma150 |   22 +
 drivers/input/misc/Kconfig                 |   11 +
 drivers/input/misc/Makefile                |    1 +
 drivers/input/misc/bma150.c                |  577 ++++++++++++++++++++++++++++
 4 files changed, 611 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-i2c-bma150
 create mode 100644 drivers/input/misc/bma150.c

-- 
1.7.3.4

