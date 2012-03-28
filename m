Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab2C1VK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:10:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851Ab2C1VKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:10:25 -0400
Date: Wed, 28 Mar 2012 17:10:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Suresh Jayaraman <sjayaraman@suse.com>,
        Andrea Righi <andrea@betterlinux.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] buffered write IO controller in balance_dirty_pages()
Message-ID: <20120328211017.GF3376@redhat.com>
References: <20120328121308.568545879@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328121308.568545879@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 08:13:08PM +0800, Fengguang Wu wrote:
> 
> Here is one possible solution to "buffered write IO controller", based on Linux
> v3.3
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git  buffered-write-io-controller
> 
> Features:
> - support blkio.weight

So this does proportional write bandwidth division on bdi for buffered
writes?

> - support blkio.throttle.buffered_write_bps

This is absolute limit systemwide or per bdi?

[..]
> The test results included in the last patch look pretty good in despite of the
> simple implementation.
> 
>  [PATCH 1/6] blk-cgroup: move blk-cgroup.h in include/linux/blk-cgroup.h
>  [PATCH 2/6] blk-cgroup: account dirtied pages
>  [PATCH 3/6] blk-cgroup: buffered write IO controller - bandwidth weight
>  [PATCH 4/6] blk-cgroup: buffered write IO controller - bandwidth limit
>  [PATCH 5/6] blk-cgroup: buffered write IO controller - bandwidth limit interface
>  [PATCH 6/6] blk-cgroup: buffered write IO controller - debug trace
> 

Hi Fengguang,

Only patch 0 and patch 4 have shown up in my mail box. Same seems to be
the case for lkml. I am wondering what happened to rest of the patches.

Will understand the patches better once I have the full set.

Thanks
Vivek
