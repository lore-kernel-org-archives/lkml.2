Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2KVSf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:35:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab2KVSfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:35:55 -0500
Date: Wed, 21 Nov 2012 22:37:32 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
        tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 1/9] vfs: Handle O_SYNC AIO DIO in generic code properly
Message-ID: <20121121213732.GG30250@quack.suse.cz>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
 <20121120074123.24645.41965.stgit@blackbox.djwong.org>
 <20121121100809.GE23339@infradead.org>
 <x497gpevqoy.fsf@segfault.boston.devel.redhat.com>
 <20121121182901.GA4519@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121182901.GA4519@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 21-11-12 13:29:01, Christoph Hellwig wrote:
> On Wed, Nov 21, 2012 at 11:58:05AM -0500, Jeff Moyer wrote:
> > > I'd like to use this as a vehicle to revisit how dio completions work.
> > 
> > I don't like the sound of that.  ;-)  It sounds like this bugfix may get
> > further delayed by the desire for unrelated code cleanup.
> 
> I've got a prototype that isn't much more invasive than the current
> series.  I'll finish it up and run it through QA and will post it
> tomorrow.
  Great, I wanted to have a look into it but you beat me to it ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
