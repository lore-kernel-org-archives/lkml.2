Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0ITPWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:22:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0ITPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:22:04 -0400
Message-Id: <20100920151334.569154707@chello.nl>
User-Agent: quilt/0.47-1
Date: Mon, 20 Sep 2010 17:13:34 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Avi Kivity <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/2] PF_flags cleaups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we recently ran out of PF_flags, try and clean up.

Patches are on top of -tip, which already includes the PF_ALIGNWARN
removal.

