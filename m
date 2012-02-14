Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab2BNQkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:40:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34443 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2BNQkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:40:01 -0500
Date: Tue, 14 Feb 2012 08:39:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120214163955.GO12117@google.com>
References: <20120209175948.GE19392@google.com>
 <CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
 <20120209192431.GF19392@google.com>
 <20120209234844.GG19392@google.com>
 <CANejiEXaaSfv8Rs3Rg6zLamYsUj=apKku6yrw7EUtpKkB1ZATA@mail.gmail.com>
 <CANejiEVBd6eu8LwmhbMvQqMW4LqUh6F-5psyW0dVYU06WEJqBQ@mail.gmail.com>
 <20120211021724.GO19392@google.com>
 <CANejiEVQav8mtQHD0FETxo1-Zc7exMyb6ecjrAzdZWw68OkTug@mail.gmail.com>
 <20120213204937.GF12117@google.com>
 <CANejiEW46KSZHLqn5-ZLCpMV_MyQsJB2kghrvzcEpvigod+9zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEW46KSZHLqn5-ZLCpMV_MyQsJB2kghrvzcEpvigod+9zA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 14, 2012 at 10:36:36AM +0800, Shaohua Li wrote:
> 2012/2/14 Tejun Heo <tj@kernel.org>:
> > Now that we have proper request draining on queue exit, we can
> > probably move ioc clearing and other operations to blk_cleanup_queue()
> > and then apply RCU, but that's for another merge window.
>
> This fixed the regression. Thanks!

Ah... that's a good news.  I'll split up the patches and post them.

Thank you very much for the bisection and testing all the different
patches!

-- 
tejun
