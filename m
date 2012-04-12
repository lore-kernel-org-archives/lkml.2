Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106Ab2DLHTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:19:52 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12124 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab2DLHTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:19:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Apr 2012 00:19:46 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, jbrenner@taosinc.com, rklein@nvidia.com,
        max@stro.at
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/2] staging: iio: add isl29028 driver
Date: Thu, 12 Apr 2012 12:38:10 +0530
Message-Id: <1334214492-23044-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISL29028 is concurrent Ambient light and proximity sensor
from intersil.
Adding driver for supporting this device.

Also adding details of interface proximity_sampling_period
in documentation.

Laxman Dewangan (2):
  staging: iio: add driver for isl29028
  staging: Documentation: add proximity_sampling_period as sysfs
    details

 .../staging/iio/Documentation/sysfs-bus-iio-light  |    7 +
 drivers/staging/iio/light/Kconfig                  |   10 +
 drivers/staging/iio/light/Makefile                 |    1 +
 drivers/staging/iio/light/isl29028.c               |  566 ++++++++++++++++++++
 4 files changed, 584 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/light/isl29028.c

