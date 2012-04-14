Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2DNCNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab2DNCNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:13:07 -0400
Date: Sat, 14 Apr 2012 04:12:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <agordeev@redhat.com>, Chris Zankel <chris@zankel.net>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] task_work_add (was: task_work_queue)
Message-ID: <20120414021201.GA23385@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Changes based on review from Andrew:

	- s/task_work_queue/task_work_add/

	- don't create a secret dependency upon task_work.h
	  including sched.h in tracehook.h and keys/internal.h

	- add more includes into task_work.[ch] to not rely
	  on "sched.h includes everything"

The genirq patch comes as 2/3, it was already acked by Thomas.

3/3 still needs the ack from David, although his last review
was positive and I hope I fully addressed his comments.

Oleg.

