Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2CESDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:03:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab2CESDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:03:34 -0500
Date: Mon, 5 Mar 2012 13:03:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120305180325.GC18546@redhat.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120227182220.GD27677@redhat.com>
 <20120229190354.GC5930@redhat.com>
 <20120305172000.GQ22536@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305172000.GQ22536@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 09:20:00AM -0800, Tejun Heo wrote:
> Hello, Vivek.
> 
> Sorry about the delay.  Was off last week.
> 
> On Wed, Feb 29, 2012 at 02:03:54PM -0500, Vivek Goyal wrote:
> > Ok, more debugging revealed that culprit here is "floppy" driver module.
> > It instanciates a queue but never registers a disk against it. Better
> > skip such queues/groups. Here is the patch.
> 
> Urgh.. I hate that driver.  I ended up folding the following patch in
> the series right after "blkcg: kill the mind-bending blkg->dev".

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
