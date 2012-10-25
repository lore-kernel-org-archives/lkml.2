Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab2JYSIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:08:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33608 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760064Ab2JYSIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:08:17 -0400
Date: Thu, 25 Oct 2012 11:08:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: JoonSoo Kim <js1304@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 08/18] memcg: infrastructure to match an allocation to
 the right cache
Message-ID: <20121025180812.GN11442@htj.dyndns.org>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
 <1350656442-1523-9-git-send-email-glommer@parallels.com>
 <CAAmzW4N40MedsCfcj+eiM-i6cU65n3z7uy08YFyknXbBKj7Z-g@mail.gmail.com>
 <50891CF2.3030400@parallels.com>
 <20121025180652.GM11442@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025180652.GM11442@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:06:52AM -0700, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Thu, Oct 25, 2012 at 03:05:22PM +0400, Glauber Costa wrote:
> > > Is there any rmb() pair?
> > > As far as I know, without rmb(), wmb() doesn't guarantee anything.
> > > 
> > 
> > There should be. But it seems I missed it. Speaking of which, I should
> 
> You probably can use read_barrier_depends().

Ooh, and when you use memory barrier pairs, please make sure to
comment on both sides explaining how they're paired and why.  There's
nothing more frustrating than barriers without clear annotation.

Thanks.

-- 
tejun
