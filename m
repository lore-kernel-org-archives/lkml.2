Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab2LGI6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:58:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab2LGI6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:58:44 -0500
Date: Fri, 7 Dec 2012 09:58:39 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup
 iterators
Message-ID: <20121207085839.GB31938@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
 <1353955671-14385-4-git-send-email-mhocko@suse.cz>
 <CALWz4ixQR0vHp+mGJdi2q77dMHaG8BZmb+iKfMmT=T0V8X8rAg@mail.gmail.com>
 <CALWz4iwrJtG-YUkA8ZpQC=JDMs3_ZRqwjrg+OEEO+_HA_KM9UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALWz4iwrJtG-YUkA8ZpQC=JDMs3_ZRqwjrg+OEEO+_HA_KM9UA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-12-12 19:43:52, Ying Han wrote:
[...]
> Forgot to mention, I was testing 3.7-rc6 with the two cgroup changes :

Could you give a try to -mm tree as well. There are some changes for
memcgs removal in that tree which are not in Linus's tree.
-- 
Michal Hocko
SUSE Labs
