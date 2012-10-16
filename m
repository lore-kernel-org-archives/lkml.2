Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2JPGMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:12:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50273 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2JPGMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:12:33 -0400
Date: Mon, 15 Oct 2012 23:12:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sha Zhengju <handai.szj@taobao.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        mhocko@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
In-Reply-To: <1350367837-27919-1-git-send-email-handai.szj@taobao.com>
Message-ID: <alpine.DEB.2.00.1210152311460.9480@chino.kir.corp.google.com>
References: <1350367837-27919-1-git-send-email-handai.szj@taobao.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Sha Zhengju wrote:

> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Sysctl oom_kill_allocating_task enables or disables killing the OOM-triggering
> task in out-of-memory situations, but it only works on overall system-wide oom.
> But it's also a useful indication in memcg so we take it into consideration
> while oom happening in memcg. Other sysctl such as panic_on_oom has already
> been memcg-ware.
> 

You're working on an old kernel, mem_cgroup_out_of_memory() has moved to 
mm/memcontrol.c.  Please rebase on 3.7-rc1 and send an updated patch, 
which otherwise looks good.
