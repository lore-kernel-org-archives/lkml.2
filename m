Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab2GIF0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 01:26:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:38133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab2GIF0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 01:26:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174886713"
Date: Mon, 9 Jul 2012 13:25:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Message-ID: <20120709052549.GA11126@localhost>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881562-5900-1-git-send-email-handai.szj@taobao.com>
 <20120708145309.GC18272@localhost>
 <4FFA51AB.30203@gmail.com>
 <20120709041437.GA10180@localhost>
 <4FFA69F2.4090003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFA69F2.4090003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>Where is the MEM_CGROUP_STAT_FILE_WRITEBACK increased?
> >>>
> >>It's in account_page_writeback().
> >>
> >>  void account_page_writeback(struct page *page)
> >>  {
> >>+	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_WRITEBACK);
> >>  	inc_zone_page_state(page, NR_WRITEBACK);
> >>  }
> >I didn't find that chunk, perhaps it's lost due to rebase..
> 
> Ah? a bit weird... you can refer to the link
> http://thread.gmane.org/gmane.linux.kernel.cgroups/3134
> which is an integral one. Thanks!

Ah I got it. Sorry I overlooked it..and the new view does help make it
obvious ;)

Thanks,
Fengguang
