Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab3AHQ7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:59:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab3AHQ7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:59:08 -0500
Date: Tue, 8 Jan 2013 11:58:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 17/24] blkcg: implement blkcg_policy->on/offline_pd_fn()
 and blkcg_gq->online
Message-ID: <20130108165853.GH29635@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-18-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-18-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:39PM -0800, Tejun Heo wrote:
> Add two blkcg_policy methods, ->online_pd_fn() and ->offline_pd_fn(),
> which are invoked as the policy_data gets activated and deactivated
> while holding both blkcg and q locks.
> 
> Also, add blkcg_gq->online bool, which is set and cleared as the
> blkcg_gq gets activated and deactivated.  This flag also is toggled
> while holding both blkcg and q locks.
> 
> These will be used to implement hierarchical stats.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
