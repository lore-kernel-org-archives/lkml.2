Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab2HQHHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:07:16 -0400
Received: from mx2.parallels.com ([64.131.90.16]:57531 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab2HQHHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:07:13 -0400
Message-ID: <502DECE2.9090402@parallels.com>
Date: Fri, 17 Aug 2012 11:04:02 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-7-git-send-email-glommer@parallels.com> <50254475.4000201@jp.fujitsu.com> <5028BA9E.7000302@parallels.com> <502DAE2A.1000404@jp.fujitsu.com>
In-Reply-To: <502DAE2A.1000404@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 06:36 AM, Kamezawa Hiroyuki wrote:
> I just want to see the same logic used in mem_cgroup_uncharge_common().
> Hmm, at setting pc->mem_cgroup, the things happens in
>    set pc->mem_cgroup
>    set Used bit
> order. If you clear pc->mem_cgroup
>    unset Used bit
>    clear pc->mem_cgroup
> seems reasonable.

Makes sense. I'll make sure we're consistent here.

