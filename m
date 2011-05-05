Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1EEAVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 20:21:16 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:42295 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1EEAVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 20:21:15 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv2 0/5] Add TPS65911 device
Date: Wed, 4 May 2011 19:21:05 -0500
Message-Id: <6ECACA2B-DAAB-4321-9A5C-CA05521F1E81@slimlogic.co.uk>
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

Changes from v1:
- Changed several if statements to switch-case for future-proofing.
- Declared only on Comparator voltage table for COMP1 and COMP2.

GIT: [PATCHv2 1/5] MFD: TPS65910: Add support for TPS65911 device
GIT: [PATCHv2 2/5] regulator: tps65911: Add new chip version
GIT: [PATCHv2 3/5] TPS65911: Add new irq definitions
GIT: [PATCHv2 4/5] TPS65911: Add support for added GPIO lines
GIT: [PATCHv2 5/5] TPS65911: Comparator: Add comparator driver