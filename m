Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031916Ab2COQsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031815Ab2COQsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:48:32 -0400
Date: Thu, 15 Mar 2012 12:48:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120315164800.GE3253@redhat.com>
References: <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307150549.955d6f9c.akpm@linux-foundation.org>
 <20120308175708.GB22922@redhat.com>
 <20120308180833.GA25508@google.com>
 <20120308181125.GB25508@google.com>
 <20120308182245.GC22922@redhat.com>
 <20120308182712.GD25508@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308182712.GD25508@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 10:27:12AM -0800, Tejun Heo wrote:
> On Thu, Mar 08, 2012 at 01:22:45PM -0500, Vivek Goyal wrote:
> > Does that mean in 3.4 we will continue to kill throttling groups and lose
> > all the policies and stats upon elevator change? So 3.4 will be one odd
> > release w.r.t this user visible change.
> 
> The whole thing is scheduled for 3.5, so no worries.

Tejun,

Your patches are in for-3.4/core branch of Jens's tree. So these indeed
are going in 3.4 and not 3.5. I am confused.

Thanks
Vivek
