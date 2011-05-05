Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1EEPRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:17:21 -0400
Received: from 1wt.eu ([62.212.114.60]:36025 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab1EEPRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:17:19 -0400
Date: Thu, 5 May 2011 17:17:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Greg KH <greg@kroah.com>, stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] -longterm kernels (Was: Re: Patch Upstream: iwlwifi: fix skb usage after free)
Message-ID: <20110505151702.GG2090@1wt.eu>
References: <201105030110.p431A5W0005426@hera.kernel.org> <20110504223605.GA5967@kroah.com> <20110505145854.GA4670@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505145854.GA4670@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 05, 2011 at 04:58:55PM +0200, Stanislaw Gruszka wrote:
> BTW, Greg, perhaps -logterm releasing policy should be revised somehow.
> Currently we have .32, .33, .34, .35 -longterm, what is kind a much. If
> I could suggest something, would be nice to have longterm chosen
> versions predictable and constants i.e. one from every 3 kernel
> releases, like .35, .38, .41 ... . That would make distributions, that
> try to do release every half year very happy, because they will know
> what kernel to choose, which will be widely supported and tested.

Longterm kernels are maintained on a voluntary basis, which explains
there is no rule. We had 2.6.16, 2.6.27 and now 2.6.32 which were
initially announced as longterm supported. When Greg announced dropping
2.6.27, I proposed to take it over because I have some uses for it and
I know other people who rely on it. Most likely for very similar reasons
Paul and Andi volunteered to maintain 2.6.34 and 2.6.35 alive.

I agree it would be much easier for everyone if all longterm kernels were
announced early. Still there are a lot of users who can't easily upgrade
for whatever reason and who are happy with someone keeping their kernel
updated. I tend to consider that Greg's kernels are more "official" than
other ones, and if some backporting must be done by patch authors, I think
it should be for these kernels first. Also, .32 is not that far away from
the 3 other longterm kernels, so when a developer writes a .32 backport,
chances are that adaptations will not be too hard for the 3 other ones.

> Also
> developers will have a bit less work with backporting fixes, as having
> same bug in n and n-3 release is less probable, than having the same bug
> in n and n-1.

While less probable, I'm still amazed by the number of fixes from -master
that still apply to 2.6.27, and sometimes (but to a less extent) even to
2.4.37 ! The fact that fixes and regressions span that many kernel versions
probably is one of the reasons there is demand for longterm kernels.

Just my 2 cents,
Willy

