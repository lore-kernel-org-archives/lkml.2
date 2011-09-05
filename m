Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1IEMoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:44:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:30322 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1IEMoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:44:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,333,1312182000"; 
   d="scan'208";a="45683823"
Date: Mon, 5 Sep 2011 20:44:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jaxboe@fusionio.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: Add comment explaining task state setting in
 bdi_forker_thread()
Message-ID: <20110905124411.GA794@localhost>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
 <1315004059-9844-3-git-send-email-jack@suse.cz>
 <20110904030551.GB16361@localhost>
 <20110905100141.GA5466@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110905100141.GA5466@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 06:01:41PM +0800, Jan Kara wrote:
> On Sun 04-09-11 11:05:51, Wu Fengguang wrote:
> > > @@ -401,6 +401,13 @@ static int bdi_forker_thread(void *ptr)
> > >  		}
> > >  
> > >  		spin_lock_bh(&bdi_lock);
> > > +		/*
> > > +		 * In the following loop we are going to check whether we have
> > > +		 * some work to do without any synchronization with tasks
> > > +		 * waking us up to do work for them. So we have to set task
> > > +		 * state already here so that we don't miss wakeups coming
> > 
> > s/already/early/ ?
>   Thanks for review. We'd have to substitute 'already here' with 'early'
> for the sentence to make make sense. But frankly I don't see why one would
> be better than the other one...

You are the native English speaker?  OK, I have no more problems... ;)

Thanks,
Fengguang
