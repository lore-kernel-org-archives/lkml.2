Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2HOKr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:47:26 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39845 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab2HOKrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:47:25 -0400
Message-ID: <502B7D7F.3070603@parallels.com>
Date: Wed, 15 Aug 2012 14:44:15 +0400
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
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-7-git-send-email-glommer@parallels.com> <20120814172540.GD6905@dhcp22.suse.cz> <502B6F00.8040207@parallels.com>
In-Reply-To: <502B6F00.8040207@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 01:42 PM, Glauber Costa wrote:
>> Also, as I
>> > have mentioned in the other email in this thread. Why should we reclaim
>> > just because of kernel allocation when we are not reclaiming any of it
>> > because shrink_slab is ignored in the memcg reclaim.
> 
> Don't get too distracted by the fact that shrink_slab is ignored. It is
> temporary, and while this being ignored now leads to suboptimal
> behavior, it will 1st, only affect its users, and 2nd, not be disastrous.
> 
> I see it this as more or less on pair with the soft limit reclaim
> problem we had. It is not ideal, but it already provided functionality
> 

Okay, I sent the e-mail before finishing it... duh

What I meant in this last sentence, is that the situation while the
memcg-aware shrinkers doesn't land in the kernel is more or less the
same (obviously not exactly) as with the soft reclaim work. It is an
evolutionary approach that provides some functionality that is not yet
perfect but already solves lots of problems for people willing to live
with its temporary drawbacks.


