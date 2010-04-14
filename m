Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0DNNYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:24:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34971 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750939Ab0DNNYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:24:08 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/4] Various intel small device drivers
To: linux-i2c@vger.kernel.org, khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 14 Apr 2010 13:51:30 +0100
Message-ID: <20100414124913.23181.75903.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These have been through my clean up processing, in particular the accelerometers
are now using the input layer infrastructure.


---

Kalhan Trisal (4):
      emc1403: thermal sensor support
      liss331d1: accelerometer driver
      isl29020: ambient light sensor
      hmc6352: Add driver for the HMC6352 compass


 drivers/hwmon/Kconfig    |   34 ++++
 drivers/hwmon/Makefile   |    4 
 drivers/hwmon/emc1403.c  |  437 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/hmc6352.c  |  235 +++++++++++++++++++++++++
 drivers/hwmon/isl29020.c |  243 ++++++++++++++++++++++++++
 drivers/hwmon/lis331dl.c |  286 ++++++++++++++++++++++++++++++
 6 files changed, 1239 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/emc1403.c
 create mode 100644 drivers/hwmon/hmc6352.c
 create mode 100644 drivers/hwmon/isl29020.c
 create mode 100644 drivers/hwmon/lis331dl.c

-- 
