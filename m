Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2HaK7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 06:59:40 -0400
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:46860 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2HaK7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 06:59:39 -0400
Date: Fri, 31 Aug 2012 12:59:36 +0200
From: David Madore <david+ml@madore.org>
To: linux-kernel@vger.kernel.org
Cc: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109
 __alloc_pages_nodemask+0x1d4/0x68c()
Message-ID: <20120831105936.GA4704@aldebaran.gro-tsen.net>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net>
 <20120829193220.GA6389@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829193220.GA6389@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 09:32:20PM +0200, Francois Romieu wrote:
> David Madore <david+ml@madore.org> :
> [...]
> > I imagine it being somehow related to the fact that it operates a
> > network bridge (I imagine this because I have another identical
> > machine with exactly the same kernel and a very similar config but not
> > running a bridge, and the warning never pops up).
> 
> Could it not be a genuine allocation failure ?

I have no idea.  How can I tell?  In any case, if having 512MB RAM
isn't enough for the kernel in the router of a small home's network,
that's a bug somewhere, isn't it?

Also:

On Wed, Aug 29, 2012 at 02:25:48AM +0200, David Madore wrote:
> Is this worth investigating?  (I will, of course, provide the config
> file and any other relevant data if the answer is "yes".)  Is this
> potentially serious?  (I'm getting hard lockups on this machine which
> I suspect are due to hardware and unrelated to this, but if someone
> tells me it could be the cause, I'd be more than happy to believe it.)

I'm now inclined to believe the hard lockups are indeed related to
this (I can semi-reproducibly make them happen with only network
traffic - actually, with the messages of a compilation taking place on
another machine being routed through this box (over IPv6)).

So how can I help debug this?  (One difficulty is that I have only
remote access to this box, and it's not meant for experimenting with.)

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
