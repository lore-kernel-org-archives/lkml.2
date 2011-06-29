Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1F2Uzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:55:45 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:56910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1F2Uzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:55:43 -0400
Subject: Re: [PATCH] net, wireless: Don't return uninitialized in
 __cfg80211_stop_sched_scan()
From: Johannes Berg <johannes@sipsolutions.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <alpine.LNX.2.00.1106292241230.3747@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106292212110.3747@swampdragon.chaosbits.net>
	 <1309379244.4071.7.camel@jlt3.sipsolutions.net>
	 <1309379630.1514.122.camel@cumari>
	 <alpine.LNX.2.00.1106292241230.3747@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 22:55:40 +0200
Message-ID: <1309380940.4071.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 22:42 +0200, Jesper Juhl wrote:
> On Wed, 29 Jun 2011, Luciano Coelho wrote:
> 
> > On Wed, 2011-06-29 at 22:27 +0200, Johannes Berg wrote: 
> > > On Wed, 2011-06-29 at 22:13 +0200, Jesper Juhl wrote:
> > > > If the 'driver_initiated' function argument to
> > > > __cfg80211_stop_sched_scan() is not 0 then we'll return an
> > > > uninitialized 'ret' from the function.
> > > 
> > > 'err'. I also dislike the initialisation, can we just replace the
> > > "return err;" at the end of the function with "return 0;" instead?
> > 
> > Luckily we were never using the return value when passing
> > driver_initiate =- false.
> > 
> > And I agree with you, there's no use to return err at the end.  Better
> > to simply return 0.
> > 
> Ok, so how about this?

Fine with me.

johannes


