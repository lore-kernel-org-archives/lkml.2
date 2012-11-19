Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2KSFkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:40:42 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:28904 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2KSFkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:40:40 -0500
Message-ID: <50A9C649.9080602@huawei.com>
Date: Mon, 19 Nov 2012 13:40:25 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup, cpuset: remove cgroup_subsys->post_clone()
References: <20121113202714.GA21185@mtj.dyndns.org> <20121113202745.GB21185@mtj.dyndns.org>
In-Reply-To: <20121113202745.GB21185@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/14 4:27, Tejun Heo wrote:
>>From bbf2566f9f4fc79ff3320e83cafb69533efc9ea0 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 13 Nov 2012 12:21:50 -0800
> 
> Currently CGRP_CPUSET_CLONE_CHILDREN triggers ->post_clone().  Now
> that clone_children is cpuset specific, there's no reason to have this
> rather odd option activation mechanism in cgroup core.  cpuset can
> check the flag from its ->css_allocate() and take the necessary
> action.
> 
> Move cpuset_post_clone() logic to the end of cpuset_css_alloc() and
> remove cgroup_subsys->post_clone().
> 
> Loosely based on Glauber's "generalize post_clone into post_create"
> patch.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Original-patch-by: Glauber Costa <glommer@parallels.com>
> Original-patch: <1351686554-22592-2-git-send-email-glommer@parallels.com>
> Cc: Glauber Costa <glommer@parallels.com>

Acked-by: Li Zefan <lizefan@huawei.com>

