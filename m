Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab0FBLjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:39:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65466 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab0FBLiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:38:55 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 00/11] Multiple fixes for Devkit8000
Date: Wed,  2 Jun 2010 13:37:40 +0200
Message-Id: <1275478671-24563-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V01U2FsdGVkX19uzU5FC3fK+zu8tkrGcg7zDGNTz2y/isxq6nn
 wU0gk5PTcFaKN9SNR8XH9gMepRsuQzwlpGl26dvQsWI41oACJe
 AGhv4fW6V0dUNnFh8KVhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches correct errors that were done while using the board code
from beagle board for Devkit8000. 

The Devkit8000 uses the TPS65930, an reduced version of the TWL4030. 
So not all power supplies from the TWL4030 are available.
The DSS2 do not need a VDVI any longer so it is removed. 
The definition of the supplies are changed to use the new REGULATOR_SUPPLY macro.
The pins for lcd and dvi powerdown are corrected.

Changes to v1:
 -remove the patches that only fix comments
 -expand the description of the patches

Kan-Ru Chen (2):
  OMAP2: Devkit8000: Enable DVI-D output
  OMAP2: Devkit8000: Setup LCD reset

Thomas Weber (9):
  OMAP2: Devkit8000: Cleanup for power supplies
  OMAP2: Devkit8000: change panel to generic panel
  OMAP2: Devkit8000: Remove unneeded VDVI supply
  OMAP2: Devkit8000: Remove non existing vsim supply
  OMAP2: Devkit8000: Remove en-/disable for tv panel
  OMAP2: Devkit8000: Using the REGULATOR_SUPPLY macro
  OMAP2: Devkit8000: Using gpio_is_valid macro
  OMAP2: Devkit8000: Remove unused omap_board_config
  OMAP2: Devkit8000: Fix regulator for power supply

 arch/arm/mach-omap2/board-devkit8000.c |  122 +++++++++++++++-----------------
 1 files changed, 58 insertions(+), 64 deletions(-)

