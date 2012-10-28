Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2J1Rio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:38:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab2J1Ril (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:38:41 -0400
Date: Sun, 28 Oct 2012 18:39:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] uprobes: Kill arch_uprobe_enable/disable_step() hooks
Message-ID: <20121028173900.GA14621@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

arch_uprobe_enable/disable_step() were only needed to not break
the pending powerpc port. They buy nothing and they are simply
wrong. Uprobes should not use ptrace helpers for the stepping.

Now that powepc port was merged we should kill them asap, before
arm port.

1/4 is minor/offtopic cleanup. powerpc changes were not tested
at all and thus need the review from Ananth.

Oleg.

