Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2LCEok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 23:44:40 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46283 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2LCEoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 23:44:38 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Liam Gridwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] regulator: new driver for LP8755
Date: Mon,  3 Dec 2012 13:44:23 +0900
Message-Id: <1354509864-30001-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Jeong <daniel.jeong@ti.com>

This driver is a general version for lp8755 regulator driver of TI.

LP8755 :
The LP8755 is a high performance power management unit.It contains
six step-down DC-DC converters which can be filexibly bundled
together in multiphase converters as required by application.

www.ti.com

Daniel Jeong (1):
  regulator: new driver for LP8755

 drivers/regulator/Kconfig            |    9 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/lp8755.c           |  553 ++++++++++++++++++++++++++++++++++
 include/linux/platform_data/lp8755.h |   72 +++++
 4 files changed, 635 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/lp8755.c
 create mode 100644 include/linux/platform_data/lp8755.h

-- 
1.7.5.4

