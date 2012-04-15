Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2DOLMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:12:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:43122 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2DOLMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:12:08 -0400
Message-ID: <1334488312.28150.2.camel@twins>
Subject: Re: [PATCH v3 1/3] task_work_queue: add generic process-context
 callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 15 Apr 2012 13:11:52 +0200
In-Reply-To: <20120412231520.GA1656@redhat.com>
References: <20120412211146.GA30448@redhat.com>
	 <20120412211208.GA30456@redhat.com>
	 <20120412152246.2eb4211b.akpm@linux-foundation.org>
	 <20120412231520.GA1656@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 01:15 +0200, Oleg Nesterov wrote:
> > hm, I see.  The "queue" in "task_work_queue" is "the action of
> > queueing", not "a queue".  Noun-vs-verb.
> 
> Cough. Peter, do you read this? I stole the naming and the first
> line of the changelog from kernel/irq_work.c! 

Am now.. right, so that was modeled after queue_work(), although I now
realize I reversed the words and made it irq_work_queue() instead of
queue_irq_work().

I'd prefer to keep the queue thing as per workqueue and irq_work etc..
