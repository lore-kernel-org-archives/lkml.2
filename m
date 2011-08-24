Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1HXEsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:48:24 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48617 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691Ab1HXEsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:48:18 -0400
X-Sasl-enc: HJW8NnQPLHvDdXmhhcDWkBKKjzYZfM/GXE3aBkrFwJz0 1314161298
Date: Tue, 23 Aug 2011 21:47:38 -0700
From: Greg KH <greg@kroah.com>
To: david@lang.hm
Cc: Jeremiah Foster <jeremiah@jeremiahfoster.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [stable] [Stable-review] Future of the -longterm kernel releases
 (i.e. how we pick them).
Message-ID: <20110824044738.GD786@kroah.com>
References: <20110815041524.GA7578@kroah.com>
 <1313460542.2981.76.camel@deadeye>
 <17669FB8-C6FF-4B1F-9765-F1FD991D14CB@jeremiahfoster.com>
 <20110816223327.GA1534@kroah.com>
 <056B8993-8B70-470A-AFDD-53F587AF3312@jeremiahfoster.com>
 <alpine.DEB.2.02.1108171313040.6543@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1108171313040.6543@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 01:20:37PM -0700, david@lang.hm wrote:
> On Wed, 17 Aug 2011, Jeremiah Foster wrote:
> 
> >>Do they need help from the community
> >>instead to help define, implement, and maintain this for them?
> >
> >I think the answer is yes.
> >
> 
> to expand on this a bit.
> 
> it's a lot easier to look at changelogs and see if a -stable or
> -longterm update is relavent to your systems than it is to watch the
> flood of merges to the latest kerenl and then figure out how to
> backport them. BUt people who start up just compiling their own
> kernels frequently become testers, if not contributers to the
> kernel. If everyone only runs the distro kernels, then the upstream
> kernel quality will suffer because nobody is testing it.

I totally agree.

> people running -longterm kernels on their productionsystems will not
> be testing the llatest -rc kernel on those systems, but they are
> likely to be more interested in watching and testng new kernel
> releases (at least on lab machines) than people who just wait for
> things to be backported to the distro kernel.

That's good to hear, hopefully the -longterm kernels are useful for them
and their usage model.  If not, please let me know.

greg k-h
