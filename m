Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2K3ISg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:18:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab2K3ISd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:18:33 -0500
Date: Fri, 30 Nov 2012 09:18:28 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 6/6] cgroup: remove css_get_next
Message-ID: <20121130081828.GB29317@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
 <1353955671-14385-7-git-send-email-mhocko@suse.cz>
 <50B8322D.7050104@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B8322D.7050104@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 13:12:29, KAMEZAWA Hiroyuki wrote:
> (2012/11/27 3:47), Michal Hocko wrote:
> > Now that we have generic and well ordered cgroup tree walkers there is
> > no need to keep css_get_next in the place.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> Hm, then, the next think will be css_is_ancestor() etc..

Good point I thought that the only remaining part is swap accounting. It
is not directly with the iterators so I will send a separate patch.
Tejun said he has a replacement that could be used for the swap
accounting and then the whole css_id can be buried.

> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks for the review of the whole patchset, Kame!
I would like to hear back from Johannes and then resubmit the series to
Andrew.
-- 
Michal Hocko
SUSE Labs
