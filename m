Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2DZN0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:26:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab2DZN0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:26:49 -0400
Date: Thu, 26 Apr 2012 15:26:08 +0200
From: Jan Kara <jack@suse.cz>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        swhiteho@redhat.com
Subject: Re: [PATCH 0/6] Get rid of I_MUTEX_QUOTA use
Message-ID: <20120426132608.GA10368@quack.suse.cz>
References: <1335387467-4928-1-git-send-email-jack@suse.cz>
 <20120425212532.GB3251@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425212532.GB3251@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 25-04-12 17:25:32, J. Bruce Fields wrote:
> On Wed, Apr 25, 2012 at 10:57:41PM +0200, Jan Kara wrote:
> > 
> >   Hello,
> > 
> >   this patch set changes generic quota code (and filesystems relying on it)
> > so that they don't use special locking class I_MUTEX_QUOTA. The only remaining
> > user of I_MUTEX_QUOTA is GFS2. If noone has objections, I can merge these
> > patches through my tree or Bruce, you can take them as your work depends
> > on these changes.
> 
> My changes will likely need to go through Al, and depend on GFS2 being
> fixed as well.
> 
> So it's up to Al.  Best might be to just merge it through your tree and
> let us sort it out in the next merge window?
  OK, I've added patches to my tree for now. I also sent a patch for GFS2
but after some investigation that's mostly a cleanup grade and Steven can
merge it independently. Quota inode in GFS2 is hidden system file so there
should be no locking problems with it wrt your patches.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
