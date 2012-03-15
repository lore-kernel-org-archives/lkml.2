Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161113Ab2COQ7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:59:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50121 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031881Ab2COQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:59:12 -0400
Date: Thu, 15 Mar 2012 09:59:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120315165906.GE32137@google.com>
References: <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307150549.955d6f9c.akpm@linux-foundation.org>
 <20120308175708.GB22922@redhat.com>
 <20120308180833.GA25508@google.com>
 <20120308181125.GB25508@google.com>
 <20120308182245.GC22922@redhat.com>
 <20120308182712.GD25508@google.com>
 <20120315164800.GE3253@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315164800.GE3253@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 15, 2012 at 12:48:00PM -0400, Vivek Goyal wrote:
> Your patches are in for-3.4/core branch of Jens's tree. So these indeed
> are going in 3.4 and not 3.5. I am confused.

Yeah, that's a bit confusing but they really aren't scheduled for the
upcoming merge window.  I suppose Jens just didn't want to create
for-3.5 branch at the moment.  Jens?

Thanks.

-- 
tejun
