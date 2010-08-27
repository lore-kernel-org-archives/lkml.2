Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab0H0Lz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:55:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:57077 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0H0Lz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:55:26 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: [PATCH 0/3] ak8974 / ami305 magnetometer driver
Date: Fri, 27 Aug 2010 14:54:40 +0300
Message-Id: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 27 Aug 2010 11:54:48.0405 (UTC) FILETIME=[A639C050:01CB45DE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch set provides driver for ak8974 and ami305 3 axis magnetometer driver.
Data is provided via misc character device as a structure of data.
Driver supports regulator framework and has PM support.

Short documentation is also provided. Data format and sysfs interface
is shortly described in the documentation.

Provided data is raw magnetic field density for 3 axis. For compass
purposes data requires further processing.


Samu Onkalo (3):
  drivers: misc: ak8974 / ami305 magnetometer driver
  drivers: misc: ak8974 support to Kconfig and Makefile
  Documentation: Documentation for ak8974 magnetometer chip driver

 Documentation/misc-devices/ak8974 |   66 ++++
 drivers/misc/Kconfig              |   11 +
 drivers/misc/Makefile             |    1 +
 drivers/misc/ak8974.c             |  703 +++++++++++++++++++++++++++++++++++++
 include/linux/i2c/ak8974.h        |   50 +++
 5 files changed, 831 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/ak8974
 create mode 100644 drivers/misc/ak8974.c
 create mode 100644 include/linux/i2c/ak8974.h

