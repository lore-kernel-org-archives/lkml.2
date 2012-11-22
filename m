Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2KVTIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:08:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:7322 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab2KVTH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:07:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="scan'208";a="221003669"
From: Adrian Hunter <adrian.hunter@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add SDHCI ACPI driver
Date: Thu, 22 Nov 2012 10:43:47 +0200
Message-Id: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is SDHCI ACPI driver.  It is dependent on new ACPI Platform support
so I suggest Rafael takes the patches with Chris' Ack.

Please note that I would prefer this to be queued for 3.8


Adrian Hunter (3):
      PNPACPI: exclude SDHCI devices
      ACPI: add SDHCI to ACPI platform devices
      mmc: sdhci-acpi: add SDHCI ACPI driver

 drivers/acpi/scan.c           |   2 +
 drivers/mmc/host/Kconfig      |  12 ++
 drivers/mmc/host/Makefile     |   1 +
 drivers/mmc/host/sdhci-acpi.c | 304 ++++++++++++++++++++++++++++++++++++++++++
 drivers/pnp/pnpacpi/core.c    |   1 +
 5 files changed, 320 insertions(+)
 create mode 100644 drivers/mmc/host/sdhci-acpi.c


Regards
Adrian Hunter
