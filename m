Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2KTEX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:23:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59553 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2KTEXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:23:54 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50AB05B4.4000303@jp.fujitsu.com>
Date: Tue, 20 Nov 2012 13:23:16 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, memcg: avoid unnecessary function call when memcg
 is disabled
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/20 10:44), David Rientjes wrote:
> While profiling numa/core v16 with cgroup_disable=memory on the command
> line, I noticed mem_cgroup_count_vm_event() still showed up as high as
> 0.60% in perftop.
>
> This occurs because the function is called extremely often even when memcg
> is disabled.
>
> To fix this, inline the check for mem_cgroup_disabled() so we avoid the
> unnecessary function call if memcg is disabled.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



