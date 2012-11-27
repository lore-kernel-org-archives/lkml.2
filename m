Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab2K0JCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:02:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:55926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab2K0JCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:02:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,326,1352102400"; 
   d="scan'208";a="224924508"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Jenny TC <jenny.tc@intel.com>, Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 0/2] power supply class support for charger managers
Date: Tue, 27 Nov 2012 13:17:01 +0530
Message-Id: <1354002423-24587-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we are heading towards kernel charger manager soulutions and few
are already in mainaline and few are in pipeline. It makes sense have
uniform low level driver support independent of charger manager frameworks.

This patchset add the neccessary changes to power supply class
to make charger drivers usable with charger managers.

And also enables charegr manager to use power supply drivers
for charge controls.

Ramakrishna Pallala (2):
  power_supply: Add charge control struct in power supply class
  charger_manager: Enable power supply driver support for charge
    controls

 drivers/power/Kconfig                 |    6 ++
 drivers/power/charger-manager.c       |   23 +++++----
 drivers/power/power_supply_core.c     |   18 +++++++
 include/linux/power/charger-manager.h |   84 +++++++++++++++++++++++++++++++++
 include/linux/power_supply.h          |   26 ++++++++++
 5 files changed, 146 insertions(+), 11 deletions(-)

