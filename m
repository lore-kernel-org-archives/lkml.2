Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2D0ViH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:38:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64351 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2D0ViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:38:05 -0400
Date: Fri, 27 Apr 2012 14:37:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 1/2] res_counter: Merge res_counter_charge and
 res_counter_charge_nofail
Message-ID: <20120427213759.GS26595@google.com>
References: <1335309096-12886-1-git-send-email-fweisbec@gmail.com>
 <1335309096-12886-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335309096-12886-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 01:11:35AM +0200, Frederic Weisbecker wrote:
> These two functions do almost the same thing and duplicate some code.
> Merge their implementation into a single common function.
> res_counter_charge_locked() takes one more parameter but it doesn't seem
> to be used outside res_counter.c yet anyway.
> 
> There is no (intended) change in the behaviour.
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
