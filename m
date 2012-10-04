Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965237Ab2JDGmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:42:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50792 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965464Ab2JDGi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:38:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6854"; a="245504053"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] Minor fixes for generic clock framework
Date: Wed,  3 Oct 2012 23:38:52 -0700
Message-Id: <1349332735-20096-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a small set of patches that fixes some documentation
and fixes return values of functions that aren't used that
much yet. Noticed while going through this code.

Stephen Boyd (3):
  clk: Document .is_enabled op
  clk: Fix documentation typos
  clk: Don't return negative numbers for unsigned values with !clk

 drivers/clk/clk.c            | 20 ++++++++++----------
 include/linux/clk-provider.h | 16 ++++++++++------
 2 files changed, 20 insertions(+), 16 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

