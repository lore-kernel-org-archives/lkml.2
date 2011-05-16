Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1EPXe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:34:59 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:34358 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab1EPXe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:34:58 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: PATCHv4 0/5] Add TPS65911 device
Date: Mon, 16 May 2011 18:34:49 -0500
Message-Id: <6713982D-EB98-4808-A03F-7E0C323B2531@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the initial version of the TPS65911 PMIC. This is a power management IC
for multimedia products.

The driver is depends on the TPS65910 PMIC and provides the same functionality:
Regulators, GPIO controller, RTC, etc. It also adds new functionality that was
not present in TPS65910 chip.

Support for subsequent versions of this PMIC can be easily added after this set
of patches.

Changes from v2:
- Moved GPIO driver to drivers/gpio.
- Determine the chip's number of gpios using a switch statement instead of if-else.
- Remove Kconfig entry for comparator driver.

Changes from v3:
- Separated GPIO changes in 2 patches:
   - Move gpio driver to drivers/gpio
   - Add support for tps65911

GIT: [PATCHv4 1/5] MFD: TPS65910: Add support for TPS65911 device
GIT: [PATCHv4 2/5] regulator: tps65911: Add new chip version
GIT: [PATCHv4 3/5] TPS65911: Add new irq definitions
GIT: [PATCHv4 4/5] TPS65911: Add support for added GPIO lines
GIT: [PATCHv4 5/5] TPS65911: Comparator: Add comparator driver