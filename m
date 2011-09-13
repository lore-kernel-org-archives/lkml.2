Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1IMPB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:01:26 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51436 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1IMPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:01:25 -0400
Date: Tue, 13 Sep 2011 17:01:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 00/11 v5] cgroups: Task counter subsystem
Message-ID: <20110913150115.GB23424@somewhere>
References: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
 <1315924371.5977.16.camel@twins>
 <20110913143749.GA23424@somewhere>
 <1315925360.5977.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315925360.5977.17.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 04:49:20PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-09-13 at 16:37 +0200, Frederic Weisbecker wrote:
> > Because cgroup_task_limit.c sounds way too much generic to be
> > self-explanatory.
> 
> Uhm, why? That's exactly what it does, no? It limits the number of
> tasks.

To me that name sounds too generic. It's like something that does
a random limit on the tasks. Could be memory, IO or whatever. But
not something on the number of tasks.

Or may be cgroup_tasks_limit.c (note the "s" that tells about tasks
as a set), or cgroup_max_tasks.c ?
