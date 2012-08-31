Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2HaN6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:58:00 -0400
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:47029 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2HaN57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:57:59 -0400
Date: Fri, 31 Aug 2012 15:57:57 +0200
From: David Madore <david+ml@madore.org>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109
 __alloc_pages_nodemask+0x1d4/0x68c()
Message-ID: <20120831135757.GA26488@aldebaran.gro-tsen.net>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net>
 <20120829193220.GA6389@electric-eye.fr.zoreil.com>
 <20120831105936.GA4704@aldebaran.gro-tsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831105936.GA4704@aldebaran.gro-tsen.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 12:59:36PM +0200, David Madore wrote:
> On Wed, Aug 29, 2012 at 09:32:20PM +0200, Francois Romieu wrote:
> > David Madore <david+ml@madore.org> :
> > [...]
> > > I imagine it being somehow related to the fact that it operates a
> > > network bridge (I imagine this because I have another identical
> > > machine with exactly the same kernel and a very similar config but not
> > > running a bridge, and the warning never pops up).
> > 
> > Could it not be a genuine allocation failure ?
> 
> I have no idea.  How can I tell?  In any case, if having 512MB RAM
> isn't enough for the kernel in the router of a small home's network,
> that's a bug somewhere, isn't it?

PS: I'm also getting the following kind of messages from a wlan
interface that's on the bridge:

[  268.976317] ieee80211 phy0: failed to reallocate TX buffer
[  716.880515] ieee80211 phy0: failed to reallocate TX buffer
[ 1160.877677] ieee80211 phy0: failed to reallocate TX buffer

Could they be related?

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
