Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319Ab2D0UV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116Ab2D0UV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:21:27 -0400
Date: Fri, 27 Apr 2012 16:21:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Message-ID: <20120427202119.GO10579@redhat.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
 <20120427194654.GN10579@redhat.com>
 <20120427201516.GJ26595@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427201516.GJ26595@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 01:15:16PM -0700, Tejun Heo wrote:

[..]
> > IOW, looks like we need a mechanism to mark a blkcg dead (set in
> > pre_destroy() call) and any submissions to blkcg after that should result
> > in bio being divered to root group?
> 
> Don't we already have that with css_tryget()?

Ok, forgot about css_tryget(). Yes that should work. Thanks. Introduction
of cgroup has made locking and lifetime rules little complicated. :-)

Thanks
Vivek
