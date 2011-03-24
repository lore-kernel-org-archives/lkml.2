Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1CXQgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:36:10 -0400
Received: from linux-sh.org ([111.68.239.195]:51600 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1CXQgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:36:07 -0400
Date: Fri, 25 Mar 2011 01:35:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile updates for 2.6.39-rc1
Message-ID: <20110324163535.GC18002@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-latest

Which contains:

Guennadi Liakhovetski (1):
      ARM: mach-shmobile: add coherent DMA mask to CEU camera devices

Magnus Damm (1):
      ARM: mach-shmobile: Dynamic backlight control for Mackerel

Simon Horman (2):
      mmc, ARM: Rename SuperH Mobile ARM zboot helpers
      mmc: Add MMC_PROGRESS_*

 arch/arm/boot/compressed/mmcif-sh7372.c            |   13 +++++----
 arch/arm/mach-shmobile/board-ap4evb.c              |    3 +-
 arch/arm/mach-shmobile/board-mackerel.c            |   25 ++++++++++++++++++-
 .../include/mach/{mmcif-ap4eb.h => mmc-ap4eb.h}    |   10 ++++----
 .../mach/{mmcif-mackerel.h => mmc-mackerel.h}      |   11 ++++----
 .../mach-shmobile/include/mach/{mmcif.h => mmc.h}  |   10 ++++----
 arch/sh/boot/romimage/mmcif-sh7724.c               |    9 ++++---
 include/linux/mmc/boot.h                           |    7 +++++
 include/linux/mmc/sh_mmcif.h                       |    3 --
 9 files changed, 59 insertions(+), 32 deletions(-)
 rename arch/arm/mach-shmobile/include/mach/{mmcif-ap4eb.h => mmc-ap4eb.h} (80%)
 rename arch/arm/mach-shmobile/include/mach/{mmcif-mackerel.h => mmc-mackerel.h} (82%)
 rename arch/arm/mach-shmobile/include/mach/{mmcif.h => mmc.h} (67%)
 create mode 100644 include/linux/mmc/boot.h
