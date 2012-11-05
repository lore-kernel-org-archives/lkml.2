Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab2KEFlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:41:51 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:34747 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2KEFlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:41:50 -0500
Message-ID: <5097517F.2040307@huawei.com>
Date: Mon, 5 Nov 2012 13:41:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 8/8] cgroup: make ->pre_destroy() return void
References: <1351712650-23709-1-git-send-email-tj@kernel.org> <1351712650-23709-9-git-send-email-tj@kernel.org>
In-Reply-To: <1351712650-23709-9-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/1 3:44, Tejun Heo wrote:
> All ->pre_destory() implementations return 0 now, which is the only
> allowed return value.  Make it return void.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Li Zefan <lizefan@huawei.com>

