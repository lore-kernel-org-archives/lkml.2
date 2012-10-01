Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2JAMg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:36:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab2JAMgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:36:55 -0400
Date: Mon, 1 Oct 2012 14:36:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 09/13] memcg: kmem accounting lifecycle management
Message-ID: <20121001123654.GJ8622@dhcp22.suse.cz>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-10-git-send-email-glommer@parallels.com>
 <20121001121553.GG8622@dhcp22.suse.cz>
 <50698C97.70703@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50698C97.70703@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-10-12 16:29:11, Glauber Costa wrote:
> On 10/01/2012 04:15 PM, Michal Hocko wrote:
> > Based on the previous discussions I guess this one will get reworked,
> > right?
> > 
> 
> Yes, but most of it stayed. The hierarchy part is gone, but because we
> will still have kmem pages floating around (potentially), I am still
> using the mark_dead() trick with the corresponding get when kmem_accounted.

Is it OK if I hold on with the review of this one until the next
version?
-- 
Michal Hocko
SUSE Labs
