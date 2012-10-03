Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2JCUtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:49:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55047 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab2JCUtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:49:23 -0400
Date: Wed, 3 Oct 2012 13:49:19 -0700
From: Kees Cook <kees@outflux.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121003204919.GA9092@outflux.net>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
 <20121003194614.GA2893@elliptictech.com>
 <20121003200515.GZ9092@outflux.net>
 <CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
 <20121003204141.GB6026@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003204141.GB6026@thunk.org>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:41:41PM -0400, Theodore Ts'o wrote:
> On Wed, Oct 03, 2012 at 01:29:15PM -0700, Linus Torvalds wrote:
> > On Wed, Oct 3, 2012 at 1:05 PM, Kees Cook <kees@outflux.net> wrote:
> > >
> > > 3.6 introduced link restrictions:
> > 
> > Hmm. If this causes problems for others, I suspect we need to turn it
> > off by default.
> > 
> > It's a nice security thing, but considering how quickly people started
> > complaining after 3.6 was out, I suspect we'll see more of these, and
> > we may not have any choice.
> 
> True, although I'm not sure we should be encouraging kernel developers
> to have world-writeable directories.  I suppose if it's a single-user
> workstation it wouldn't matter, but you could imagine a daemon running
> has "nobody" which has a stack overflow bug, and then if the user has
> been careless and uses umasks so that directories in their home
> directory are world writeable, well.....
> 
> Regardless of whether or not we turn this security feature off by
> default, I think it's worthwhile to look at how and why did Nick's
> directories become world-writeable, and whether there is so distro
> default which is causing or encouraging this.

I think the benefits of this being on by default outweigh glitches
like this. Based on Nick's email, it looks like a directory tree of his
own creation.

-Kees

-- 
Kees Cook                                            @outflux.net
