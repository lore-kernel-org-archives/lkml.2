Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab0LHFHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:07:37 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49786 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0LHFHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:07:36 -0500
Date: Tue, 7 Dec 2010 20:47:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] compaction: Remove mem_cgroup_del_lru
Message-ID: <20101207151732.GL3158@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* MinChan Kim <minchan.kim@gmail.com> [2010-12-08 00:01:26]:

> del_page_from_lru_list alreay called mem_cgroup_del_lru.
> So we need to call it again. It makes wrong stat of memcg and
> even happen VM_BUG_ON hit.
> 
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
