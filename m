Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab2AIWOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:14:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932829Ab2AIWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:13:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 10/11] timer changes for msm
Date: Mon,  9 Jan 2012 22:12:50 +0000
Message-Id: <1326147171-13752-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:O8+kkVBtXJQZWHgAjNmrAsvTO6Ggb/Yk249uOajNJXk
 AP7tTRRfKjHwWoKFiXv09wToCzGgUD3xcIZyrZsNto51/QYDWd
 ridDOGi7vTxEit4+2ONN3/vsrdMxhZUXZnzpX3w4JfPW1y/Ac9
 SMPE18lMRSKKUoYU5AH305d61M2AavmEc5Q5x2d3MJS6e+fzNT
 rwbY8MKGJnDfqXEZXq+u7gjahbuCsSufO3C24fktBXgXgRZELw
 vkY7cR0VVIJOHHeCtUnL8Rrs/dZtY+zS5QoW36Wb/oPwL9/OCn
 Kn9JbaMdeb4GnDUdNSJHaCJGF1r3OLfreaM8m/tzKU6Afd/goe
 bLAGqv6PBYylcAztVl7IBawFm0rS4xOf77KJFH4t8/DzFhR+KY
 61i7uAdQlTsRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A very simple series. We used to have more churn in the timer
area, so this is kept separate. Will probably put this into the
drivers series next time.

The following changes since commit 09c7db5d8a0341aba761658c3b6ffabe896cd180:

  Merge branch 'next/pm' into for-next3 (2012-01-09 17:08:36 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git msm/timer

Stephen Boyd (8):
      msm: timer: Tighten #ifdef for local timer support
      msm: timer: Cleanup #includes and #defines
      msm: timer: Use GPT for clockevents and DGT for clocksource
      msm: timer: Fix ONESHOT mode interrupts
      msm: timer: Remove msm_clocks[] and simplify code
      msm: timer: Remove SoC specific #ifdefs
      msm: timer: Setup interrupt after registering clockevent
      msm: timer: Use clockevents_config_and_register()

 arch/arm/mach-msm/timer.c |  347 ++++++++++++++++-----------------------------
 1 files changed, 124 insertions(+), 223 deletions(-)
