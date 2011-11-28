Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1K1XDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:03:17 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59702 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab1K1XDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:03:16 -0500
Date: Mon, 28 Nov 2011 15:02:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 9/9] tile: Make tile use the new
 is_idle_task() API
Message-ID: <20111128230207.GN2346@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-9-git-send-email-paulmck@linux.vnet.ibm.com>
 <4ECD276F.3050801@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECD276F.3050801@tilera.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112823-5930-0000-0000-000002A5DFA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:03:43PM -0500, Chris Metcalf wrote:
> (Narrowing cc's)
> 
> On 11/15/2011 3:30 PM, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > Change from direct comparison of ->pid with zero to is_idle_task().
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  arch/tile/mm/fault.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> 
> Please cc me on changes to tile architecture files - thanks!
> I picked this up while belatedly catching up on LKML.

My apologies -- I have added your Acked-by (thank you!) and will try
harder to get the CCs right in the future.

							Thanx, Paul

