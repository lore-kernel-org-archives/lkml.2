Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab1D0PvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:51:02 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:58067 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab1D0PvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:51:00 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: PATCHv5 0/4] Initial TPS65910 PMIC driver
Date: Wed, 27 Apr 2011 10:50:53 -0500
Message-Id: <5FB07FB7-95BA-4977-984E-4809AF2AE7A2@slimlogic.co.uk>
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

Changes from v4:
- Added set_bits/clear_bits API to tps65910 core.
- Modified gpio and regulator driver to use above API.
- Corrected a call to irq_set_noprobe().

GIT: [PATCHv5 1/4] MFD: TPS65910: Add new mfd device for TPS65910
GIT: [PATCHv5 2/4] TPS65910: GPIO: Add GPIO driver
GIT: [PATCHv5 3/4] TPS65910: IRQ: Add interrupt controller
GIT: [PATCHv5 4/4] TPS65910: Add tps65910 regulator driver