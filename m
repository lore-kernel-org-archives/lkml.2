Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab1FWNa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:30:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab1FWNaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:30:55 -0400
Date: Thu, 23 Jun 2011 15:28:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110623132831.GA11453@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com> <20110622210834.GC20549@redhat.com> <20110623122253.GM30101@htj.dyndns.org> <20110623132126.GA10410@redhat.com> <20110623132754.GO30101@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623132754.GO30101@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Tejun Heo wrote:
>
> Hey,
>
> On Thu, Jun 23, 2011 at 03:21:26PM +0200, Oleg Nesterov wrote:
> > > > This also fixes a minor bug, if the exiting task is the group_leader
> > > > and it is traced by its real_parent, tracehook_notify_death() returns
> > > > task->exit_signal or SIGCHLD depending on thread_group_empty(), this
> > > > looks strange.
> > >
> > > Maybe we should do the above in a separate patch?
> >
> > Do you think this makes sense? OK, I can do this...
>
> Having subtle behavior change mixed with reorganization isn't too
> nice, so I think separating is better.

Hmm. OK, you are right. I'll redo.

Oleg.

