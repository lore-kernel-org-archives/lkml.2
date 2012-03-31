Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2CaLhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 07:37:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53719 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab2CaLhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 07:37:19 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 0/3] spi: omap2-mcspi: driver updates
Date: Sat, 31 Mar 2012 17:06:55 +0530
Message-ID: <1333193818-3984-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series does the following cleanups
- Makes the driver use autosuspend
- Folds Benoit's bus_num removal patch in the series
- The tmp variable is used to write this can be optimised 
 as it is not needed if the value is directly written.
 Acknowledge  Tarun for the suggestion.

This is also available through
git     : git://gitorious.org/linus-tree/linus-tree.git
branch  : spi_next

Rebased to Grant's spi/next branch.

 

Benoit Cousson (1):
  spi/omap: Remove bus_num usage for instance index

Shubhrajyoti D (2):
  spi: omap2-mcspi: add support for pm_runtime autosuspend
  spi: omap2-mcspi: Trivial optimisation

 drivers/spi/spi-omap2-mcspi.c |   86 +++++++++++++++++++---------------------
 1 files changed, 41 insertions(+), 45 deletions(-)

