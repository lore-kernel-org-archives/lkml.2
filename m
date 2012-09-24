Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2IXMlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:41:32 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:32911 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199Ab2IXMla convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:41:30 -0400
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-6-git-send-email-glommer@parallels.com> <20120921181458.GG7264@google.com> <506015E7.8030900@parallels.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <506015E7.8030900@parallels.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <00000139f84bdedc-aae672a6-2908-4cb8-8ed3-8fedf67a21af-000000@email.amazonses.com>
Cc: Tejun Heo <tj@kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<cgroups@vger.kernel.org>" <cgroups@vger.kernel.org>,
        "<kamezawa.hiroyu@jp.fujitsu.com>" <kamezawa.hiroyu@jp.fujitsu.com>,
        "<devel@openvz.org>" <devel@openvz.org>,
        "<linux-mm@kvack.org>" <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
X-Mailer: iPad Mail (10A403)
From: Christoph <cl@linux.com>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in kmem_create_cache
Date: Mon, 24 Sep 2012 12:41:26 +0000
To: Glauber Costa <glommer@parallels.com>
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 24, 2012, at 3:12, Glauber Costa <glommer@parallels.com> wrote:

> On 09/21/2012 10:14 PM, Tejun Heo wrote:
> 
> The new caches will appear under /proc/slabinfo with the rest, with a
> string appended that identifies the group.

There are f.e. meminfo files in the per node directories in sysfs. It would make sense to have a slabinfo file there (if you want to keep that around). Then the format would be the same.

