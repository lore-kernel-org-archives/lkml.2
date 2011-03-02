Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1CBRzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:55:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab1CBRzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:55:01 -0500
Message-Id: <20110302173831.295031866@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:31 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/22] sched: Reduce runqueue lock contention -v5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series aims to optimize remote wakeups by moving most of the
work of the wakeup to the remote cpu and avoid bouncing runqueue data
structures where possible.

If there are no more 'fun' bits left I'll queue this work for .40.

