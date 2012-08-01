Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2HARRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:17:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42862 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2HARRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:17:08 -0400
Date: Wed, 1 Aug 2012 10:15:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/3] Introduce percpu rw semaphores
Message-ID: <20120801171527.GB2491@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
 <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
 <1343508252.2626.13184.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
 <20120730170013.GA4778@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1207301955370.4547@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207301955370.4547@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080117-4242-0000-0000-0000027DA114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 08:00:19PM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 30 Jul 2012, Paul E. McKenney wrote:
> 
> > On Sun, Jul 29, 2012 at 01:13:34AM -0400, Mikulas Patocka wrote:
> > > On Sat, 28 Jul 2012, Eric Dumazet wrote:
> > > > On Sat, 2012-07-28 at 12:41 -0400, Mikulas Patocka wrote:
> > 
> > [ . . . ]
> > 
> > > > (bdev->bd_block_size should be read exactly once )
> > > 
> > > Rewrite all direct and non-direct io code so that it reads block size just 
> > > once ...
> > 
> > For whatever it is worth, the 3.5 Linux kernel only has about ten mentions
> > of bd_block_size, at least according to cscope.
> 
> plus 213 uses of i_blkbits (which is derived directly from bd_block_size). 
> 45 of them is in fs/*.c and mm/*.c

At least it is only hundreds rather than thousands!  ;-)

							Thanx, Paul

