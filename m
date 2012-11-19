Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2KSRJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:09:06 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62692 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2KSRJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:09:04 -0500
Date: Mon, 19 Nov 2012 09:08:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Daniel Wagner <wagi@monom.org>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] netcls_cgroup: implement proper hierarchy support
Message-ID: <20121119170859.GI15971@htj.dyndns.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
 <1353123062-23193-4-git-send-email-tj@kernel.org>
 <50AA385A.90503@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AA385A.90503@monom.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Daniel.

On Mon, Nov 19, 2012 at 02:47:06PM +0100, Daniel Wagner wrote:
> On 17.11.2012 04:31, Tejun Heo wrote:
> >@@ -112,15 +161,6 @@ struct cgroup_subsys net_cls_subsys = {
> >  	.subsys_id	= net_cls_subsys_id,
> >  	.base_cftypes	= ss_files,
> >  	.module		= THIS_MODULE,
> >-
> >-	/*
> >-	 * While net_cls cgroup has the rudimentary hierarchy support of
> >-	 * inheriting the parent's classid on cgroup creation, it doesn't
> >-	 * properly propagates config changes in ancestors to their
> >-	 * descendents.  A child should follow the parent's configuration
> >-	 * but be allowed to override it.  Fix it and remove the following.
> >-	 */
> >-	.broken_hierarchy = true,
> >  };
> 
> Are you sure you want to set the default to false at this point?

Hmmm.... why not?  It's now implementing proper hierarchy behavior.

Thanks.

-- 
tejun
