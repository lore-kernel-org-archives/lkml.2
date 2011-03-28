Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1C1Khj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:37:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55629 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1C1Khi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:37:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Mar 2011 19:31:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: update documentation to describe usage_in_bytes
Message-Id: <20110328193108.07965b4a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110328094820.GC5693@tiehlicka.suse.cz>
References: <20110321102420.GB26047@tiehlicka.suse.cz>
	<20110322091014.27677ab3.kamezawa.hiroyu@jp.fujitsu.com>
	<20110322104723.fd81dddc.nishimura@mxp.nes.nec.co.jp>
	<20110322073150.GA12940@tiehlicka.suse.cz>
	<20110323092708.021d555d.nishimura@mxp.nes.nec.co.jp>
	<20110323133517.de33d624.kamezawa.hiroyu@jp.fujitsu.com>
	<20110328085508.c236e929.nishimura@mxp.nes.nec.co.jp>
	<20110328132550.08be4389.nishimura@mxp.nes.nec.co.jp>
	<20110328074341.GA5693@tiehlicka.suse.cz>
	<20110328181127.b8a2a1c5.kamezawa.hiroyu@jp.fujitsu.com>
	<20110328094820.GC5693@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 11:48:20 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Mon 28-03-11 18:11:27, KAMEZAWA Hiroyuki wrote:
> > On Mon, 28 Mar 2011 09:43:42 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > On Mon 28-03-11 13:25:50, Daisuke Nishimura wrote:
> > > > From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> [...]
> > > > +5.5 usage_in_bytes
> > > > +
> > > > +As described in 2.1, memory cgroup uses res_counter for tracking and limiting
> > > > +the memory usage. memory.usage_in_bytes shows the current res_counter usage for
> > > > +memory, and DOESN'T show a actual usage of RSS and Cache. It is usually bigger
> > > > +than the actual usage for a performance improvement reason. 
> > > 
> > > Isn't an explicit mention about caching charges better?
> > > 
> > 
> > It's difficult to distinguish which is spec. and which is implemnation details...
> 
> Sure. At least commit log should contain the implementation details IMO,
> though.
> 
> > 
> > My one here ;)
> > ==
> > 5.5 usage_in_bytes
> > 
> > For efficiency, as other kernel components, memory cgroup uses some optimization to
> > avoid unnecessary cacheline false sharing. usage_in_bytes is affected by the
> > method and doesn't show 'exact' value of usage, it's an fuzz value for efficient
> > access. (Of course, when necessary, it's synchronized.)
> > In usual, the value (RSS+CACHE) in memory.stat shows more exact value. IOW,
> 
> - In usual, the value (RSS+CACHE) in memory.stat shows more exact value. IOW,
> + (RSS+CACHE) value from memory.stat shows more exact value and should be used
> + by userspace. IOW,
> 
> ?
> 

seems good. Nishimura-san, could you update ?

Thanks,
-Kame

