Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab2DKRja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:39:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19488 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab2DKRj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:39:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 11 Apr 2012 10:39:25 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, jbrenner@taosinc.com, rklein@nvidia.com,
        max@stro.at
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1 0/2] staging: iio: add isl29028 driver
Date: Wed, 11 Apr 2012 22:58:02 +0530
Message-Id: <1334165284-11326-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISL29028 is concurrent Ambient light and proximity sensor from intersil.
Adding driver for supporting this device.

Also adding details of interface roximity_sampling_period in documentation.

Laxman Dewangan (2):
  staging: iio: add driver for isl29028
  staging: Documentation: add proximity_sampling_period as sysfs
    details

 .../staging/iio/Documentation/sysfs-bus-iio-light  |    7 +
 drivers/staging/iio/light/Kconfig                  |   10 +
 drivers/staging/iio/light/Makefile                 |    1 +
 drivers/staging/iio/light/isl29028.c               |  538 ++++++++++++++++++++
 4 files changed, 556 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/light/isl29028.c

