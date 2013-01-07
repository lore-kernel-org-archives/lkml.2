Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3AGQpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:45:00 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55854 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3AGQo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:44:57 -0500
Date: Mon, 7 Jan 2013 08:44:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] cpuset: decouple cpuset locking from cgroup core,
 take#2
Message-ID: <20130107164453.GH3926@htj.dyndns.org>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
 <50E93554.3070102@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E93554.3070102@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Sun, Jan 06, 2013 at 04:27:00PM +0800, Li Zefan wrote:
> I've reviewed and tested the patchset, and it looks good to me!
> 
> Acked-by: Li Zefan <lizefan@huawei.com>

Great.  Ummm... How should we route this?  Paul doesn't seem to be
looking at this.  I can route it through cgroup tree.  Any objections?

Thanks.

-- 
tejun
