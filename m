Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab0J0GbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 02:31:05 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47074 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753243Ab0J0GbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 02:31:03 -0400
Date: Tue, 26 Oct 2010 09:31:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Ware, Ryan R" <ryan.r.ware@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle McMartin <kyle@mcmartin.ca>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>,
        "kernel@lists.fedoraproject.org" <kernel@lists.fedoraproject.org>,
        Mimi Zohar <zohar@us.ibm.com>,
        "warthog9@kernel.org" <warthog9@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Message-ID: <20101026073159.GA7049@ucw.cz>
References: <1287408660.2516.2.camel@localhost.localdomain>
 <C8E20010.1965B%ryan.r.ware@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8E20010.1965B%ryan.r.ware@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Good enough as a short-term thing I guess.
> >> > 
> >> > But the memory consumption which David described is plain nuttiness
> >>and
> >> > needs to be fixed, presumably by using a more appropriate data
> >>structure
> >> > for lookups.
> >> > 
> >> > However unless I missed it, nobody has yet stated that they intend to
> >> > fix this?
> >> 
> >> I think Eric said he is going to look at it.
> >> 
> >> Cheers,
> >> 
> >> Dave.
> >
> >Am looking at it as well.
> >
> >Mimi
> 
> I'll help look into this aspect too.
> 
> To be clear (since my first post seemed to go to the moderator), we will
> be using this starting with MeeGo 1.2.  Yes, this rather pigish memory
> usage needs to be addressed.  Let's focus on fixing that.  I'd say there
> are a number of options we can explore here to do that.

Curious... I see how NSA might want to use it, but MeeGo?
									Pavel



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
