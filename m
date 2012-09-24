Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab2IXRjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:39:51 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:57569 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757309Ab2IXRju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:39:50 -0400
Date: Mon, 24 Sep 2012 17:39:49 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<cgroups@vger.kernel.org>" <cgroups@vger.kernel.org>,
        "<kamezawa.hiroyu@jp.fujitsu.com>" <kamezawa.hiroyu@jp.fujitsu.com>,
        "<devel@openvz.org>" <devel@openvz.org>,
        "<linux-mm@kvack.org>" <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in
 kmem_create_cache
In-Reply-To: <CAOJsxLGFWQFNUUN3sDeB2sn0S-QM-6Ut_d02HjmF6mB5aMytoA@mail.gmail.com>
Message-ID: <00000139f95d0ed4-ead604f1-6566-452f-85e9-6ea2cf5a05fa-000000@email.amazonses.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-6-git-send-email-glommer@parallels.com> <20120921181458.GG7264@google.com> <506015E7.8030900@parallels.com> <00000139f84bdedc-aae672a6-2908-4cb8-8ed3-8fedf67a21af-000000@email.amazonses.com>
 <50605500.5050606@parallels.com> <00000139f8836571-6ddc9d5b-1d5f-4542-92f9-ad11070e5b7d-000000@email.amazonses.com> <506063B8.70305@parallels.com> <00000139f890a302-980aee84-40b2-433f-8dbd-e7b1d219f00d-000000@email.amazonses.com> <506066E3.6050705@parallels.com>
 <CAOJsxLGFWQFNUUN3sDeB2sn0S-QM-6Ut_d02HjmF6mB5aMytoA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012, Pekka Enberg wrote:

> So Christoph is proposing that the new caches appear somewhere under
> the cgroups directory and /proc/slabinfo includes aggregated counts,
> right? I'm certainly OK with that.

Caches would appear either in cgroup/slabinfo (which would have the same
format as /proc/slabinfo) or in cgroup/slab/<slabname>/<fieldname>
(similar to /sys/kernel/slab/...)




