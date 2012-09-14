Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab2INRNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:13:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600Ab2INRNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:13:42 -0400
Date: Fri, 14 Sep 2012 19:15:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] uprobes: handle_swbp() fixes
Message-ID: <20120914171513.GA29599@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mostly fixes the error hanling in handle_swbp().

Srikar, please review.

Oleg.

 arch/x86/kernel/signal.c |    4 +--
 include/linux/uprobes.h  |    1 -
 kernel/events/uprobes.c  |   66 +++++++++++++++++++--------------------------
 3 files changed, 29 insertions(+), 42 deletions(-)

