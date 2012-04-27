Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884Ab2D0RZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:25:26 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:52253 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760552Ab2D0RZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:25:24 -0400
Date: Fri, 27 Apr 2012 10:25:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Message-ID: <20120427172519.GB26595@google.com>
References: <1335477561-11131-12-git-send-email-tj@kernel.org>
 <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
 <20120427150217.GK27486@google.com>
 <20120427154033.GJ10579@redhat.com>
 <20120427154502.GM27486@google.com>
 <20120427154841.GA16237@redhat.com>
 <20120427155140.GN27486@google.com>
 <20120427155612.GK10579@redhat.com>
 <20120427162012.GP27486@google.com>
 <20120427172110.GM10579@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427172110.GM10579@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 27, 2012 at 01:21:10PM -0400, Vivek Goyal wrote:
> For non-priviliged users, something along the lines of per session
> cpu autogroup might make sense.  But even then if some IO is submitted
> from that autoblkgroup, kernel can't claim that memory till IO is
> completed.
> 
> So per cgroup number of request will probably be a problem even if
> kenrel managed those completely.

My point was that trying to solve all the policy decisions in kernel
proper is not a very good idea.

> So are you planning to put a patch in kernel to disallow cgroup creation
> for non-priviliged users?

No, I'm not gonna break the current users.  It's just not the
direction I want to take cgroup towards and the current breakages will
remain broken.

Thanks.

-- 
tejun
