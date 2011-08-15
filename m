Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1HOHnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:43:17 -0400
Received: from 1wt.eu ([62.212.114.60]:38743 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1HOHnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:43:16 -0400
Date: Mon, 15 Aug 2011 09:33:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        stable-review@kernel.org, stable@kernel.org
Subject: Re: [Stable-review] Future of the -longterm kernel releases (i.e. how we pick them).
Message-ID: <20110815073309.GB18367@1wt.eu>
References: <20110815041524.GA7578@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815041524.GA7578@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sun, Aug 14, 2011 at 09:15:24PM -0700, Greg KH wrote:
> As I'm giving a talk about the -stable and -longterm kernels this week
> at LinuxCon in Vancouver, and I've been talking with a lot of different
> people about the future of the -longterm kernels, here's some thoughts
> as to what I'm considering:
(...)
> Thoughts?

I think this is all good, and knowing in advance what next kernel will
be picked will help a lot of users because they'll be able to focus on
a given version.

I just have one comment about the 2-years : new devices generally ship
with something which is expected to be stable, so they won't ship with
the shiny new 2-digit kernel that was just released. This means that a
two-years lifecycle for the longterm kernels will allow less than 2
years of life for the device.

But possibly there are several types of products :
  - the ones where an upgrade may be forced on the user about once a
    year, so that the kernel can be between 1 and 2-years old
  - the ones that have to live longer without upgrades

I'm realizing that the second type is mostly the case for products
that are not easy to validate and are kept as-is without update as
long as they're supported, which is common in the network appliances
world (this is the reason I picked 2.6.27 ;-)).

Also, since your kernels are pretty stable after 2 years, updates are
quite rare and generally of minor importance. This is also the time I
choose to pick them for use in products where planning a reboot takes
weeks and an upgrade takes many months (I even know some people who are
currently ordering hardware to deploy 2.4). So it's likely that in 6
months I'll be interested in an almost frozen 2.6.32, and I will then
propose you to take it over and prolong its life when you drop it.

And in the end, I think this development model makes a lot of sense :
  - developers need a fast moving target
  - desktop users need something up to date with latest drivers and
    don't need the best stability => latest release or -stable are OK
  - most servers are happy with -stable (mine are)
  - distros need to focus on a recent -longterm and will contribute
    to its stability
  - some products need to ship with a very stable -longterm with
    rare updates

You're interested in the 4th category above and I'm in the 5th. So
in the end, I think that your proposal fits your expected target
perfectly well, and that if I want it to fit mine, I'll just have
to extend it myself as we've done till now. So that sounds good !

Thanks,
Willy

