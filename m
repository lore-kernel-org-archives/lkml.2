Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0ESODr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:03:47 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60491 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0ESODq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:03:46 -0400
Date: Wed, 19 May 2010 16:03:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@efficios.com
Subject: Re: [PATCH] block: remove all rcu head initializations
Message-ID: <20100519140344.GU25951@kernel.dk>
References: <20100518183603.GA6238@linux.vnet.ibm.com> <20100519062628.GF25951@kernel.dk> <20100519135401.GB2237@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519135401.GB2237@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19 2010, Paul E. McKenney wrote:
> On Wed, May 19, 2010 at 08:26:28AM +0200, Jens Axboe wrote:
> > On Tue, May 18 2010, Paul E. McKenney wrote:
> > > Hello, Jens,
> > > 
> > > Would you like to carry this patch, or should I push it up -tip?  If I
> > > don't hear otherwise from you, I will push it up -tip.  The
> > > INIT_RCU_HEAD() primitive is going away in favor of debugobjects.
> > 
> > I'll queue it up, thanks!
> 
> Let me know when you have it, and I will happily remove it from my
> tree.  ;-)

It was in when I sent the email, it's queued up in for-2.6.35 :-)

-- 
Jens Axboe

