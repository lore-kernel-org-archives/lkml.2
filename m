Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab2JRX2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:28:16 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54627 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab2JRXTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:53 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 0/2] clean-up initialization of deferrable timer
Date: Fri, 19 Oct 2012 08:18:26 +0900
Message-Id: <1350602308-2120-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Yes>
References: <Yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces setup_timer_deferrable() macro.
Using it makes code simple and understandable.

This patchset doesn't make any functional difference.
It is just for clean-up.

It is based on v3.7-rc1

Joonsoo Kim (2):
  timer: add setup_timer_deferrable() macro
  timer: use new setup_timer_deferrable() macro

 drivers/acpi/apei/ghes.c                     |    5 ++---
 drivers/ata/libata-core.c                    |    5 ++---
 drivers/net/ethernet/nvidia/forcedeth.c      |   13 ++++---------
 drivers/net/ethernet/qlogic/qlge/qlge_main.c |    4 +---
 drivers/net/vxlan.c                          |    5 ++---
 include/linux/timer.h                        |    2 ++
 kernel/workqueue.c                           |    6 ++----
 net/mac80211/agg-rx.c                        |   12 ++++++------
 net/mac80211/agg-tx.c                        |   12 ++++++------
 net/sched/cls_flow.c                         |    5 ++---
 net/sched/sch_sfq.c                          |    5 ++---
 11 files changed, 31 insertions(+), 43 deletions(-)

-- 
1.7.9.5

