Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2KSRFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:05:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39018 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2KSRFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:05:07 -0500
Date: Mon, 19 Nov 2012 09:05:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: daniel.wagner@bmw-carit.de, srivatsa.bhat@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: add cgroup->id
Message-ID: <20121119170501.GH15971@htj.dyndns.org>
References: <1353093624-22608-1-git-send-email-tj@kernel.org>
 <1353093624-22608-2-git-send-email-tj@kernel.org>
 <50A9F5F3.3050907@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A9F5F3.3050907@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 05:03:47PM +0800, Li Zefan wrote:
> On 2012/11/17 3:20, Tejun Heo wrote:
> > With the introduction of generic cgroup hierarchy iterators, css_id is
> > being phased out.  It was unnecessarily complex, id'ing the wrong
> > thing (cgroups need IDs, not CSSes) and has other oddities like not
> > being available at ->css_alloc().
> > 
> > This patch adds cgroup->id, which is a simple per-hierarchy
> > ida-allocated ID which is assigned before ->css_alloc() and released
> > after ->css_free().
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Acked-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.8.

Thanks.

-- 
tejun
