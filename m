Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1BBVlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:41:22 -0500
Received: from www.tglx.de ([62.245.132.106]:38853 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab1BBVlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:41:21 -0500
Message-Id: <20110202212258.546660886@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 21:41:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/8] genirq: Further cleanups for .39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series consolidates the IRQ_MASKED handling which is a
prerequisite for forced threaded handlers and cleans up a few flow
handlers in the architecture code so handle_IRQ_event becomes local to
the core code.

Thanks,

	tglx

