Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2DNSJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:09:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41020 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2DNSJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:09:11 -0400
Message-ID: <1334426937.2528.108.camel@twins>
Subject: Re: [PATCH v4 0/3] task_work_add (was: task_work_queue)
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
Date: Sat, 14 Apr 2012 20:08:57 +0200
In-Reply-To: <20120414021201.GA23385@redhat.com>
References: <20120414021201.GA23385@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 04:12 +0200, Oleg Nesterov wrote:
> Hello.
> 
> Changes based on review from Andrew:
> 
> 	- s/task_work_queue/task_work_add/
> 
> 	- don't create a secret dependency upon task_work.h
> 	  including sched.h in tracehook.h and keys/internal.h
> 
> 	- add more includes into task_work.[ch] to not rely
> 	  on "sched.h includes everything"
> 
> The genirq patch comes as 2/3, it was already acked by Thomas.
> 
> 3/3 still needs the ack from David, although his last review
> was positive and I hope I fully addressed his comments.

Can you use this to get rid of TIF_UPROBE as well?
