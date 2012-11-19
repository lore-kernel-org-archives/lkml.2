Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2KSJFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:05:41 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:17302 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2KSJFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:05:40 -0500
Message-ID: <50A9F5F3.3050907@huawei.com>
Date: Mon, 19 Nov 2012 17:03:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <daniel.wagner@bmw-carit.de>, <srivatsa.bhat@linux.vnet.ibm.com>,
        <john.r.fastabend@intel.com>, <nhorman@tuxdriver.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] cgroup: add cgroup->id
References: <1353093624-22608-1-git-send-email-tj@kernel.org> <1353093624-22608-2-git-send-email-tj@kernel.org>
In-Reply-To: <1353093624-22608-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/17 3:20, Tejun Heo wrote:
> With the introduction of generic cgroup hierarchy iterators, css_id is
> being phased out.  It was unnecessarily complex, id'ing the wrong
> thing (cgroups need IDs, not CSSes) and has other oddities like not
> being available at ->css_alloc().
> 
> This patch adds cgroup->id, which is a simple per-hierarchy
> ida-allocated ID which is assigned before ->css_alloc() and released
> after ->css_free().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Li Zefan <lizefan@huawei.com>

