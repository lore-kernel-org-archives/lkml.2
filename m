Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0KRHB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:01:28 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:60464 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0KRHB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:01:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sHf0X8h9onw/YrR7qmU6W02bKhoK7EmZoAsGSnbypFilEpC9F3dFeo6nJFHvoFpgAf
         iwBiU9w4Bnqp0Icrqc6AnxpXi4Nr6dYNguqz7xx9yQFIvaeE0UiT+8Qf085F5e37SAw2
         1h5yCe9AYNb9dkyxA7MVNlrsEcv6EmIN+jYf4=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH 0/5] MIPS/Perf-events: Sync with mainline upper layer
Date: Thu, 18 Nov 2010 14:56:36 +0800
Message-Id: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current MIPS Perf-events uses older interfaces to the generic layer. So it
will not work. This patch set fixes this issue by adding MIPS counterparts
for a list of previous commits that went to mainline earlier.

Deng-Cheng Zhu (5):
  MIPS/Perf-events: Work with irq_work
  MIPS/Perf-events: Work with the new PMU interface
  MIPS/Perf-events: Check event state in validate_event()
  MIPS/Perf-events: Work with the new callchain interface
  MIPS/Perf-events: Use unsigned delta for right shift in event update

 arch/mips/Kconfig                    |    1 +
 arch/mips/include/asm/perf_event.h   |   12 +-
 arch/mips/kernel/perf_event.c        |  342 ++++++++++++++++------------------
 arch/mips/kernel/perf_event_mipsxx.c |    4 +-
 4 files changed, 169 insertions(+), 190 deletions(-)

