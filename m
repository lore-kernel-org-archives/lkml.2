Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2DASyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 14:54:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41543 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2DASyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 14:54:36 -0400
Date: Sun, 1 Apr 2012 11:54:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Vivek Goyal <vgoyal@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup
 removal optional
Message-ID: <20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120330223423.GJ28934@google.com>
 <20120330223606.GK28934@google.com>
 <4F77B6BA.4070207@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F77B6BA.4070207@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Sun, Apr 01, 2012 at 10:00:26AM +0800, Li Zefan wrote:
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Both patches look good.
> 
> Acked-by: Li Zefan <lizefan@huawei.com>

Alright, adding the patches to cgroup/for-3.5.

> and I'd like to see code shrink with memcg updates ASAP.

Amen. :)

-- 
tejun
