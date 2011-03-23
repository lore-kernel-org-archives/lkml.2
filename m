Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab1CWTzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:55:43 -0400
Received: from mail.perches.com ([173.55.12.10]:4243 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab1CWTzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:55:42 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 0/2] Fix resource size miscalculations
Date: Wed, 23 Mar 2011 12:55:35 -0700
Message-Id: <cover.1300909445.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size a few places

Joe Perches (2):
  trivial: treewide: Fix iomap resource size miscalculations
  trivial: arm: mach-u300/gpio: Fix mem_region resource size miscalculations

 arch/arm/mach-u300/gpio.c         |    7 +++----
 arch/arm/mach-ux500/mbox-db5500.c |    6 ++----
 arch/mips/rb532/gpio.c            |    2 +-
 drivers/video/msm/mddi.c          |    2 +-
 drivers/watchdog/bcm63xx_wdt.c    |    2 +-
 5 files changed, 8 insertions(+), 11 deletions(-)

-- 
1.7.4.2.g597a6.dirty

