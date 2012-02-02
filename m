Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab2BBR0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:26:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36117 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab2BBR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:26:17 -0500
Date: Thu, 2 Feb 2012 09:26:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        container cgroup <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] cgroup: remove cgroup_subsys argument from callbacks
Message-ID: <20120202172611.GF19837@google.com>
References: <4F278078.5030703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F278078.5030703@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 01:47:36PM +0800, Li Zefan wrote:
> The argument is not used at all, and it's not necessary, because
> a specific callback handler of course knows which subsys it
> belongs to.
> 
> Now only ->pupulate() takes this argument, because the handlers of
> this callback always call cgroup_add_file()/cgroup_add_files().
> 
> So we reduce a few lines of code, though the shrinking of object size
> is minimal.
> 
>  16 files changed, 113 insertions(+), 162 deletions(-)
> 
>    text    data     bss     dec     hex filename
> 5486240  656987 7039960 13183187         c928d3 vmlinux.o.orig
> 5486170  656987 7039960 13183117         c9288d vmlinux.o
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Nice cleanup, applied to cgroup/for-3.4.  Thank you!

-- 
tejun
