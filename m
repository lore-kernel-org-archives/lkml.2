Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0IXNVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:21:43 -0400
Received: from kroah.org ([198.145.64.141]:52597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0IXNVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:21:42 -0400
Date: Fri, 24 Sep 2010 06:19:14 -0700
From: Greg KH <greg@kroah.com>
To: Geoffrey Said <geoffrey@2x.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Long maintenance kernel versions.
Message-ID: <20100924131914.GA1965@kroah.com>
References: <AANLkTinGJmAzdd=HOKZYSh69F6T9HMznOKW5BS90=Q-4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinGJmAzdd=HOKZYSh69F6T9HMznOKW5BS90=Q-4@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 07:10:09AM +0200, Geoffrey Said wrote:
> To whom it may concern.
> 
> I would like to put forward the following questions.  Hope that I am
> not making a fool of myself!
> 
> How is the procedure by which a certain kernel version is declared as
> a long maintenance version?

There really isn't a set procedure yet.

> Is the version decided before or after the release of the stable kernel?

Sometimes after, sometimes before.

> And where can I check for planned long term maintenance versions?

You can ask.

Here's how the last 3 "long-term" releases came about:
  .16 - turned out that my employeer was using it for an enterprise
        kernel release, so it made my "day job" a lot easier to keep it
	going for a longer-than-normal period of time.  People liked
	this, so it kept going.
  .27 - Same as before.
  .32 - Now things got interesting.  Some kernel developers who "worked"
        for different distros got together and talked about picking a
	release that their distros could sync up on and become a
	long-term released kernel.  That ended up being the .32 kernel
	and we planned it ahead of time.  This resulted in all of the
	major distros relying on this kernel for their releases.

And that's it.  Pretty simple, but effective.

> I am asking the above questions because we are migrating our Linux OS
> to the 2.6.34 kernel and we have learned that this will not be
> actively maintained and we are advised to switch to the 35 one.
> Since a lot of effort has been put to migrate to the 2.6.34 kernel and
> a lot of testing has been done, it is frustrating to hear the above
> news.

You can always ask me ahead of time what is going on with this type of
thing, that's the best way.  I am easy to get ahold of if you have
questions like this.

> From our point of view it would be nice to declare a version log term
> maintenance before or at least on release so that we can migrate
> between long-term kernels.

For .32, I did announce this ahead of time, perhaps you missed that.

Hope this helps,

greg k-h
