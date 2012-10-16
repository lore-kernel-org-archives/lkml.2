Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2JPTa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:30:26 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:5163 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617Ab2JPTaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:30:25 -0400
Date: Tue, 16 Oct 2012 19:30:23 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 14/14] Add documentation about the kmem controller
In-Reply-To: <507DAF56.9010403@parallels.com>
Message-ID: <0000013a6b0e332a-81258f37-814f-4b7e-8b95-193ecb9d7b9d-000000@email.amazonses.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-15-git-send-email-glommer@parallels.com> <0000013a6ad26c73-d043cf97-c44a-45c1-9cae-0a962e93a005-000000@email.amazonses.com> <507DAF56.9010403@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Glauber Costa wrote:

> A limitation of kernel memory use would be good, for example, to prevent
> abuse from non-trusted containers in a high density, shared, container
> environment.

But that would be against intentional abuse by someone who has code that
causes the kernel to use a lot of memory on its behalf. We already need
protection from that without memcg.

