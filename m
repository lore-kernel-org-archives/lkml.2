Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0HYOPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 10:15:14 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44678 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0HYOPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 10:15:10 -0400
Date: Wed, 25 Aug 2010 19:45:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "menage@google.com" <menage@google.com>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] cgroup: do ID allocation under css allocator.
Message-ID: <20100825141500.GA32680@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100825170435.15f8eb73.kamezawa.hiroyu@jp.fujitsu.com>
 <20100825170640.5f365629.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100825170640.5f365629.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-25 17:06:40]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, css'id is allocated after ->create() is called. But to make use of ID
> in ->create(), it should be available before ->create().
> 
> In another thinking, considering the ID is tightly coupled with "css",
> it should be allocated when "css" is allocated.
> This patch moves alloc_css_id() to css allocation routine. Now, only 2 subsys,
> memory and blkio are useing ID. (To support complicated hierarchy walk.)
                       ^^^^ typo
> 
> ID will be used in mem cgroup's ->create(), later.
> 
> Note:
> If someone changes rules of css allocation, ID allocation should be moved too.
> 

What rules? could you please elaborate?

Seems cleaner, may be we need to update cgroups.txt?

-- 
	Three Cheers,
	Balbir
