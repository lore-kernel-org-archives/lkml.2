Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab1DMB7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:59:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63149 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab1DMB7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:59:13 -0400
Message-ID: <4DA50430.8020701@cn.fujitsu.com>
Date: Wed, 13 Apr 2011 10:02:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
References: <1302170153.12304.31.camel@marge.simson.net>
In-Reply-To: <1302170153.12304.31.camel@marge.simson.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-13 09:59:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-13 09:59:50,
	Serialize complete at 2011-04-13 09:59:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> Greetings,
> 
> Wrt these patches:
> 
> https://lkml.org/lkml/2010/11/24/14 [PATCH 1/2] cgroup: Set CGRP_RELEASABLE when adding to a cgroup
> https://lkml.org/lkml/2010/11/24/15 [PATCH 2/2] cgroup: Remove call to synchronize_rcu in cgroup_attach_task
> 
> I received a query regarding 2/2 because a large database company is
> apparently moving tasks between cgroups frequently enough that their
> database initialization time dropped from ~11 hours to ~4 hours when
> they applied this patch.
> 
> Curious why these got no traction.

I thought Paul was following the this. I'll spend some time on patch
review.

> 
> Regardless of the wisdom of frequent cgroup moves, Joe User launching
> light tasks via cgexec would gain quite a bit as well it seems.
> 
