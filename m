Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2EaL7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:59:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50417 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab2EaL7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:59:42 -0400
Subject: Re: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <alpine.LRH.2.00.1205311343080.14604@twin.jikos.cz>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
	 <1338456918.2760.1318.camel@edumazet-glaptop>
	 <alpine.LRH.2.00.1205311343080.14604@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 May 2012 13:59:38 +0200
Message-ID: <1338465578.2760.1340.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 13:45 +0200, Jiri Kosina wrote:
> On Thu, 31 May 2012, Eric Dumazet wrote:
> 
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > tty_lock_pair() do the right thing to avoid deadlocks, but should
> > instruct LOCKDEP of this to avoid a splat. 
> 
> I have submitted very similar patch to Greg/Alan already 3 days ago[1], 
> but have been told that this is already fixed. Apparently it wasn't?
> 
> [1] https://lkml.org/lkml/2012/5/28/226

I saw that right now.

Not sure your patch is the right fix with hard coded 1 and 2 values ?

0 and 1 should be enough.




