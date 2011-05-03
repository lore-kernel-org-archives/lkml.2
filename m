Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1ECQSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:18:35 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33123 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1ECQSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:18:34 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 0/5] Add TPS65911 device 
Date: Tue, 3 May 2011 11:18:27 -0500
Message-Id: <051C7192-DA44-4960-A2A4-7882E2184F62@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
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

GIT: [PATCH 1/5] MFD: TPS65910: Add support for TPS65911 device
GIT: [PATCH 2/5] regulator: tps65911: Add new chip version
GIT: [PATCH 3/5] TPS65911: Add new irq definitions
GIT: [PATCH 4/5] TPS65911: Add support for added GPIO lines
GIT: [PATCH 5/5] TPS65911: Comparator: Add comparator driver