Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1BXGUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:20:07 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53728 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1BXGUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:20:06 -0500
Date: Thu, 24 Feb 2011 11:49:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishmura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memcg: more mem_cgroup_uncharge batching
Message-ID: <20110224061931.GO3379@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.LSU.2.00.1102232139560.2239@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1102232139560.2239@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins <hughd@google.com> [2011-02-23 21:44:33]:

> It seems odd that truncate_inode_pages_range(), called not only when
> truncating but also when evicting inodes, has mem_cgroup_uncharge_start
> and _end() batching in its second loop to clear up a few leftovers, but
> not in its first loop that does almost all the work: add them there too.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
