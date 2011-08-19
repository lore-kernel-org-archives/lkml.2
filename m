Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1HSLwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:52:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36556 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1HSLwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:52:45 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Abhilash K V <abhilash.kv@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/2] AM3517EVM: Add support for MMC1
Date: Fri, 19 Aug 2011 17:22:29 +0530
Message-ID: <1313754751-11752-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds support for MMC1 slot on the 
AM3517 EVM's base-board.
These patches are dependent on the following patch-set
http://marc.info/?l=linux-omap&m=131247357813228&w=2
which gets the AM3517 EVM booting.

The patches are tested on master of tmlind/linux-omap-2.6.git.
Kernel version is 3.0.0-rc7 and last commit on top of which these patches
were added is:

        885cf6ff7d3dad4cc44be74b0577d3a554d3ab71: Linux-omap rebuilt:
        Updated to -rc7, added new boards

Cc: Vaibhav Hiremath <hvaibhav@ti.com>
---
Abhilash K V (1):
  AM3517: Support for MMC1

Vaibhav Hiremath (1):
  AM3517EVM: Add support for base-board MMC slot

 arch/arm/mach-omap2/board-am3517evm.c |   22 ++++++++++++++++++++++
 arch/arm/mach-omap2/hsmmc.c           |   10 +++++++++-
 2 files changed, 31 insertions(+), 1 deletions(-)

