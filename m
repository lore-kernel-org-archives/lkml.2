Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab1FUXq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:46:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33158 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab1FUXqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:46:43 -0400
Message-Id: <20110621233444.094372367@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 22 Jun 2011 01:34:44 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [RFC][PATCH 0/3] Move WQ,unplug scheduler hooks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas got annoyed at the amount of work done while having IRQs disabled.


