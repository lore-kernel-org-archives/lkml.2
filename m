Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab1EPGF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 02:05:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35749 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1EPGFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 02:05:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 16 May 2011 14:58:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH v7 10/14] memcg: dirty page accounting support
 routines
Message-Id: <20110516145811.405a6790.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTin6_CiP-Q8MyN=PKhpUhGhdmUQyEA@mail.gmail.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
	<1305276473-14780-11-git-send-email-gthelen@google.com>
	<20110513185612.84b466ec.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTin6_CiP-Q8MyN=PKhpUhGhdmUQyEA@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 May 2011 12:56:00 -0700
Greg Thelen <gthelen@google.com> wrote:

> On Fri, May 13, 2011 at 2:56 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Fri, 13 May 2011 01:47:49 -0700
> > Greg Thelen <gthelen@google.com> wrote:

> >> +static unsigned long mem_cgroup_page_stat(struct mem_cgroup *mem,
> >> +                                       enum mem_cgroup_page_stat_item item)
> >
> > How about mem_cgroup_file_cache_stat() ?
> 
> The suggested rename is possible.  But for consistency I assume we
> would also want to rename:
> * mem_cgroup_local_page_stat()
> * enum mem_cgroup_page_stat_item
> * mem_cgroup_update_page_stat()
> * mem_cgroup_move_account_page_stat()
> 

Yes, maybe clean up is necessary.

> I have a slight preference for leaving it as is,
> mem_cgroup_page_stat(), to allow for future coverage of pages other
> that just file cache pages.  But I do not feel very strongly.
> 

ok, I'm not have big concern on naming for now. please do as you like.

Thanks,
-Kame



