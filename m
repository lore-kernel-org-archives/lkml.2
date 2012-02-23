Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2BWXMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:12:10 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41806 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2BWXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:12:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.204.106 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Thu, 23 Feb 2012 15:12:04 -0800
From: Tejun Heo <tj@kernel.org>
To: vgoyal@redhat.com
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120223231204.GM22536@google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223230123.GL22536@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 03:01:23PM -0800, Tejun Heo wrote:
> Hmmm... going through the thread again, ah, okay, I forgot about that
> completely.  Yeah, that is an actual problem.  Both __GFP_WAIT which
> isn't GFP_KERNEL and GFP_KERNEL are valid use cases.  I guess we'll be
> building async percpu pool in blkcg then.  Great.  :(

Vivek, you win. :) Can you please refresh the async alloc patch on top
of blkcg-stacking branch?  I'll rool that into this series and drop
the mempool stuff.

Thanks.

-- 
tejun
