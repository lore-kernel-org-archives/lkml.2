Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2KWLdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:33:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:1596 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab2KWLdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:33:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,307,1352102400"; 
   d="scan'208";a="253225921"
From: Adrian Hunter <adrian.hunter@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, mika.westerberg@linux.intel.com,
        linux-mmc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Add SDHCI ACPI driver
Date: Fri, 23 Nov 2012 13:35:58 +0200
Message-Id: <1353670561-22515-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is SDHCI ACPI driver.

Changes for v2:

	Dropped "PNPACPI: exclude SDHCI devices"
	Added "PNPACPI: exclude devices already bound"
	Changed dev->acpi_handle to ACPI_HANDLE(dev)
	Added Chris' Ack for sdhci-acpi


Adrian Hunter (2):
      ACPI: add SDHCI to ACPI platform devices
      mmc: sdhci-acpi: add SDHCI ACPI driver

Mika Westerberg (1):
      PNPACPI: exclude devices already bound

 drivers/acpi/scan.c           |   2 +
 drivers/mmc/host/Kconfig      |  12 ++
 drivers/mmc/host/Makefile     |   1 +
 drivers/mmc/host/sdhci-acpi.c | 304 ++++++++++++++++++++++++++++++++++++++++++
 drivers/pnp/pnpacpi/core.c    |   4 +
 5 files changed, 323 insertions(+)
 create mode 100644 drivers/mmc/host/sdhci-acpi.c


Regards
Adrian Hunter
