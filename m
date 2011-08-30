Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1H3Xwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 19:52:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49036 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab1H3Xwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 19:52:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 31 Aug 2011 08:38:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Brestic <abrestic@google.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Revert "memcg: add memory.vmscan_stat"
Message-Id: <20110831083843.25d744bc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110830110337.GE13061@redhat.com>
References: <20110808124333.GA31739@redhat.com>
	<20110809083345.46cbc8de.kamezawa.hiroyu@jp.fujitsu.com>
	<20110829155113.GA21661@redhat.com>
	<20110830101233.ae416284.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830070424.GA13061@redhat.com>
	<20110830162050.f6c13c0c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830084245.GC13061@redhat.com>
	<20110830175609.4977ef7a.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830101726.GD13061@redhat.com>
	<20110830193406.361d758a.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830110337.GE13061@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 13:03:37 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Tue, Aug 30, 2011 at 07:34:06PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 30 Aug 2011 12:17:26 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:

> > How about fixing interface first ? 1st version of this patch was 
> > in April and no big change since then.
> > I don't want to be starved more.
> 
> Back then I mentioned all my concerns and alternate suggestions.
> Different from you, I explained and provided a reason for every single
> counter I wanted to add, suggested a basic pattern for how to
> interpret them to gain insight into memcg configurations and their
> behaviour.  No reaction.  If you want to make progress, than don't
> ignore concerns and arguments.  If my arguments are crap, then tell me
> why and we can move on.
> 

I think having percpu couneter has no performance benefit, just lose
extra memory by percpu allocation.
Anyway, you can change internal implemenatation when it's necessary.

But Ok, I agree using the same style as zone counters is better.

> What we have now is not ready.  It wasn't discussed properly, which
> certainly wasn't for the lack of interest in this change.  I just got
> tired of raising the same points over and over again without answer.
> 
> The amount of time a change has been around is not an argument for it
> to get merged.  On the other hand, the fact that it hasn't changed
> since April *even though* the implementation was opposed back then
> doesn't really speak for your way of getting this upstream, does it?

The fact is that you should revert the patch when it's merged to mmotm.

Please revert patch. And merge your own.
Anyway I don't have much interests in hierarchy.

Bye,
-Kame




