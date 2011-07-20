Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1GTXFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 19:05:33 -0400
Received: from csmtp2.one.com ([91.198.169.22]:47570 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab1GTXFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 19:05:31 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCH v4 0/1] input: add driver for Bosch Sensortec's BMA150 accelerometer
Date: Thu, 21 Jul 2011 01:09:18 +0200
Message-Id: <1311203359-23779-1-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added correct versioning of this patch! Please ignore my previous post and sorry
for being trigger happy!

This is version 4 of the driver for Bosch Sensortec's accelerometers BMA150
and SMB380.

I didn't really get an ack on my suggestions in the previous version, but I
hope that this version covers the comments and suits your needs.

Here is the changelog:
* community review: added bma023 client id.
* community review: added irq handling for any-motion and high/low G
  interrupts.
* Added platfrom data struct for chip-configuration parameters.
* Removed the sysfs interfaces. These parameters are set through platform data instead.
* Removed pm_runtime, not needed if no sysfs interfaces.
* Populated default interrupt configurations as recommended by Bosch Sensortec.

--
Best regards,
 Eric

http://www.unixphere.com


Eric Andersson (1):
  input: add driver for Bosch Sensortec's BMA150 accelerometer

 drivers/input/misc/Kconfig  |   11 +
 drivers/input/misc/Makefile |    1 +
 drivers/input/misc/bma150.c |  598 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/bma150.h      |   62 +++++
 4 files changed, 672 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/bma150.c
 create mode 100644 include/linux/bma150.h

-- 
1.7.3.4

