Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763203Ab2KBRdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:33:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49159 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762295Ab2KBRdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:33:35 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>
Subject: [PATCH 0/2] irq_work: A couple fixes v2
Date: Fri,  2 Nov 2012 18:33:27 +0100
Message-Id: <1351877609-28856-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

After some discussion with Steve, this is a respin with changelogs and
comments sanitized. The code itself hasn't changed.

Thanks.

Frederic Weisbecker (2):
  irq_work: Fix racy IRQ_WORK_BUSY flag setting
  irq_work: Fix racy check on work pending flag

 kernel/irq_work.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

-- 
1.7.5.4

