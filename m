Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2KGRkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:40:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42693 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2KGRkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:40:41 -0500
Date: Wed, 7 Nov 2012 18:40:35 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 1/9 v2] cgroup: add cgroup_subsys->post_create()
Message-ID: <20121107174035.GA24475@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
 <20121107171508.GF2660@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107171508.GF2660@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-11-12 09:15:08, Tejun Heo wrote:
[...]
> This patch adds ->post_create().  It's called after all ->create()
> succeeded and the cgroup is linked into the generic cgroup hierarchy.
> This plays the counterpart of ->pre_destroy().
> 
> When used in combination with the to-be-added generic descendant
> iterators, ->post_create() can be used to implement reliable state
> inheritance.  It will be explained with the descendant iterators.

Thanks
-- 
Michal Hocko
SUSE Labs
