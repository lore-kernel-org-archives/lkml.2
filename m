Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1DUOfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:35:40 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38561 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab1DUOfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:35:39 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv4 0/4] Initial TPS65910 PMIC driver
Date: Thu, 21 Apr 2011 09:35:34 -0500
Message-Id: <8BED86E3-758A-4370-883E-54E225F603EE@slimlogic.co.uk>
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

Changes from v3:
- PATCH 4/4: Some old code was left behind. Remove it.
- PATCH 4/4: Several operations have to read the value of a register, modify
  it and then write it back. Create a new function that does the same.

GIT: [PATCHv4 1/4] MFD: TPS65910: Add new mfd device for TPS65910
GIT: [PATCHv4 2/4] TPS65910: GPIO: Add GPIO driver
GIT: [PATCHv4 3/4] TPS65910: IRQ: Add interrupt controller
GIT: [PATCHv4 4/4] TPS65910: Add tps65910 regulator driver