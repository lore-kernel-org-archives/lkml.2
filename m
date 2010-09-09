Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab0IIEuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 00:50:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60877 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0IIEuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 00:50:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 9 Sep 2010 13:44:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gthelen@google.com, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        menage@google.com, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] memcg: towards I/O aware memcg v7.
Message-Id: <20100909134459.361a0f61.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100901153951.bc82c021.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100901153951.bc82c021.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010 15:39:51 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> Major changes from v6 is
>  a) added documentation about CSS ID.
>  b) fixed typos and bugs.
>  c) refleshed some comments
> 
> based on mmotm-2010-08-27
> 
> Patch brief view:
>  1. changes css ID allocation in kernel/cgroup.c
>  2. use ID-array in memcg.
>  3. record ID to page_cgroup rather than pointer.
>  4. make update_file_mapped to be RCU aware routine instead of spinlock.
>  5. make update_file_mapped as general-purpose function.
> 
> 

It seems that it will be better to re-order this series into

 A-part: lockless update of stats.
 B-part: ID managenet.

2 series. (to get ack.) Thank you for all helps.
BTW, what's the problem with ID patches ?

Thanks,
-Kame

