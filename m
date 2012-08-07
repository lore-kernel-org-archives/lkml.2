Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2HGQMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:12:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:53105 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2HGQMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:12:50 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com
Subject: uprobe: single step over uprobe & global breakpoints
Date: Tue,  7 Aug 2012 18:12:27 +0200
Message-Id: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have three pieces here:

[PATCH 1/5] uprobes: Use a helper instead of ptrace's single step
[PATCH 2/5] x86/uprobes: implement x86 specific arch_uprobe_*_step

following Oleg's suggestion to allow single stepping over an uprobe.

[PATCH 3/5] uprobes: remove check for uprobe variable in
[PATCH 4/5] uprobes: probe definiton can only start with 'p' and '-'

category cleanup.

[RFC 5/5] uprobes: add global breakpoints

global breakpoints. There is no gdb interface available in terms of "how do I
know that that a program hit a global breakpoint" and not doing ps or
"cat trace" all the time.

Sebastian
