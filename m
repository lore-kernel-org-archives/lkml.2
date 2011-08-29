Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1H2OBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:01:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab1H2OBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:01:17 -0400
Date: Mon, 29 Aug 2011 16:00:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iwlegacy: change IWL_WARN to IWL_DEBUG_HT in
 iwl4965_tx_agg_start
Message-ID: <20110829140032.GA1573@redhat.com>
References: <1314537977-20097-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <20110829122013.GA3597@redhat.com>
 <4E5B9533.6000109@cuw.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5B9533.6000109@cuw.edu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

On Mon, Aug 29, 2011 at 08:33:39AM -0500, Greg Dietsche wrote:
> On 08/29/2011 07:20 AM, Stanislaw Gruszka wrote:
> >On Sun, Aug 28, 2011 at 08:26:16AM -0500, Greg Dietsche wrote:
> >>This message should be a debug message and not a warning. So
> >>change it from IWL_WARN to IWL_DEBUG_HT.
> >I'm currently doing massive iwlegacy driver cleanup. Would be easier
> >for me to apply these patches on top of my changes instead of rebase
> >my patches. I will queue these two patches and post them together with
> >my pending patches.
> >
> That sounds good to me. I have the 4065 card in my laptop and want
> to learn how it works. If you want someone to test your changes, I'm
> willing.
> 
> I have six other patches that are trivial in nature for the iwlegacy
> driver. One of those also applies to the iwlagn driver, so seven
> patches in total. They remove some null checks that aren't necessary
> and also cleanup a few unused variables. There are two patches in
> the set that I'm not 100% sure about. They remove null checks and I
> haven't been able to prove to myself that they are correct. However,
> if they aren't correct, then there are some null checks in other
> places that need to be added....
> 
> Anyway, I can hold off on these until you've done your cleanup and
> see what still applies,

That would be great.

> or if you have a tree someplace, I'd be
> happy to rebase them for you.

I do not have publicly available tree. I'll probably try to get
one on git.kernel.org. I will let you know.

Thanks,
Stanislaw
