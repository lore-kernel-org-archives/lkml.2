Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab2FGCdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:33:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab2FGCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:33:09 -0400
Date: Thu, 7 Jun 2012 11:33:02 +0900
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: remove hierarchy_mutex
Message-ID: <20120607023302.GH21357@google.com>
References: <4FCC5792.8010203@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCC5792.8010203@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 02:37:06PM +0800, Li Zefan wrote:
> It was introduced for memcg to iterate cgroup hierarchy without
> holding cgroup_mutex, but soon after that it was replaced with
> a lockless way in memcg.
> 
> No one used hierarchy_mutex since that, so remove it.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.6.  Thanks.

-- 
tejun
