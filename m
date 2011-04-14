Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1DNWUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:20:36 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:55597 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab1DNWUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:20:34 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv2 0/4] Initial TPS65910 PMIC driver
Date: Thu, 14 Apr 2011 17:20:29 -0500
Message-Id: <02717347-3AD2-40C7-92A8-27369BFC5ABA@slimlogic.co.uk>
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

Changes from v1:
- Removed warnings in IRQ driver
- Removed warnings in regulator driver

GIT: [PATCH 1/4] MFD: TPS65910: Add new mfd device for TPS65910
GIT: [PATCH 2/4] TPS65910: GPIO: Add GPIO driver
GIT: [PATCH 3/4] TPS65910: IRQ: Add interrupt controller
GIT: [PATCH 4/4] TPS65910: Add tps65910 regulator driver