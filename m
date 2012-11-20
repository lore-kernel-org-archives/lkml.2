Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2KTOpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:45:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52822 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2KTOpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:45:36 -0500
Date: Tue, 20 Nov 2012 06:45:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: remove obsolete guarantee from
 cgroup_task_migrate.
Message-ID: <20121120144532.GQ15971@htj.dyndns.org>
References: <1353420379-3131-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353420379-3131-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:06:18PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> 'guarantee' is already removed from cgroup_task_migrate, so remove
> the corresponding comments. Some other typos in cgroup are also
> changed.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Applied to cgroup/for-3.8.

Thanks!

-- 
tejun
