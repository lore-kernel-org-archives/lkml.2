Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab2DQQQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab2DQQQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:16:45 -0400
Date: Tue, 17 Apr 2012 18:16:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] task_work_add: generic process-context callbacks
Message-ID: <20120417161601.GA14527@redhat.com>
References: <20120414030507.GA27579@redhat.com> <20120414021201.GA23385@redhat.com> <20120414021220.GA23393@redhat.com> <CA+55aFyxV8v2mOjb1Ly=1ttPyLvUt6RZO8wgjD_9owtO=VM0hw@mail.gmail.com> <26488.1334670839@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26488.1334670839@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > tsk is always "current", probably this should be documented, I'll add
> > the comment.
>
> If tsk is always current, then don't pass it as a parameter.

This is already changed, I removed this arg.

> Some arches keep
> current in a register and it's much more efficient to use current directly in
> those cases

OK, thanks.

Oleg.

