Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab0IGOii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:38:38 -0400
Received: from www.tglx.de ([62.245.132.106]:43668 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757014Ab0IGOcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:32:41 -0400
Message-Id: <20100907124636.880953480@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:31:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [patch 00/30] semaphore cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_MUTEX[_LOCKED] and DECLARE_MUTEX are deprecated for quite some
time. Cleanup the remaining users and remove the cruft.

Thanks,

	tglx

