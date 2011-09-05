Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1IEPx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:53:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1IEPxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:53:50 -0400
Date: Mon, 5 Sep 2011 17:53:47 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <jaxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: Add comment explaining task state setting in
 bdi_forker_thread()
Message-ID: <20110905155347.GA17354@quack.suse.cz>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
 <1315004059-9844-3-git-send-email-jack@suse.cz>
 <20110904030551.GB16361@localhost>
 <20110905100141.GA5466@quack.suse.cz>
 <20110905124411.GA794@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110905124411.GA794@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 05-09-11 20:44:11, Wu Fengguang wrote:
> On Mon, Sep 05, 2011 at 06:01:41PM +0800, Jan Kara wrote:
> > On Sun 04-09-11 11:05:51, Wu Fengguang wrote:
> > > > @@ -401,6 +401,13 @@ static int bdi_forker_thread(void *ptr)
> > > >  		}
> > > >  
> > > >  		spin_lock_bh(&bdi_lock);
> > > > +		/*
> > > > +		 * In the following loop we are going to check whether we have
> > > > +		 * some work to do without any synchronization with tasks
> > > > +		 * waking us up to do work for them. So we have to set task
> > > > +		 * state already here so that we don't miss wakeups coming
> > > 
> > > s/already/early/ ?
> >   Thanks for review. We'd have to substitute 'already here' with 'early'
> > for the sentence to make make sense. But frankly I don't see why one would
> > be better than the other one...
> 
> You are the native English speaker?  OK, I have no more problems... ;)
  No, I'm not a native English speaker. Maybe that's why I don't see that
much difference :-))

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
