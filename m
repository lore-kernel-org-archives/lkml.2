Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab2GYRFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:05:35 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:48958 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756446Ab2GYRFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:05:34 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xcQ.r64VM1lvuPJYLu8pVO.dgmEBBQtYM_TWyMwRGyqiB19
 0zE2NYsXQ9FBjnVJiyqNFC8hhtkuDsp1chieDlb_O.cHY8hm7uKZ94WUtKHN
 EwK_mubcNiemes1GH8ZmPbUYR5Yo9nI4__rC1wv7kuyKM9zEOdKz9kHp8UdW
 8rUSPkMJdK7R5zGLjOMy6_O.KHVSQcDYTxFh1rY78gwmhOvhHY2iro0fwTnw
 sbF5oYAbXr7fcmZ0LvXdQGmDuPZ6smZ40RVEYC0Opa.lFfZKOEOP2bxY24nk
 GdVjdNt6cJq47ABJiC7PA12aEIKRZitPwpK9NH25Mn88pHOEeBLZRoN4BDft
 vZsGbGbEn3MuDX8.lIUEwg.BCWpf5CJ.sgePlXNWqPk9EHsnWaRNx7dNRIiG
 YgvCHYp54ty6qG93L
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 25 Jul 2012 12:05:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        cgroups@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 05/10] slab: allow enable_cpu_cache to use preset values
 for its tunables
In-Reply-To: <1343227101-14217-6-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1207251204450.3543@router.home>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-6-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Glauber Costa wrote:

> SLAB allows us to tune a particular cache behavior with tunables.
> When creating a new memcg cache copy, we'd like to preserve any tunables
> the parent cache already had.

So does SLUB but I do not see a patch for that allocator.
