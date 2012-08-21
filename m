Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2HUGSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:18:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57922 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab2HUGR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:17:58 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 0/3] spi: omap2-mcspi: spi cleanups
Date: Tue, 21 Aug 2012 11:47:41 +0530
Message-ID: <1345529864-7937-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the following

Calls the pm_runtime_* functions directly.
Remove the MOD_REG_BIT macro usage thereby removiing un-needed branch.
At remove dont use the autosuspend runtime calls.

Shubhrajyoti D (3):
  spi: omap2-mcspi: Call pm_runtime_* functions directly
  spi: omap2-mcspi: Remove the macro MOD_REG_BIT
  spi: omap2-mcspi: At remove dont use the runtime_autosuspend calls

 drivers/spi/spi-omap2-mcspi.c |   55 ++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

-- 
1.7.5.4

