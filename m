Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084Ab2D0SQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:16:48 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:34017 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761019Ab2D0SQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:16:47 -0400
Date: Fri, 27 Apr 2012 11:16:42 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Subject: Re: [RFC][PATCH 0/7 v2] memcg: prevent failure in pre_destroy()
Message-ID: <20120427181642.GG26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9A327A.6050409@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 27, 2012 at 02:45:30PM +0900, KAMEZAWA Hiroyuki wrote:
> This is a v2 patch for preventing failure in memcg->pre_destroy().
> With this patch, ->pre_destroy() will never return error code and
> users will not see warning at rmdir(). And this work will simplify
> memcg->pre_destroy(), largely.
> 
> This patch is based on linux-next + hugetlb memory control patches.

Ergh... can you please set up a git branch somewhere for review
purposes?

Thanks.

-- 
tejun
