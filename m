Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab2D0ViX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:38:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64351 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab2D0ViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:38:22 -0400
Date: Fri, 27 Apr 2012 14:38:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/2] res_counter: Account max_usage when calling
 res_counter_charge_nofail()
Message-ID: <20120427213817.GT26595@google.com>
References: <1335309096-12886-1-git-send-email-fweisbec@gmail.com>
 <1335309096-12886-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335309096-12886-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 01:11:36AM +0200, Frederic Weisbecker wrote:
> Updating max_usage is something one would expect when we reach
> a new maximum usage value even when we do this by forcing through
> the limit with res_counter_charge_nofail().
> 
> (Whether we want to account failcnt when we force through the limit
> is another debate).
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>

Applied to cgroup/for-3.5.  Thanks.

-- 
tejun
