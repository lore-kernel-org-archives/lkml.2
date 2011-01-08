Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1AHAEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 19:04:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12330 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1AHAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 19:04:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6219"; a="69481306"
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MSM smp support
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Fri, 07 Jan 2011 16:04:46 -0800
Message-ID: <8yavd20tg4h.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

These are some additional MSM changes to add SMP support to MSM.
These depended upon some changes in Russell King's devel tree that got
rebased right before the push.  I've rebased these onto your current
tip, and retested.

Thanks,
David

The following changes since commit e744070fd4ff9d3114277e52d77afa21579adce2:

  Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-01-07 14:55:48 -0800)

are available in the git repository at:

  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-smp

Jeff Ohlstein (3):
      msm: timer: SMP timer support for msm
      msm: hotplug: support cpu hotplug on msm
      msm: add SMP support for msm

Stepan Moskovchenko (1):
      msm: scm-boot: Support for setting cold/warm boot addresses

Stephen Boyd (1):
      msm: Secure Channel Manager (SCM) support

 arch/arm/mach-msm/Kconfig                       |    5 +
 arch/arm/mach-msm/Makefile                      |    4 +
 arch/arm/mach-msm/headsmp.S                     |   40 ++++
 arch/arm/mach-msm/hotplug.c                     |   91 +++++++
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    6 +-
 arch/arm/mach-msm/io.c                          |    1 +
 arch/arm/mach-msm/platsmp.c                     |  166 +++++++++++++
 arch/arm/mach-msm/scm-boot.c                    |   39 +++
 arch/arm/mach-msm/scm-boot.h                    |   38 +++
 arch/arm/mach-msm/scm.c                         |  287 +++++++++++++++++++++++
 arch/arm/mach-msm/scm.h                         |   41 ++++
 arch/arm/mach-msm/timer.c                       |  125 ++++++++--
 12 files changed, 819 insertions(+), 24 deletions(-)
 create mode 100644 arch/arm/mach-msm/headsmp.S
 create mode 100644 arch/arm/mach-msm/hotplug.c
 create mode 100644 arch/arm/mach-msm/platsmp.c
 create mode 100644 arch/arm/mach-msm/scm-boot.c
 create mode 100644 arch/arm/mach-msm/scm-boot.h
 create mode 100644 arch/arm/mach-msm/scm.c
 create mode 100644 arch/arm/mach-msm/scm.h

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
