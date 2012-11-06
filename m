Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2KFHfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:35:20 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:40713 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab2KFHfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:35:18 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 0/7] mfd: update on max8925 for DT support
Date: Tue,  6 Nov 2012 15:35:05 +0800
Message-Id: <1352187305-9660-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 06 Nov 2012 07:35:06.0401 (UTC) FILETIME=[3DEC2110:01CDBBF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

1. add irqdomain for max8925, it is necessary for dt support
2. bug fix in max8925 mfd devices'irq base and device registry failure
3. support DT for max8925 mfd devices

Qing Xu (7):
  mfd: max8925: add irqdomain for dt
  mfd: max8925: fix mfd device register failure
  mfd: max8925: fix onkey driver irq base
  mfd: max8925: support dt for power supply
  mfd: max8925: support dt for regulator
  mfd: max8925: support dt for backlight
  mfd: max8925: add dts

 arch/arm/boot/dts/mmp2-brownstone.dts |  166 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/mmp2.dtsi           |    4 +-
 drivers/input/misc/max8925_onkey.c    |    3 -
 drivers/mfd/max8925-core.c            |  107 +++++++++++++--------
 drivers/mfd/max8925-i2c.c             |   32 ++++++-
 drivers/power/max8925_power.c         |   57 ++++++++++-
 drivers/regulator/max8925-regulator.c |   35 +++++++-
 drivers/video/backlight/max8925_bl.c  |   31 ++++++-
 include/linux/mfd/max8925.h           |   12 ++-
 9 files changed, 389 insertions(+), 58 deletions(-)

