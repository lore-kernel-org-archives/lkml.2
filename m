Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1KHNXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:23:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52216 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab1KHNXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:23:47 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>, <sameo@linux.intel.com>, <nsekhar@ti.com>
CC: <linux-omap@vger.kernel.org>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH RESEND v2 0/2] PMIC TPS65910 fixes
Date: Tue, 8 Nov 2011 18:53:35 +0530
Message-ID: <1320758615-29085-1-git-send-email-afzal@ti.com>
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
his/her 1/6 "mfd: TPS65910: Handle non-existent devices"

Patch series is being resend as earlier one's did not reach
mailing lists.

Regards
Afzal

v2:
[1/2]: Remove driver simplification that should not have been done
[2/2]: Use macros unambigously to specify count of selectable voltage 

Afzal Mohammed (2):
  mfd: TPS65910: Make usable even if interrupt unused
  regulator: TPS65910: VDD1/2 voltage selector count

 drivers/mfd/tps65910.c                 |    6 +-----
 drivers/regulator/tps65910-regulator.c |   14 ++++++++------
 include/linux/mfd/tps65910.h           |    3 ++-
 3 files changed, 11 insertions(+), 12 deletions(-)

