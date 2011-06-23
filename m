Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab1FWOhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:37:46 -0400
Received: from csmtp2.one.com ([91.198.169.22]:44828 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab1FWOhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:37:45 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCH v2 0/1] input: add driver for Bosch Sensortec's BMA150 accelerometer
Date: Thu, 23 Jun 2011 16:40:26 +0200
Message-Id: <1308840027-10724-1-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v2 of the bma150 driver for Bosch sensortec's digital accelerometers
BMA150 and SMB380.

So, what happend since last time:
* community review: fixed smbus locking.
* community review: removed pointless ifs.
* community review: removed struct bma150acc.
* community review: use human readable values for the sysfs interface.
* community review: removed atomic_t for delay.
* Updated header with SMB380 information.
* Use standard format to print accelerometer data, i.e. (x,y,z).
* Updated string format of sysfs parameters to: value1 [value2] value3...
* Add enable/disable as sysfs parameter.
* Added sysfs-i2c-bma150 ABI documentation.

Best regards,
 Eric

 http://www.unixphere.com

---

Eric Andersson (1):
  input: add driver for Bosch Sensortec's BMA150 accelerometer

 Documentation/ABI/testing/sysfs-i2c-bma150 |   71 +++
 drivers/input/misc/Kconfig                 |   10 +
 drivers/input/misc/Makefile                |    1 +
 drivers/input/misc/bma150.c                |  684 ++++++++++++++++++++++++++++
 4 files changed, 766 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-i2c-bma150
 create mode 100644 drivers/input/misc/bma150.c

-- 
1.7.3.4

