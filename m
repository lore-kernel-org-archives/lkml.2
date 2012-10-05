Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab2JEWAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:00:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab2JEWAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:00:38 -0400
Date: Fri, 5 Oct 2012 15:00:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-mm@kvack.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        aarcange@redhat.com, hannes@cmpxchg.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org
Subject: Re: [PATCH v2 0/8] THP support for Sparc64
Message-Id: <20121005150036.edd3be21.akpm@linux-foundation.org>
In-Reply-To: <20121005.174508.1624534294642226949.davem@davemloft.net>
References: <20121004.154624.923241475790311926.davem@davemloft.net>
	<20121005143644.abb14c2b.akpm@linux-foundation.org>
	<20121005.174508.1624534294642226949.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2012 17:45:08 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Fri, 5 Oct 2012 14:36:44 -0700
> 
> > David, I don't know what to do until there's some clarity on the
> > numa/sched changes.  Andrea has a new autonuma patchset, Peter's code
> > is in -next and I don't know if it's planned for 3.7 merging.  And I
> > suspect (hope) that it won't be merged if that is indeed planned.
> 
> It doesn't matter from a sparc64 perspective.
> 
> If you remove the autonuma patch, I'll still compile and work.
> I just provide an unused interface. 

ah, OK.

> Please do something instead of stalling these changes further.

OK, I'll add it all to the pile and will restage it against mainline on
Monday.

