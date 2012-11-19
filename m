Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab2KSFkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:40:15 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:60400 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2KSFkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:40:11 -0500
Message-ID: <50A9C625.6020307@huawei.com>
Date: Mon, 19 Nov 2012 13:39:49 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroup: s/CGRP_CLONE_CHILDREN/CGRP_CPUSET_CLONE_CHILDREN/
References: <20121113202714.GA21185@mtj.dyndns.org>
In-Reply-To: <20121113202714.GA21185@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/14 4:27, Tejun Heo wrote:
>>From 6e405c1ae4018d813e8ed9e0bd463d6976aebfa8 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 13 Nov 2012 12:21:50 -0800
> 
> clone_children is only meaningful for cpuset and will stay that way.
> Rename the flag to reflect that and update documentation.  Also, drop
> clone_children() wrapper in cgroup.c.  The thin wrapper is used only a
> few times and one of them will go away soon.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Glauber Costa <glommer@parallels.com>

Acked-by: Li Zefan <lizefan@huawei.com>

