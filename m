Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1DGSm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:42:57 -0400
Received: from linux-sh.org ([111.68.239.195]:35322 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab1DGSmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:42:55 -0400
Date: Fri, 8 Apr 2011 03:42:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile fixes for 2.6.39-rc3
Message-ID: <20110407184251.GA29901@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-fixes-for-linus

Which contains:

Guennadi Liakhovetski (1):
      ARM: arch-shmobile: only run HDMI init on respective boards

Kuninori Morimoto (1):
      ARM: arch-shmobile: only run FSI init on respective boards

Simon Horman (1):
      ARM: mach-shmobile: Correctly check for CONFIG_MACH_MACKEREL

 arch/arm/mach-shmobile/board-ap4evb.c       |   19 +++++++------------
 arch/arm/mach-shmobile/board-mackerel.c     |   10 ++++------
 arch/arm/mach-shmobile/include/mach/mmc.h   |    2 +-
 arch/arm/mach-shmobile/include/mach/zboot.h |    2 +-
 4 files changed, 13 insertions(+), 20 deletions(-)
