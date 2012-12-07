Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030544Ab2LGN7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 08:59:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:55660 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030510Ab2LGN73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 08:59:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,237,1355126400"; 
   d="scan'208";a="260483497"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: linus.walleij@linaro.org
Cc: grant.likely@secretlab.ca, mika.westerberg@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 0/1] gpio: add Lynxpoint chipset gpio driver
Date: Fri,  7 Dec 2012 16:01:38 +0200
Message-Id: <1354888899-21907-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gpio controller driver for the Intel Lynxpoint LP PCH chipset is
designed to work with the new ACPI 5 enumeration model and ACPI 5 GpioIo/GpioInt 
resource translation recently added to linux-acpi.

Mathias Nyman (1):
  gpio: add Lynxpoint chipset gpio driver.

 drivers/gpio/Kconfig          |    7 +
 drivers/gpio/Makefile         |    1 +
 drivers/gpio/gpio-lynxpoint.c |  406 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 414 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-lynxpoint.c

-- 
1.7.4.1

