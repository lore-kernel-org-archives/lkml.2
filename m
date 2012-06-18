Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2FRWm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:42:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33497 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2FRWm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:42:58 -0400
Date: Mon, 18 Jun 2012 15:42:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        Jej B <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init
 rq->end_io before checking for dead queue.
Message-ID: <20120618224253.GH32733@google.com>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
 <4FD345DC.6020405@acm.org>
 <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
 <4FD4DC26.5080902@acm.org>
 <CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com>
 <CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 02:23:23PM -0700, Muthu Kumar wrote:
> On Mon, Jun 11, 2012 at 10:33 AM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
> > On Sun, Jun 10, 2012 at 10:40 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> >> On 06/09/12 23:57, Muthu Kumar wrote:
> >>
> >>> Locking change is the one you posted already (the link above). Anyway,
> >>> I have the attached patch *including* the locking change. Original
> >>> mail has attachment without locking change. Please use whatever you
> >>> need.
> >>
> >>
> >> While we are at it ... the rq->rq_disk and rq->end_io assignments can be
> >> performed safely before the spinlock is taken, isn't it ?
> >>
> >
> > Yes.. that spinlock is to protect the q.
> >
> 
> Attached patch with assignment performed before taking the spinlock.

This looks correct to me.  Bart, can you please include this patch in
your series and repost the series?

Thank you.

-- 
tejun
