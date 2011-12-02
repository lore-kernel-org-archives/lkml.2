Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1LBMcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:32:14 -0500
Received: from mail.openrapids.net ([64.15.138.104]:34072 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754407Ab1LBMcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:32:13 -0500
Date: Fri, 2 Dec 2011 07:32:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jens Axboe <jens@axboe.dk>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] fs/splice: export splice_to_pipe to GPL modules
Message-ID: <20111202123211.GA13082@Krystal>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com> <1322775683-8741-4-git-send-email-mathieu.desnoyers@efficios.com> <4ED87C02.6030007@axboe.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED87C02.6030007@axboe.dk>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:31:02 up 373 days, 17:34,  2 users,  load average: 0.06, 0.13,
	0.43
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (jens@axboe.dk) wrote:
> On 2011-12-01 22:41, Mathieu Desnoyers wrote:
> > The LTTng driver needs this symbol exported because it implements its
> > own splice actor.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: Linus Torvalds <torvalds@linux-foundation.org>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: linux-kernel@vger.kernel.org
> > CC: Greg KH <greg@kroah.com>
> > ---
> >  fs/splice.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/splice.c b/fs/splice.c
> > index fa2defa..9eb15b5 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -263,6 +263,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
> >  
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(splice_to_pipe);
> 
> The rest of the splice symbols are regular exports, please do the same
> for this one. Thanks.

I've been wondering about this one, but thought it would be better to
let you decide on opening up the symbol more than with _GPL. Will do!

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
