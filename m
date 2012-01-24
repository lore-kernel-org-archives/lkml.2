Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2AXQyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:54:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab2AXQyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:54:44 -0500
Date: Tue, 24 Jan 2012 08:43:16 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paolo Bonzini <pbonzini@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@suse.de>
Subject: Re: [23/27] kernel.h: add printk_ratelimited and pr_<level>_rl
Message-ID: <20120124164316.GA26126@suse.de>
References: <20120123234224.GA19510@kroah.com>
 <20120123234203.649739932@clark.kroah.org>
 <20120124144613.GD3180@pcarmody2.research.nokia.com>
 <1327422950.5400.40.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327422950.5400.40.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 04:35:50PM +0000, Ben Hutchings wrote:
> On Tue, 2012-01-24 at 16:46 +0200, Phil Carmody wrote:
> > On 23/01/12 15:41 -0800, ext Greg KH wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > This looks like an added feature with no users in .32 - does it really 
> > belong in a stable tree?
> > (But to be explicit, I have no issue with its contents at all.)
> 
> It's required for commit 0bfc96cb77224736dfa35c3c555d37b3646ef35e
> ('block: fail SCSI passthrough ioctls on partition devices'), though
> that hasn't actually been included in this series.  I think that's
> because there is still ongoing discussion of which error codes need to
> be used.

That is exactly right.

Phil, thanks for reviewing, you are correct that this is a new
"feature", but it is needed for this other patch that people are still
arguing over :)

thanks,

greg k-h
