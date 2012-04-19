Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab2DSSLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:11:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230Ab2DSSLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:11:11 -0400
Date: Thu, 19 Apr 2012 20:10:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] cred: change keyctl_session_to_parent() to use
	task_work_add()
Message-ID: <20120419181010.GA29793@redhat.com>
References: <20120419173431.GA27066@redhat.com> <20120417193409.GA20312@redhat.com> <20120414021252.GC23393@redhat.com> <20120414021201.GA23385@redhat.com> <27037.1334672580@redhat.com> <20120417163606.GC14527@redhat.com> <23383.1334854333@redhat.com> <25695.1334858133@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25695.1334858133@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > But I certainly do not want to put these changes in 3/3 or in this series.
>
> Why not?  It seems the correct place for them.

I wanted to discuss the functional changes first, then send the trivial
cleanups. And the changes in arch/ are always painful. And, "remove
tracehook_notify_resume" is a bit off-topic, but I do not want to change
the same code in arch/ twice.

Oleg.

