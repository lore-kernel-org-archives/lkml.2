Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1HSLzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:55:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59167 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1HSLzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:55:46 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        Abhilash K V <abhilash.kv@ti.com>, Sanjeev Premi <premi@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/4] AM3517: Adding support for suspend/resume
Date: Fri, 19 Aug 2011 17:25:23 +0530
Message-ID: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds support for suspension to RAM and
resumption on the AM3517.
These patches are dependent on the following patch-set
http://marc.info/?l=linux-omap&m=131247357813228&w=2
which gets the AM3517 EVM booting.
They are also dependent on the PM initialization patches which
are still to be submitted.
The patches are tested on master of tmlind/linux-omap-2.6.git.
Kernel version is 3.0.0-rc7 and last commit on top of which these patches
were added is:

        885cf6ff7d3dad4cc44be74b0577d3a554d3ab71: Linux-omap rebuilt:
        Updated to -rc7, added new boards

Cc: Sanjeev Premi <premi@ti.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com> 
---
Abhilash K V (2):
  AM3517 : support for suspend/resume
  AM3517: Fix suspend-resume sequence

Vaibhav Hiremath (2):
  AM3517: Add armv7-a flag for sleepam3517.S
  pm34xx: Warning FIX related to ambiguous else loop

 arch/arm/mach-omap2/Makefile    |    3 +-
 arch/arm/mach-omap2/control.c   |    7 ++-
 arch/arm/mach-omap2/control.h   |    1 +
 arch/arm/mach-omap2/pm.h        |    4 +
 arch/arm/mach-omap2/pm34xx.c    |   21 +++++-
 arch/arm/mach-omap2/sleep3517.S |  147 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 176 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/mach-omap2/sleep3517.S

