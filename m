Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab1EJUeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:34:44 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33820 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1EJUen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:34:43 -0400
MIME-Version: 1.0
Date: Tue, 10 May 2011 15:25:06 -0500
Message-ID: <BANLkTinUp=CXNc+kvFF1vVunk32mDauD-A@mail.gmail.com>
Subject: [PATCH 0/4] Initial TPS65912 PMIC driver
From: Margarita Olaya <magi@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the initial version of the TPS65912 PMIC, a power managment IC
for multimedia products.

The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
voltage to main processor and other components. The chip includes a
GPIO module.

Margarita Olaya Cabrera (4):
  mfd: tps65912: Add new mfd device
  tps65912: gpio: add gpio driver
  tps65912: irq: add interrupt controller
  tps65912: add regulator driver

 drivers/mfd/Kconfig                    |    8 +
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/tps65912-gpio.c            |   94 +++
 drivers/mfd/tps65912-irq.c             |  224 ++++++++
 drivers/mfd/tps65912.c                 |  387 +++++++++++++
 drivers/regulator/Kconfig              |    6 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65912-regulator.c |  966 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65912.h           |  465 +++++++++++++++
 9 files changed, 2152 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps65912-gpio.c
 create mode 100644 drivers/mfd/tps65912-irq.c
 create mode 100644 drivers/mfd/tps65912.c
 create mode 100644 drivers/regulator/tps65912-regulator.c
 create mode 100644 include/linux/mfd/tps65912.h
