Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab2HVGFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:05:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55272 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137Ab2HVGFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:05:38 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 0/3] spi: omap2-mcspi: spi cleanups
Date: Wed, 22 Aug 2012 11:35:11 +0530
Message-ID: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
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

Changes from v1:
Fix the comments on changelogs.
Add acks to the patches.

The following changes since commit 23dcfa61bac244e1200ff9ad19c6e9144dcb6bb5:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-08-21 17:22:22 -0700)

are available in the git repository at:

  git://gitorious.org/linus-tree/linus-tree.git for_3.6/spi




Shubhrajyoti D (3):
  spi: omap2-mcspi: Call pm_runtime_* functions directly
  spi: omap2-mcspi: Remove the macro MOD_REG_BIT
  spi: omap2-mcspi: At remove dont use the runtime_autosuspend calls

 drivers/spi/spi-omap2-mcspi.c |   55 ++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

-- 
1.7.5.4

