Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab2LULQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:16:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab2LULQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:16:45 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Anton Arapov <anton@redhat.com>
Subject: [RFC PATCH 0/6] uprobes: return probe implementation
Date: Fri, 21 Dec 2012 12:16:30 +0100
Message-Id: <1356088596-17858-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  There are RFC uretprobes implementation. I'd be grateful for any review.

thanks,

Anton Arapov (6):
  uretprobes/x86: hijack return address
  uretprobes: trampoline implementation
  uretprobes: return probe entry, prepare uretprobe
  uretprobes: invoke return probe handlers
  uprobes: add bp_vaddr argument to consumer handler
  uretprobes: register() and unregister() implementation

 arch/x86/include/asm/uprobes.h |   6 +
 arch/x86/kernel/uprobes.c      |  57 ++++++++
 include/linux/uprobes.h        |  28 +++-
 kernel/events/uprobes.c        | 305 ++++++++++++++++++++++++++++++++++++++---
 kernel/trace/trace_uprobe.c    |  20 +--
 5 files changed, 383 insertions(+), 33 deletions(-)

-- 
1.8.0.2

