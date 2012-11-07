Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2KGHHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:07:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59946 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2KGHHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:07:41 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH RESEND 0/7] MFD: ti_am335x_tscadc: DT support and TSC features addition
Date: Wed, 7 Nov 2012 12:21:57 +0530
Message-ID: <1352271124-5513-1-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a cumulative set of [1] and [2] sent earlier.

Note that there are no code changes in either of the patch set,
only rebased on top of MFD-next to make sure that all the patches
apply without any conflicts.

This patch set has been tested on AM335x EVM and is based on top of [3].

[1] http://www.spinics.net/lists/linux-input/msg23060.html
[2] http://www.spinics.net/lists/linux-input/msg23090.html
[3] https://lkml.org/lkml/2012/11/6/67

Patil, Rachna (7):
  input: ti_am335x_tsc: Step enable bits made configurable
  input: ti_am335x_tsc: Order of TSC wires, made configurable
  input: ti_am335x_tsc: Add variance filter
  MFD: ti_am335x_tscadc: add device tree binding information
  MFD: ti_am335x_tscadc: Add DT support
  input: ti_am335x_tsc: Add DT support
  IIO: ti_am335x_adc: Add DT support

 .../devicetree/bindings/mfd/ti_am335x_tscadc.txt   |   35 +++
 drivers/iio/adc/ti_am335x_adc.c                    |   24 ++-
 drivers/input/touchscreen/ti_am335x_tsc.c          |  239 +++++++++++++++++---
 drivers/mfd/ti_am335x_tscadc.c                     |   28 ++-
 include/linux/input/ti_am335x_tsc.h                |   12 +
 include/linux/mfd/ti_am335x_tscadc.h               |   11 +-
 6 files changed, 308 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt

