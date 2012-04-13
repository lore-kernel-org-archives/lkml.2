Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935155Ab2DMKpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:45:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1332 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab2DMKpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:45:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 13 Apr 2012 03:45:22 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <jic23@cam.ac.uk>, <gregkh@linuxfoundation.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <jbrenner@taosinc.com>, <rklein@nvidia.com>, <max@stro.at>
CC: <linux-iio@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V5 0/2] staging: iio: add isl29028 driver
Date: Fri, 13 Apr 2012 16:03:30 +0530
Message-ID: <1334313212-23618-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISL29028 is concurrent Ambient light and proximity sensor
from intersil.
Adding driver for supporting this device.

Changes from V1: 
- Taken care of cleanups comments.

Changes from V2: 
- Implement the sampling frequency selection per channel wise.
- Remove documentation change as it is already there.
- Use the channel info for selecting proximity sampling rather than
  exposing new sysfs from driver.

Changes from V3:
- change samp_freq to sampling_frequency
- Remove sysfs range  and add scale through channel info.

Changed from V4: 
- Changed ISL29028_MAX_REGS  macro to ISL29028_NUM_REGS
- Changed *_available attribute inline with their corresponding attr.

Laxman Dewangan (2):
  staging: iio: add channel info for sampling frequency
  staging: iio: add driver for isl29028

 drivers/staging/iio/iio.h               |    5 +
 drivers/staging/iio/industrialio-core.c |    1 +
 drivers/staging/iio/light/Kconfig       |   10 +
 drivers/staging/iio/light/Makefile      |    1 +
 drivers/staging/iio/light/isl29028.c    |  563 +++++++++++++++++++++++++++++++
 5 files changed, 580 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/light/isl29028.c

