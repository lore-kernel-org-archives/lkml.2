Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1BXSot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:44:49 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31138 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1BXSos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:44:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76263873"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4] SCM fixes and updates
Date: Thu, 24 Feb 2011 10:44:41 -0800
Message-Id: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.55.gdca3d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are a few updates to SCM. The first two patches fix some
bad code generation. The next patch saves a couple instructions
on the slow path and the final patch determines the cacheline
size dynamically instead of statically.

Stephen Boyd (4):
  msm: scm: Mark inline asm as volatile
  msm: scm: Fix improper register assignment
  msm: scm: Check for interruption immediately
  msm: scm: Get cacheline size from CTR

 arch/arm/mach-msm/scm.c |   75 +++++++++++++++++++++++++++-------------------
 1 files changed, 44 insertions(+), 31 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

