Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2LLPkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:40:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:1498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab2LLPkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:40:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,267,1355126400"; 
   d="scan'208";a="232827242"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: linus.walleij@linaro.org
Cc: grant.likely@secretlab.ca, mika.westerberg@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH v2 0/1] gpio: add Lynxpoint chipset gpio driver
Date: Wed, 12 Dec 2012 17:42:37 +0200
Message-Id: <1355326958-18914-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gpio controller driver for the Intel Lynxpoint LP PCH chipset is
designed to work with the new ACPI 5 enumeration model and ACPI 5 GpioIo/GpioInt 
resource translation recently added to linux-acpi.

v2 changes:
- removed variables from lp_gpio struct that are used only locally
- renamed gpio_reg() to lp_gpio_reg()
- renamed gpio variable to offset or hwirq where needed.
- added comments about register layout
- removed __devexit/__devinit macros
- removed #ifdefs and added ACPI dependancy instead
- added simple runtime pm support
- added lp_gpio_free()

Mathias Nyman (1):
  gpio: add Lynxpoint chipset gpio driver.

 drivers/gpio/Kconfig          |    8 +
 drivers/gpio/Makefile         |    1 +
 drivers/gpio/gpio-lynxpoint.c |  469 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 478 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-lynxpoint.c

-- 
1.7.4.1

