Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab2GGNpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 09:45:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:8758 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab2GGNpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 09:45:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174485868"
Date: Sat, 7 Jul 2012 21:45:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 1/7] memcg: update cgroup memory document
Message-ID: <20120707134528.GA23648@localhost>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881055-5511-1-git-send-email-handai.szj@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340881055-5511-1-git-send-email-handai.szj@taobao.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +dirty		- # of bytes that are waiting to get written back to the disk.
> +writeback	- # of bytes that are actively being written back to the disk.

This should be a bit more clear to the user:

dirty - # of bytes of file cache that are not in sync with the disk copy
writeback - # of bytes of file cache that are queued for syncing to disk

Thanks,
Fengguang

>  inactive_anon	- # of bytes of anonymous memory and swap cache memory on
>  		LRU list.
>  active_anon	- # of bytes of anonymous and swap cache memory on active

