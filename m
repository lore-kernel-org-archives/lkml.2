Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2AEKFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 05:05:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62376 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2AEKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 05:04:57 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-8b-4f0575c762ad
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        dg77.kim@samsung.com
Subject: [PATCH 0/2] input: add MAX8997-haptic driver
Date: Thu, 05 Jan 2012 19:04:34 +0900
Message-id: <1325757876-17659-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997 has several features in a single chip.
This patchset supports unimplemented haptic driver of MAX8997.

Donggeun Kim (2):
  mfd: add platform data for MAX8997 haptic driver
  input: add driver support for MAX8997-haptic

 drivers/input/misc/Kconfig          |   12 ++
 drivers/input/misc/Makefile         |    1 +
 drivers/input/misc/max8997_haptic.c |  366 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997.h         |   53 +++++-
 4 files changed, 431 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/max8997_haptic.c

-- 
1.7.4.1

