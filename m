Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab0KQDc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:32:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952Ab0KQDc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:32:26 -0500
Date: Tue, 16 Nov 2010 19:32:42 -0800
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
	filesystem
Message-ID: <20101117033242.GB31335@suse.de>
References: <20101117005357.024472450@goodmis.org> <20101117005939.600541101@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117005939.600541101@goodmis.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 07:53:58PM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Copied mostly from debugfs, the eventfs is the filesystem
> that will include stable tracepoints. Currently nothing
> enables this filesystem as of this patch.

What?  Wait, I wrote tracefs a long time ago just for this, why not take
that code and use it instead?

{sigh}  And I just deleted that old tracefs git tree today as I thought
that idea was long gone and dead....

> 
> Cc: Greg KH <gregkh@suse.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  fs/Kconfig              |    6 +
>  fs/Makefile             |    1 +
>  fs/eventfs/Makefile     |    4 +
>  fs/eventfs/file.c       |   53 ++++++
>  fs/eventfs/inode.c      |  433 +++++++++++++++++++++++++++++++++++++++++++++++

This seems a bit big, I don't think you need all of this for some
reason.  Are you sure you can't make it smaller?

thanks,

greg k-h
