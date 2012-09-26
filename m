Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab2IZSBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:01:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60559 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2IZSB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:01:28 -0400
Date: Wed, 26 Sep 2012 11:01:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120926180124.GA12544@google.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-5-git-send-email-glommer@parallels.com>
 <20120926140347.GD15801@dhcp22.suse.cz>
 <20120926163648.GO16296@google.com>
 <50633D24.6020002@parallels.com>
 <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
 <50634105.8060302@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50634105.8060302@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 26, 2012 at 09:53:09PM +0400, Glauber Costa wrote:
> I understand your trauma about over flexibility, and you know I share of
> it. But I don't think there is any need to cap it here. Given kmem
> accounted is perfectly hierarchical, and there seem to be plenty of
> people who only care about user memory, I see no reason to disallow a
> mixed use case here.
> 
> I must say that for my particular use case, enabling it unconditionally
> would just work, so it is not that what I have in mind.

So, I'm not gonna go as far as pushing for enabling it unconditionally
but would really like to hear why it's necessary to make it per node
instead of one global switch.  Maybe it has already been discussed to
hell and back.  Care to summarize / point me to it?

Thanks.

-- 
tejun
