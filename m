Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1FXKEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:04:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53971 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1FXKEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:04:38 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-d3-4e04613446fc
Date: Fri, 24 Jun 2011 19:04:17 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH 0/2] MFD MAX8998/LP3974: Support Charger
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Message-id: <1308909859-3674-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 24 Jun 2011 10:04:52.0884 (UTC)
 FILETIME=[2953DD40:01CC3256]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1/2: Support power supply APIs

Patch 2/2: Introduce a new regulator to control battery charger

Donggeun Kim (2):
  power_supply: Add charger driver for MAX8998/LP3974
  regulator: Add a new regulator for charge control of MAX8998/LP3974

 drivers/mfd/max8998.c           |    2 +
 drivers/power/Kconfig           |    7 ++
 drivers/power/Makefile          |    1 +
 drivers/power/max8998_charger.c |  218 +++++++++++++++++++++++++++++++++++++++
 drivers/regulator/max8998.c     |  137 ++++++++++++++++++++++++-
 include/linux/mfd/max8998.h     |   18 +++
 6 files changed, 380 insertions(+), 3 deletions(-)
 create mode 100644 drivers/power/max8998_charger.c

-- 
1.7.4.1

