Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2BCUe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:34:57 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35621 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757592Ab2BCUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:34:54 -0500
X-Sasl-enc: VGQe1DCSoWwk+dvJ82Nnq66u5FaK6exyqYMvofNLp4Nx 1328301293
Date: Fri, 3 Feb 2012 12:34:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: tim.gardner@canonical.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: Linux 3.2.3
Message-ID: <20120203203446.GA15738@kroah.com>
References: <20120203174758.GA18584@kroah.com>
 <4F2C2A40.1080601@canonical.com>
 <20120203185157.GA2865@kroah.com>
 <20120203185319.GA1710@kroah.com>
 <20120203185459.GA7321@kroah.com>
 <20120203191439.GB23505@opensource.wolfsonmicro.com>
 <20120203192216.GA12724@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203192216.GA12724@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 11:22:16AM -0800, Greg KH wrote:
> On Fri, Feb 03, 2012 at 07:14:39PM +0000, Mark Brown wrote:
> > On Fri, Feb 03, 2012 at 10:54:59AM -0800, Greg KH wrote:
> > > On Fri, Feb 03, 2012 at 10:53:19AM -0800, Greg KH wrote:
> > 
> > > > Yes, the above commit fixes the build for me, thanks, I'll go release
> > > > 3.2.4 with this build fix in it, thanks Tim for letting me know.
> > 
> > > Hm, no, I don't think I'll really trust that patch for a -stable
> > > release, it looks like:
> > 
> > That's not -stable material at all.  The functions concerned will need
> > to be replaced with their snd_soc equivalents:
> > 
> > 	regache_cache_bypass -> assign to codec->cache_bypass
> > 	regcache_cache_only -> assign to codec->cache_only
> > 
> > It may be Monday before I can cook up a patch.
> 
> How about I just revert the 2 patches Tim pointed out, which will get
> 3.2.3 building properly, and then you can resend them when you get them
> reworked sometime in the future?

This seems the simplest, I've now done this and will release 3.2.4 in a
short while.

greg k-h
