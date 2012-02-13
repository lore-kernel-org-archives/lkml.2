Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2BMOLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:11:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab2BMOLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:11:51 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <htejun@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: exit_aio() hang after I/O failure
References: <CAO+b5-orBaZMmmw1_5Jo+oSEDu8yXrXt-cAcZxQeqkmFkP8efA@mail.gmail.com>
	<x49ipk2bdkn.fsf@segfault.boston.devel.redhat.com>
	<CAO+b5-q9zYWiBLJMyXEfY1EhOyQtKLs5rPyx+n+Tf79=6WiK1g@mail.gmail.com>
	<CAO+b5-pCQmz=c5na5vmLAWm=2Ps2ts33v2ZMkJGTjaMohzysLA@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 13 Feb 2012 09:11:43 -0500
In-Reply-To: <CAO+b5-pCQmz=c5na5vmLAWm=2Ps2ts33v2ZMkJGTjaMohzysLA@mail.gmail.com>
	(Bart Van Assche's message of "Sat, 11 Feb 2012 18:30:42 +0000")
Message-ID: <x49lio6yg9s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On Mon, Jan 23, 2012 at 4:47 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>> On Mon, Jan 23, 2012 at 4:15 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> > Bart Van Assche <bvanassche@acm.org> writes:
>> > > Apparently processes can hang in exit_aio() with at least kernel 3.2.1
>> > > after an I/O failure. Has anyone seen this before ?
>> > >
>> > > This occurred after a SCSI device had been removed entirely (and hence
>> > > after all I/O requests were killed by scsi_remove_host()).
>> >
>> > Fixed here:
>> >
>> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69e4747ee9727d660b88d7e1efe0f4afcb35db1b
>>
>> Thanks a lot for the feedback - I'll give this patch a try.
>
> Bad news: I've been able to reproduce exactly the same call stack with
> kernel 3.2.5. That kernel version includes the aforementioned commit.

OK, thanks for testing.  I'll try to reproduce this.

Cheers,
Jeff
