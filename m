Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab0EQWG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:06:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0EQWGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:06:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, gorcunov@gmail.com, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/3] lockup detector fixes
Date: Mon, 17 May 2010 18:06:03 -0400
Message-Id: <1274133966-18415-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another round of cleanups thanks to Frederic W.'s review.

The biggest churn is from trying to cleanup the sysctl interface.

Cheers,
Don

Don Zickus (3):
  lockup_detector: convert per_cpu to __get_cpu_var for readability
  [watchdog] separate hardlockup/softlockup enable paths
  [watchdog] re-introduce support for nmi_watchdog, nosoftlockup

 arch/x86/include/asm/nmi.h |    2 -
 include/linux/nmi.h        |    4 +-
 kernel/sysctl.c            |   15 +++-
 kernel/watchdog.c          |  230 +++++++++++++++++++++++++++-----------------
 4 files changed, 156 insertions(+), 95 deletions(-)

