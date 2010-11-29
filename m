Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0K2WHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:07:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0K2WHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:07:51 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: fweisbec@gmail.com, gorcunov@openvz.org, yinghai@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/2] x86, nmi watchdog: Fixes from removing old nmi watchdog
Date: Mon, 29 Nov 2010 17:07:15 -0500
Message-Id: <1291068437-5331-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of small fixes to address issues caused by removing the old nmi watchdog

Applied on top of Ingo's latest master branch.

Don Zickus (2):
  lockup detector:  Compile fixes from removing the old x86 nmi
    watchdog
  x86, NMI: add back unknown_nmi_panic and nmi_watchdog sysctls

 Documentation/kernel-parameters.txt |   10 +---------
 arch/x86/kernel/apic/hw_nmi.c       |   12 ++++++++----
 arch/x86/kernel/traps.c             |   16 +++++++++++-----
 include/linux/nmi.h                 |    4 +++-
 kernel/sysctl.c                     |   16 ++++++++++++++++
 kernel/sysctl_binary.c              |    1 -
 kernel/watchdog.c                   |    2 ++
 7 files changed, 41 insertions(+), 20 deletions(-)

-- 
1.7.3.2

