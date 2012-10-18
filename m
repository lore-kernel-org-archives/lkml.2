Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab2JRWsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:48:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63204 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2JRWs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:48:29 -0400
Date: Thu, 18 Oct 2012 15:48:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 6/6] hugetlb: do not fail in hugetlb_cgroup_pre_destroy
Message-ID: <20121018224825.GU13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-7-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350480648-10905-7-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 03:30:48PM +0200, Michal Hocko wrote:
> Now that pre_destroy callbacks are called from within cgroup_lock and
> the cgroup has been checked to be empty without any children then there
> is no other way to fail.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
