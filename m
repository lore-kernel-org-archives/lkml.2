Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1EPSuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:50:09 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48928 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab1EPSuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:50:08 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 0/5] Add TPS65911 device
Date: Mon, 16 May 2011 13:49:59 -0500
Message-Id: <378C5676-1C8A-4689-9F3E-23D73D90F6D2@slimlogic.co.uk>
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

GIT: [PATCHv3 1/5] MFD: TPS65910: Add support for TPS65911 device
GIT: [PATCHv3 2/5] regulator: tps65911: Add new chip version
GIT: [PATCHv3 3/5] TPS65911: Add new irq definitions
GIT: [PATCHv3 4/5] TPS65911: Add support for added GPIO lines
GIT: [PATCHv3 5/5] TPS65911: Comparator: Add comparator driver