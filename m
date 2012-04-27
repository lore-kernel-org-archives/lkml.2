Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537Ab2D0Pvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:51:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40314 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760243Ab2D0Pvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:51:45 -0400
Date: Fri, 27 Apr 2012 08:51:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Message-ID: <20120427155140.GN27486@google.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
 <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
 <20120427150217.GK27486@google.com>
 <20120427154033.GJ10579@redhat.com>
 <20120427154502.GM27486@google.com>
 <20120427154841.GA16237@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427154841.GA16237@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:48:41AM -0400, Vivek Goyal wrote:
> Not an unpriviliged malicious application. In typical cgroup scenario, we
> can allow unpriviliged users to create child cgroups so that it can
> further subdivide its resources to its children group. (ex. put firefox
> in one cgroup, open office in another group etc.).
> 
> So it is not same as jack up nr_requests.

I find allowing unpriv users creating cgroups dumb.  cgroup consumes
kernel memory.  Sans using kmemcg, what prevents them from creating
gazillion cgroups and consuming all memories?  The idea of allowing
cgroups to !priv users is just broken from the get go.

Thanks.

-- 
tejun
