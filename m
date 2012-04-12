Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905Ab2DLOMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:12:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18714 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934057Ab2DLOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:12:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 12 Apr 2012 07:12:43 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, jbrenner@taosinc.com, rklein@nvidia.com,
        max@stro.at
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4 0/2] staging: iio: add isl29028 driver
Date: Thu, 12 Apr 2012 19:31:04 +0530
Message-Id: <1334239266-29505-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
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

