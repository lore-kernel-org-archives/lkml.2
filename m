Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0C3Pno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:43:44 -0400
Received: from nox.protox.org ([88.191.38.29]:47828 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0C3Pnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:43:43 -0400
Date: Tue, 30 Mar 2010 17:43:36 +0200
From: Jerome Glisse <glisse@freedesktop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm fixes
Message-ID: <20100330154336.GA1879@barney.localdomain>
References: <alpine.DEB.2.00.1003300530150.5127@skynet.skynet.ie>
 <21d7e9971003300007re486f22jbd2e98fcc104ac92@mail.gmail.com>
 <alpine.LFD.2.00.1003300724140.3579@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003300724140.3579@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 07:24:42AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 30 Mar 2010, Dave Airlie wrote:
> > 
> > Actually Linus, don't bother, consider this revoked, I'm going to kill 
> > the GPU reset code and re-send this tomorrow, its just a mess to get it 
> > back out of the tree at this point,
> > 
> > but I realised I was falling back to the old ways, of putting things 
> > with badness in, even if they helped a few people.
> 
> Hey, thanks. 
> 
> 		Linus

I will try to see if i can do a smaller version which only affect
r6xx/r7xx hw were it's know to be helpfull while leaving other hw
unaffected and working on a more reliable code for 2.6.35 for these
older hw.

Cheers.
Jerome
