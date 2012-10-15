Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2JOQ7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:59:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56604 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2JOQ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:59:20 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] tick: Some consolidation cleanups
Date: Mon, 15 Oct 2012 18:59:11 +0200
Message-Id: <1350320354-17214-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

I guess those patches are not controversial so I'm joining a
pull request on the first take, just in case.

This can be pulled from:

git://github.com/fweisbec/linux-dynticks.git
	nohz/core

Thanks.

Frederic Weisbecker (3):
  tick: Consolidate timekeeping handling code
  tick: Consolidate tick handling for high and low res handlers
  tick: Conditionally build nohz specific code in tick handler

 kernel/time/tick-sched.c |  111 ++++++++++++++++++++--------------------------
 1 files changed, 48 insertions(+), 63 deletions(-)

-- 
1.7.5.4

