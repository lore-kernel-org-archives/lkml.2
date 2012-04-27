Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2D0SSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:18:46 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:36473 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760428Ab2D0SSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:18:45 -0400
Date: Fri, 27 Apr 2012 11:18:40 -0700
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
Subject: Re: [RFC][PATCH 3/7 v2] res_counter: add
 res_counter_uncharge_until()
Message-ID: <20120427181840.GH26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A343F.7020409@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9A343F.7020409@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:53:03PM +0900, KAMEZAWA Hiroyuki wrote:
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index d508363..f4ec411 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -66,6 +66,8 @@ done:
>  	return ret;
>  }
>  
> +
> +

Contamination?

-- 
tejun
