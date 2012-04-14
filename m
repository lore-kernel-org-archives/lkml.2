Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2DNCdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:33:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53734 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab2DNCdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120414021201.GA23385@redhat.com>
References: <20120414021201.GA23385@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Apr 2012 19:32:51 -0700
X-Google-Sender-Auth: dwEHJK_UyQQ2vgHb4Cf1-weyPvs
Message-ID: <CA+55aFyDy6VHtZ=SmXfn-AHT0QU8LV69U5NECGLA9pXg4Q=aZw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] task_work_add (was: task_work_queue)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 7:12 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Changes based on review from Andrew:
>
>        - s/task_work_queue/task_work_add/
>
>        - don't create a secret dependency upon task_work.h
>          including sched.h in tracehook.h and keys/internal.h
>
>        - add more includes into task_work.[ch] to not rely
>          on "sched.h includes everything"

I thought based on Andrew's comments that you were going to remove the
extra code to do FIFO for no obvious reason. Apparently nothing
actually wanted/needed it, so why do it?

                  Linus
