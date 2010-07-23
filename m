Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0GWS6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:58:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39068 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab0GWS6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:58:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6052"; a="48450440"
X-IronPort-AV: E=Sophos;i="4.55,247,1278313200"; 
   d="scan'208";a="69829405"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: [PATCH 0/3] ARM changes for ScorpionMP support
Date: Fri, 23 Jul 2010 11:58:00 -0700
Message-Id: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are low level changes needed to support targets based on Qualcomm's
ScorpionMP architecture.

Jeff Ohlstein (1):
  arm: Kconfig option for ARCH_MSM_SCORPIONMP

Steve Muckle (2):
  arm: mm: do not set missing flags on ScorpionMP
  arm: macros for wfe, sev instructions

 arch/arm/Kconfig                 |    5 +++--
 arch/arm/include/asm/processor.h |    5 +++++
 arch/arm/mach-msm/Kconfig        |    2 ++
 arch/arm/mm/proc-v7.S            |    2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
