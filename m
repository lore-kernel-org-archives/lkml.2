Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2JFCO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 22:14:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2JFCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 22:14:56 -0400
Date: Sat, 6 Oct 2012 11:14:51 +0900
From: Tejun Heo <tj@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Li Zefan <lizefan@huawei.com>,
        Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: [PATCH 07/16] cgroup: fix warning when building without any
 subsys
Message-ID: <20121006021451.GA2601@localhost>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
 <1349448930-23976-8-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349448930-23976-8-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 04:55:21PM +0200, Arnd Bergmann wrote:
> In a configuration where the base cgroup support is enabled but
> every single cgroup subsys is turned off, CGROUP_BUILTIN_SUBSYS_COUNT
> is zero, which causes the sanity check code in cgroup_load_subsys
> to trigger:
> 
>        BUG_ON(ss->subsys_id >= CGROUP_BUILTIN_SUBSYS_COUNT);
>        BUG_ON(subsys[ss->subsys_id] != ss);

CGROUP_BUILTIN_SUBSYS_COUNT is already gone in mainline.  I suppose
this is no longer necessary?

Thanks.

-- 
tejun
