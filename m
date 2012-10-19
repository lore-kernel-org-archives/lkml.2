Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab2JSNeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:34:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2JSNeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:34:16 -0400
Date: Fri, 19 Oct 2012 15:34:15 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Message-ID: <20121019133415.GF799@dhcp22.suse.cz>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
 <20121018224148.GR13370@google.com>
 <20121018224606.GS13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018224606.GS13370@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 18-10-12 15:46:06, Tejun Heo wrote:
> On Thu, Oct 18, 2012 at 03:41:48PM -0700, Tejun Heo wrote:
> > Note that the patch is broken in a couple places but it does show the
> > general direction.  I'd prefer if patch #3 simply makes pre_destroy()
> > return 0 and drop __DEPRECATED_clear_css_refs from mem_cgroup_subsys.
> > Then, I can pull the branch in and drop all the unnecessary cruft.
> 
> But you need the locking change for further memcg cleanup.  To avoid
> interlocked pulls from both sides, I think it's okay to push this one
> with the rest of memcg changes.  I can do the cleanup on top of this
> whole series, but please do drop .__DEPRECATED_clear_css_refs from
> memcg.

OK I will drop that one.

>  Acked-by: Tejun Heo <tj@kernel.org>

Do you still agree with the v2 based on Li's feedback?

Thanks
-- 
Michal Hocko
SUSE Labs
