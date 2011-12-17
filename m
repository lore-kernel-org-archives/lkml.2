Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1LQXu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 18:50:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35198 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1LQXuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 18:50:55 -0500
Date: Sun, 18 Dec 2011 02:47:30 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Namhyung Kim <namhyung@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: fput() called in loop_clr_fd() may cause bd_mutex
 recursive locking
Message-ID: <20111217234730.GE3313@swordfish>
References: <20111217215333.GA3313@swordfish>
 <20111217221232.GA2203@ZenIV.linux.org.uk>
 <20111217221928.GB3313@swordfish>
 <20111217223033.GB2203@ZenIV.linux.org.uk>
 <20111217223745.GC3313@swordfish>
 <20111217225846.GC2203@ZenIV.linux.org.uk>
 <20111217232053.GD3313@swordfish>
 <20111217233857.GD2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111217233857.GD2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/17/11 23:38), Al Viro wrote:
> On Sun, Dec 18, 2011 at 02:20:53AM +0300, Sergey Senozhatsky wrote:
> 
> > > IOW, we have to prevent such setups anyway and not just because of
> > > problems on close() - they would be deadly on read() and write()...
> > > 
> > 
> > Preventing recursion in the first place? For example, in lo_open()?
> 
> Uh?  No, in loop_set_fd(), where we decide what loop devices will be
> backed by what - the code I quoted to you upthread.
> 

Oops, sorry. Long day at work . Need to sleep.

	Sergey
