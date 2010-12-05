Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0LERBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:01:43 -0500
Received: from kroah.org ([198.145.64.141]:60704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab0LERBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:01:42 -0500
Date: Sun, 5 Dec 2010 08:50:34 -0800
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com, Andi Kleen <andi@firstfloor.org>,
        lwn@lwn.net
Subject: Re: Announcement: Plans for v2.6.34-longterm
Message-ID: <20101205165034.GA15738@kroah.com>
References: <20101203210719.GB21223@windriver.com>
 <20101204172840.GC10282@kroah.com>
 <20101205011644.GB314@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101205011644.GB314@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 04, 2010 at 08:16:44PM -0500, Paul Gortmaker wrote:
> [Re: Announcement: Plans for v2.6.34-longterm] On 04/12/2010 (Sat 09:28) Greg KH wrote:
> 
> > On Fri, Dec 03, 2010 at 04:07:19PM -0500, Paul Gortmaker wrote:
> > > With that in mind, it is our intention to also maintain a 2.6.34
> > > longterm tree.  Jason and I work at Wind River, which already has
> > > released products based on v2.6.34, and as such it only makes sense
> > > to have a public long-term tree that others who are also based on
> > > 2.6.34 can make use of.
> > 
> > Other than Wind River, what other distros/userbases are using .34 as a
> > platform for their products?
> 
> Well, since we create more of a distro builder, than a distro itself,
> anyone who uses WR to in turn create a distro for their own hardware or
> product will of course be using 2.6.34.  The Yocto project is currently
> using the 2.6.34 kernel and I'm sure there are others I'm not
> immediately aware of.

I thought Yocto was going to be using .35, hence Andi and Tim's work to
get that one "longterm"?

Anyway, that's fine, I was just curious, thanks.

> > And how long do you expect to be maintaining this .34 branch for?
> 
> The expectation is that maintenance will be ongoing for years, since
> we'll largely be needing to do that work anyway.  I plan to follow your
> lead on how you handled .27 -- i.e. the "early" releases will possibly
> be rich with content, but as it gets to be closer to EOL (i.e. on the
> order of 10 releases removed from current), then it will only be the key
> CVE-like fixes and similar which will be added.

That sounds very reasonable.

If there's anything I can do to help out, let me know.

thanks,

greg k-h
