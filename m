Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0HXHqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:46:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44140 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0HXHqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:46:23 -0400
Date: Tue, 24 Aug 2010 13:16:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Subject: Re: [PATCH] memcg: towards I/O aware memcg v5
Message-ID: <20100824074617.GI4684@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-20 18:55:52]:

> This is v5.
> 
> Sorry for delaying...but I had time for resetting myself and..several
> changes are added. I think this version is simpler than v4.
> 
> Major changes from v4 is 
>  a) added kernel/cgroup.c hooks again. (for b)
>  b) make RCU aware. previous version seems dangerous in an extreme case.
> 
> Then, codes are updated. Most of changes are related to RCU.
> 
> Patch brief view:
>  1. add hooks to kernel/cgroup.c for ID management.
>  2. use ID-array in memcg.
>  3. record ID to page_cgroup rather than pointer.
>  4. make update_file_mapped to be RCU aware routine instead of spinlock.
>  5. make update_file_mapped as general-purpose function.
>

Thanks for being persistent, will review the patches with comments in
the relevant patches. 

-- 
	Three Cheers,
	Balbir
