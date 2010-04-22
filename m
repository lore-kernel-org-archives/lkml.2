Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0DVDpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 23:45:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0DVDpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 23:45:08 -0400
Date: Wed, 21 Apr 2010 20:45:32 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's the staging review and acceptance process?
Message-ID: <20100422034532.GA25177@suse.de>
References: <1271881967.1730.482.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271881967.1730.482.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 01:32:47PM -0700, Joe Perches wrote:
> Hi Greg.
> 
> Sice your fosdem talk and tuxradar article came out there
> have been many patches against staging by new contributors
> (I did some too) that seem to get no feedback or get dropped
> without comment.  Because many of these patches are first
> attempts, probably most of them should not be applied in the
> first submitted form.  I comment on some every once in awhile,
> but the number of patches appear to go unnoticed or untracked
> seems quite high.

I have around 600 still left to go through.  It was an unfortunate set
of timing, the talk, article, and then I up and moved a few hundred
miles and decided to attend a few conferences, as well as maintaining 4
stable trees at the same time.  That caused the huge backlog staring at
me right now.

> Do you have enough bandwidth to keep these new contributors
> engaged?  Anything I can do to help?

Your reviews like you have been doing, when you see something obviously
wrong, is great.  I just went through 100 patches, and only 40 of them
were "valid" and able to be applied, so it is a high rejection rate
which requires a lot of attention to be paid to them.

> What is your current review/notify/accept/reject workflow?

Like it's always been:
  - patch comes in
  - I get around to reviewing it
  - if valid, I apply and you get an email
  - if invalid, I reject and say why in email

> Perhaps a patchwork queue for staging might help track these
> patches and with more feedback or reviewers, get them in
> shape to be applied.

patchwork doesn't work well for my patch flow, but maybe that is because
I haven't spent enough time with it.  Right now I have all the patches,
it's just a matter of getting through them.

thanks,

greg k-h
