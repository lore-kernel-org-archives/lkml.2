Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1JKNlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:41:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47639 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1JKNlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:41:51 -0400
Date: Tue, 11 Oct 2011 15:41:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
Message-ID: <20111011134141.GC16777@somewhere.redhat.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <4E8D500B.5030508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8D500B.5030508@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 02:51:55PM +0800, Li Zefan wrote:
> > Frederic Weisbecker (9):
> >   cgroups: Add res_counter_write_u64() API
> >   cgroups: New resource counter inheritance API
> >   cgroups: Add previous cgroup in can_attach_task/attach_task callbacks
> >   cgroups: New cancel_attach_task subsystem callback
> >   cgroups: Ability to stop res charge propagation on bounded ancestor
> >   res_counter: Allow charge failure pointer to be null
> >   cgroups: Pull up res counter charge failure interpretation to caller
> >   cgroups: Allow subsystems to cancel a fork
> >   cgroups: Add a task counter subsystem
> > 
> > Kirill A. Shutemov (1):
> >   cgroups: Add res counter common ancestor searching
> > 
> >  Documentation/cgroups/cgroups.txt          |   13 ++-
> >  Documentation/cgroups/resource_counter.txt |   20 +++-
> >  Documentation/cgroups/task_counter.txt     |  153 ++++++++++++++++++
> >  block/blk-cgroup.c                         |   12 +-
> >  include/linux/cgroup.h                     |   28 +++-
> >  include/linux/cgroup_subsys.h              |    8 +
> >  include/linux/res_counter.h                |   27 +++-
> >  init/Kconfig                               |    9 +
> >  kernel/Makefile                            |    1 +
> >  kernel/cgroup.c                            |   58 ++++++--
> >  kernel/cgroup_freezer.c                    |    9 +-
> >  kernel/cgroup_task_counter.c               |  239 ++++++++++++++++++++++++++++
> >  kernel/cpuset.c                            |    6 +-
> >  kernel/events/core.c                       |    5 +-
> >  kernel/exit.c                              |    2 +-
> >  kernel/fork.c                              |    7 +-
> >  kernel/res_counter.c                       |   97 ++++++++++--
> >  kernel/sched.c                             |    6 +-
> >  18 files changed, 644 insertions(+), 56 deletions(-)
> >  create mode 100644 Documentation/cgroups/task_counter.txt
> >  create mode 100644 kernel/cgroup_task_counter.c
> > 
> 
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks a lot!
