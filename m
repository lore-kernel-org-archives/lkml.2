Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2JISMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:12:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:60832 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748Ab2JISMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:12:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,561,1344236400"; 
   d="scan'208";a="232609052"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH 0/2] power_supply: Add power supply throttling support
Date: Tue,  9 Oct 2012 22:24:40 +0530
Message-Id: <1349801680-19566-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During charging battery temperature and charger chip temperature will
go up. This can also result in increased skin temperature.

This patchset adds the power supply throttling support
and also registers the power supply as cooling device.

PATCH 1/2: Add support for CHARGE_CONTROL_* attributes
This adds the power supply attributes for CHARGE_CONTROL_*
These new attributes will the enable user space to implement
custom charging algorithms based on platform state.

PATCH 2/2: Register power supply for thermal cooling device
This patch registers the power supply as cooling device with
thermal framework.

 Documentation/power/power_supply_class.txt |    3 +++
 drivers/power/power_supply_sysfs.c         |    2 ++
 include/linux/power_supply.h               |    2 ++
 drivers/power/power_supply_core.c |  100 +++++++++++++++++++++++++++++++++++++
 include/linux/power_supply.h      |    1 +
 4 files changed, 108 insertions(+), 0 deletions(-)

Thanks,
Ramakrishna Pallala
