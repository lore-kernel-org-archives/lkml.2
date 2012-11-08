Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2KHPlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:41:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63163 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2KHPls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:41:48 -0500
Date: Thu, 8 Nov 2012 07:41:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com
Subject: Re: [PATCH 8/9] cgroup_freezer: add ->post_create() and
 ->pre_destroy() and track online state
Message-ID: <20121108154142.GH12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-9-git-send-email-tj@kernel.org>
 <509B3999.6060505@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509B3999.6060505@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kamezawa.

On Thu, Nov 08, 2012 at 01:48:25PM +0900, Kamezawa Hiroyuki wrote:
> Could you explain what 'online' means here again, rather than changelog ?
> BTW, 'online' is a shared concept, between post_create() and pre_destroy(), among
> developpers ? Is it new ?

I'm prepping a patch to rename create, post_create, pre_destroy,
destroy operations to allocate, online, offline, free, so yeah the
terms and concepts will be used for all of cgroup.  I'll update the
docs in that patch.

Thanks!

-- 
tejun
