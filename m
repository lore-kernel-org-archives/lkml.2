Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1HRHhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:37:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24141 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1HRHhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:37:42 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-83-4e4cc1449641
Date: Thu, 18 Aug 2011 16:37:34 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 0/2] MFD: MAX8997 Driver Update
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1313653056-27263-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 18 Aug 2011 07:38:23.0343 (UTC)
 FILETIME=[CF1297F0:01CC5D79]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does:

1. Bugfix on IRQ handling
	The current version does not initialize IRQ handling part properly.
	This patch adds max8997-irq init and allows to handle interrupts
	correctly.

2. Suspend-to-RAM Wakeup Source
	The current version is missing wakeup-source feature.

Changes from v1:
- Removed a patch from the patchset.
(v2 is basically a "resubmit" without the undesired part)

MyungJoo Ham (2):
  MFD: MAX8997: IRQ Handling Bugfix
  MFD: MAX8997: Support Wake-up from Suspend

 drivers/mfd/max8997.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

-- 
1.7.4.1

