Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993005Ab2KOJaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:30:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46886 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422860Ab2KOJaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:30:05 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A4B609.5020902@jp.fujitsu.com>
Date: Thu, 15 Nov 2012 18:29:45 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 4/7] memcg: replace __always_inline with plain inline
References: <1352948093-2315-1-git-send-email-glommer@parallels.com> <1352948093-2315-5-git-send-email-glommer@parallels.com>
In-Reply-To: <1352948093-2315-5-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/15 11:54), Glauber Costa wrote:
> Following the pattern found in the allocators, where we do our best to
> the fast paths function-call free, all the externally visible functions
> for kmemcg were marked __always_inline.
> 
> It is fair to say, however, that this should be up to the compiler.  We
> will still keep as much of the flag testing as we can in memcontrol.h to
> give the compiler the option to inline it, but won't force it.
> 
> I tested this with 4.7.2, it will inline all three functions anyway when
> compiling with -O2, and will refrain from it when compiling with -Os.
> This seems like a good behavior.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Andrew Morton <akpm@linux-foundation.org>

I'm O.K. with this.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


