Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2HUK5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:57:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab2HUK5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:57:10 -0400
Date: Tue, 21 Aug 2012 12:57:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 11/11] protect architectures where THREAD_SIZE >=
 PAGE_SIZE against fork bombs
Message-ID: <20120821105704.GF19797@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-12-git-send-email-glommer@parallels.com>
 <20120821093513.GD19797@dhcp22.suse.cz>
 <5033579D.5000203@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5033579D.5000203@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-08-12 13:40:45, Glauber Costa wrote:
> On 08/21/2012 01:35 PM, Michal Hocko wrote:
[...]
> > I am asking because this should trigger memcg-oom
> > but that one will usually pick up something else than the fork bomb
> > which would have a small memory footprint. But that needs to be handled
> > on the oom level obviously.
> > 
> Sure, but keep in mind that the main protection is against tasks *not*
> in this memcg.

Yes and that's is good step forward. I just wanted to mention that we
still have the problem inside the subhierarchy. The changelog was not
specific enough.
-- 
Michal Hocko
SUSE Labs
