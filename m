Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2CHS1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:27:20 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50612 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab2CHS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:27:17 -0500
Date: Thu, 8 Mar 2012 10:27:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120308182712.GD25508@google.com>
References: <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307150549.955d6f9c.akpm@linux-foundation.org>
 <20120308175708.GB22922@redhat.com>
 <20120308180833.GA25508@google.com>
 <20120308181125.GB25508@google.com>
 <20120308182245.GC22922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308182245.GC22922@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 01:22:45PM -0500, Vivek Goyal wrote:
> Does that mean in 3.4 we will continue to kill throttling groups and lose
> all the policies and stats upon elevator change? So 3.4 will be one odd
> release w.r.t this user visible change.

The whole thing is scheduled for 3.5, so no worries.

-- 
tejun
