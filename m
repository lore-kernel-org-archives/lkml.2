Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1KDMro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:47:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39894 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab1KDMrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:47:43 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>, <sameo@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 0/2] PMIC TPS65910 fixes
Date: Fri, 4 Nov 2011 18:17:30 +0530
Message-ID: <1320410850-20237-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series applies over Kyle Manna's v3 patch series,
https://lkml.org/lkml/2011/11/3/257,
with changes as per comments on
his 1/6 "mfd: TPS65910: Handle non-existent devices"

Regards
Afzal

Afzal Mohammed (2):
  mfd: TPS65910: Improvements
  regulator:TPS65910: VDD1/2 voltage selector count

 drivers/mfd/tps65910-irq.c             |   15 +++++++--------
 drivers/mfd/tps65910.c                 |   20 ++------------------
 drivers/regulator/tps65910-regulator.c |    1 +
 include/linux/mfd/tps65910.h           |    8 +-------
 4 files changed, 11 insertions(+), 33 deletions(-)

