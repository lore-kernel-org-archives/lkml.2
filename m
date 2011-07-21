Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1GUUuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:50:18 -0400
Received: from csmtp1.one.com ([195.47.247.21]:17493 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab1GUUuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:50:16 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jul 2011 16:50:16 EDT
From: Eric Andersson <eric.andersson@unixphere.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCH v5 0/1] input: add driver for Bosch Sensortec's BMA150 accelerometer
Date: Thu, 21 Jul 2011 22:47:47 +0200
Message-Id: <1311281268-9498-1-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 5 of the driver for Bosch Sensortec's accelerometers BMA150
and SMB380.

Only minor changes in this version based on the review comments:
* community review: re-introduced pm runtime.
* community review: put msleep inside mutex for set_mode.
* Fixed a checkpatch error.

--
Best regards,
 Eric

 http://www.unixphere.com

Eric Andersson (1):
  input: add driver for Bosch Sensortec's BMA150 accelerometer

 drivers/input/misc/Kconfig  |   11 +
 drivers/input/misc/Makefile |    1 +
 drivers/input/misc/bma150.c |  667 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/bma150.h      |   64 ++++
 4 files changed, 743 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/bma150.c
 create mode 100644 include/linux/bma150.h

-- 
1.7.3.4

