Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab1CIOsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:48:55 -0500
Received: from smtp.nokia.com ([147.243.128.26]:41697 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab1CIOsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:48:53 -0500
From: aliaksei.katovich@nokia.com
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>
Subject: [PATCH v2 0/2] mfd: bq2415x charger driver
Date: Wed,  9 Mar 2011 16:48:02 +0200
Message-Id: <cover.1299679848.git.aliaksei.katovich@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <"cover.1299679848.git.aliaksei.katovich@nokia.com">
References: <"cover.1299679848.git.aliaksei.katovich@nokia.com">
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aliaksei Katovich <aliaksei.katovich@nokia.com>

The bq2415x family of Texas Instruments charger ICs are multifunctional chips
that combine voltage/current regulation with Li-Ion battery charge controller.

Given bq2415x driver implements both regulator and i2c devices within single
module. Despite not being mfd core dependant this driver however is thought
to belong to mfd subsystem rather than regulators or i2c one.

Implementation is based on BQ24153/6/8 datasheet.

The patch set applies cleanly to the MFD repository at
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git

Please review.

Aliaksei Katovich (2):
  mfd: bq2415x charger driver
  mfd: bq2415x compilation enablers

 drivers/mfd/Kconfig         |    7 +
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/bq2415x.c       |  874 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/bq2415x.h |   88 +++++
 4 files changed, 970 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/bq2415x.c
 create mode 100644 include/linux/mfd/bq2415x.h

