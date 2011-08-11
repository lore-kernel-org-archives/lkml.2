Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HKQMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab1HKQMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:12:36 -0400
Date: Thu, 11 Aug 2011 18:09:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] make vfork killable/restartable/traceable
Message-ID: <20110811160914.GA8985@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110810214444.GD9320@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810214444.GD9320@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10, Pavel Machek wrote:
>
> > CLONE_VFORK sleeps in TASK_INTERRUPTIBLE until the child exits/execs.
> > This is obviously not good, it is sooo simple to create the task which
> > doesn't react to SIGKILL/SIGSTOP.
> >
> > Questions:
> >
> > 	- do we really need this?
> >
> I believe we should fix it. I was always claiming "if it does not
> react to SIGKILL, it is a kernel bug" and well, this just proved me
> wrong...

Agreed.

Just in case... sorry to all for delay, I am busy. I'll try to resend
the simplified version "soon", at least the "unkillable" part. And
we also have the pending oom issues...

Oleg.

