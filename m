Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2KSQev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:34:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63967 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2KSQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:34:50 -0500
Date: Mon, 19 Nov 2012 08:34:45 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, glommer@parallels.com
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup: allow ->post_create() to fail
Message-ID: <20121119163445.GE15971@htj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
 <50A9F3B3.2010607@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A9F3B3.2010607@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 04:54:11PM +0800, Li Zefan wrote:
> Acked-by: Li Zefan <lizefan@huawei.com>
> 
> except 0006-cgroup-remove-duplicate-RCU-free-on-struct-cgroup.patch

Patchset applied to cgroup/for-3.8 sans 0006.

Thanks.

-- 
tejun
