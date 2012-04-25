Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab2DYCWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:22:35 -0400
Received: from shutemov.name ([176.9.204.213]:42964 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758784Ab2DYCWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:22:15 -0400
Date: Wed, 25 Apr 2012 05:22:16 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 0/2] res_counter: Merge some common code
Message-ID: <20120425022216.GA16327@shutemov.name>
References: <1335309096-12886-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335309096-12886-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 01:11:34AM +0200, Frederic Weisbecker wrote:
> Just a small code factorizing. I hope Glauber can have a look at the second
> patch to confirm this is what we want for the net memcg controller (that
> is the only user of the nofail version AFAICS).
> 
> Thanks.
> 
> Frederic Weisbecker (2):
>   res_counter: Merge res_counter_charge and res_counter_charge_nofail
>   res_counter: Account max_usage when calling
>     res_counter_charge_nofail()
> 
>  Documentation/cgroups/resource_counter.txt |    4 +-
>  include/linux/res_counter.h                |    2 +-
>  kernel/res_counter.c                       |   71 +++++++++++++---------------
>  3 files changed, 36 insertions(+), 41 deletions(-)

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
