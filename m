Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1KXJOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:14:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10176 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab1KXJOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:14:16 -0500
X-AuditID: cbfee61b-b7bfbae0000012f9-7c-4ece0ae789a3
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        akpm@linux-foundation.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, dg77.kim@samsung.com
Subject: [PATCH 0/2] misc: add MAX8997 MUIC driver
Date: Thu, 24 Nov 2011 18:14:08 +0900
Message-id: <1322126048-7024-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997 integrates serveral featuress in a single chip.
It includes PMIC (Power Management IC), RTC, charger, fuel gauge, and so on.
MUIC, which is one of the functional block in MAX8997, can be used to detect
which device is connected via USB port.
This patchset supports unimplemented MUIC feature of MAX8997.

Donggeun Kim (2):
  MFD: MAX8997: add platform data for MAX8997 MUIC driver
  misc: add driver support for MAX8997 MUIC

 drivers/misc/Kconfig        |    8 +
 drivers/misc/Makefile       |    1 +
 drivers/misc/max8997-muic.c |  634 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997.h |   58 ++++-
 4 files changed, 700 insertions(+), 1 deletions(-)
 create mode 100644 drivers/misc/max8997-muic.c

-- 
1.7.4.1

