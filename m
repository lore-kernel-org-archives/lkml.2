Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab2I0MQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:16:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab2I0MQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:16:00 -0400
Date: Thu, 27 Sep 2012 14:15:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120927121558.GB29104@dhcp22.suse.cz>
References: <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120926221046.GA10453@mtj.dyndns.org>
 <506381B2.2060806@parallels.com>
 <20120926224235.GB10453@mtj.dyndns.org>
 <50638793.7060806@parallels.com>
 <20120926230807.GC10453@mtj.dyndns.org>
 <50638DBB.4000002@parallels.com>
 <20120926233334.GD10453@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926233334.GD10453@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-09-12 16:33:34, Tejun Heo wrote:
[...]
> > > So, this seems properly crazy to me at the similar level of
> > > use_hierarchy fiasco.  I'm gonna NACK on this.
> > 
> > As I said: all use cases I particularly care about are covered by a
> > global switch.
> > 
> > I am laying down my views because I really believe they make more sense.
> > But at some point, of course, I'll shut up if I believe I am a lone voice.
> > 
> > I believe it should still be good to hear from mhocko and kame, but from
> > your point of view, would all the rest, plus the introduction of a
> > global switch make it acceptable to you?
> 
> The only thing I'm whining about is per-node switch + silently
> ignoring past accounting, so if those two are solved, I think I'm
> pretty happy with the rest.

I think that per-group "switch" is not nice as well but if we make it
hierarchy specific (which I am proposing for quite some time) and do not
let enable accounting for a group with tasks then we get both
flexibility and reasonable semantic. A global switch sounds too coars to
me and it really not necessary.

Would this work with you?
-- 
Michal Hocko
SUSE Labs
