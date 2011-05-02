Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1EBVYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:24:13 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38427 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab1EBVYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:24:12 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv6 0/4] Initial TPS65910 PMIC driver
Date: Mon, 2 May 2011 16:24:06 -0500
Message-Id: <0F700992-584B-4A99-8E5B-8EE3D2D669FE@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca,
        sameo@linux.intel.com
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
- Added a lock to tps65910 structure.

GIT: [PATCHv6 1/4] MFD: TPS65910: Add new mfd device for TPS65910
GIT: [PATCHv6 2/4] TPS65910: GPIO: Add GPIO driver
GIT: [PATCHv6 3/4] TPS65910: IRQ: Add interrupt controller
GIT: [PATCHv6 4/4] TPS65910: Add tps65910 regulator driver