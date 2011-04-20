Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1DTB1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:27:25 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:40245 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1DTB1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:27:24 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 0/4] Initial TPS65910 PMIC driver
Date: Tue, 19 Apr 2011 20:27:18 -0500
Message-Id: <D21ED4A0-C0DB-4535-AA39-0EF8C0CF4173@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the initial version of the TPS65910 PMIC. This is a power management IC
for multimedia products.

It provides regulators that are able to supply power to
dual processor cores and other components. The chip provides other modules
including GPIO controller, RTC, etc.

This driver will be able to support subsequent chip versions of the TPS6591x
family.

Changes from v2:
- Replaced VDD1_2 voltage table selection with a direct calculation.
- Replaced normal set_voltage operations with set_voltage_sel.
- Avoid VDD3 special cases.

GIT: [PATCHv3 1/4] MFD: TPS65910: Add new mfd device for TPS65910
GIT: [PATCHv3 2/4] TPS65910: GPIO: Add GPIO driver
GIT: [PATCHv3 3/4] TPS65910: IRQ: Add interrupt controller
GIT: [PATCHv3 4/4] TPS65910: Add tps65910 regulator driver