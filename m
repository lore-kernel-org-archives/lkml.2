Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0D0ACS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 20:02:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:57049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab0D0ACR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 20:02:17 -0400
Date: Mon, 26 Apr 2010 17:02:02 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Hans-Peter Jansen <hpj@urpla.net>, xfs@oss.sgi.com,
       opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
 [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100427000202.GA31470@suse.de>
References: <201004050049.17952.hpj@urpla.net>
 <20100413091823.GD7544@dastard>
 <201004131142.33518.hpj@urpla.net>
 <201004241844.23482.hpj@urpla.net>
 <20100425162740.GB19195@suse.de>
 <20100426003637.GB11437@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426003637.GB11437@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 10:36:37AM +1000, Dave Chinner wrote:
> On Sun, Apr 25, 2010 at 09:27:40AM -0700, Greg KH wrote:
> > On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> > > FYI, 2.6.33.2 is still affected from this issue. 
> > 
> > Is 2.6.33.3-rc2 affected?  A lot of xfs patches are in there (as are in
> > 2.6.32.12-rc2.)
> 
> The fix is not in Linus' kernel yet, Greg. So once that is done,
> I'll have to backport the fix back to those stable kernels as well.
> It's not a trivial fix, so it will miss this round of stable
> releases....

Ok, that's fine, just checking.  I'm in no rush, I have plenty of other
patches to queue up for the next stable releases :)

thanks,

greg k-h
