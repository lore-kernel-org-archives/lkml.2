Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2HOO17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:27:59 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56338 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab2HOO14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:27:56 -0400
Message-ID: <502BB1E1.5080403@parallels.com>
Date: Wed, 15 Aug 2012 18:27:45 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-7-git-send-email-glommer@parallels.com> <20120814172540.GD6905@dhcp22.suse.cz> <502B6F00.8040207@parallels.com> <20120815130952.GI23985@dhcp22.suse.cz> <502BABCF.7020608@parallels.com> <20120815142338.GL23985@dhcp22.suse.cz>
In-Reply-To: <20120815142338.GL23985@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> I see now, you seem to be right.
> 
> No I am not because it seems that I am really blind these days...
> We were doing this in mem_cgroup_do_charge for ages:
> 	if (!(gfp_mask & __GFP_WAIT))
>                 return CHARGE_WOULDBLOCK;
> 
> /me goes to hide and get with further feedback with a clean head.
> 
> Sorry about that.
> 
I am as well, since I went to look at mem_cgroup_do_charge() and missed
that.

Do you have any other concerns specific to this patch ?

