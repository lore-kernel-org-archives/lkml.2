Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503Ab2D0P4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760341Ab2D0P4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:56:20 -0400
Date: Fri, 27 Apr 2012 11:56:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Message-ID: <20120427155612.GK10579@redhat.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
 <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
 <20120427150217.GK27486@google.com>
 <20120427154033.GJ10579@redhat.com>
 <20120427154502.GM27486@google.com>
 <20120427154841.GA16237@redhat.com>
 <20120427155140.GN27486@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427155140.GN27486@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 08:51:40AM -0700, Tejun Heo wrote:
> On Fri, Apr 27, 2012 at 11:48:41AM -0400, Vivek Goyal wrote:
> > Not an unpriviliged malicious application. In typical cgroup scenario, we
> > can allow unpriviliged users to create child cgroups so that it can
> > further subdivide its resources to its children group. (ex. put firefox
> > in one cgroup, open office in another group etc.).
> > 
> > So it is not same as jack up nr_requests.
> 
> I find allowing unpriv users creating cgroups dumb.  cgroup consumes
> kernel memory.  Sans using kmemcg, what prevents them from creating
> gazillion cgroups and consuming all memories?  The idea of allowing
> cgroups to !priv users is just broken from the get go.

Well creating a task consumes memory too but we allow unpriv users to
create tasks. :-)

May be a system wide cgroup limit will make sense?

Thanks
Vivek
