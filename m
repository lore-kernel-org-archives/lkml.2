Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab1FBI5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 04:57:18 -0400
Received: from linux-sh.org ([111.68.239.195]:51812 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691Ab1FBI5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 04:57:14 -0400
Date: Thu, 2 Jun 2011 17:57:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile fixes for 3.0-rc2
Message-ID: <20110602085710.GA28066@linux-sh.org>
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

Damian Hobson-Garcia (1):
      sh_mobile_meram: MERAM platform data for LCDC

Guennadi Liakhovetski (2):
      ARM: arch-shmobile: support SDHI card detection on mackerel, using a GPIO
      ARM: mach-shmobile: add DMAC clock definitions on SH7372

 arch/arm/mach-shmobile/board-ap4evb.c   |   56 ++++++++++++++++++++++
 arch/arm/mach-shmobile/board-mackerel.c |   78 +++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/clock-sh7372.c   |    7 +++
 3 files changed, 141 insertions(+), 0 deletions(-)
