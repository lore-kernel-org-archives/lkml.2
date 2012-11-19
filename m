Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2KSNrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 08:47:10 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:50286 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2KSNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 08:47:08 -0500
Message-ID: <50AA385A.90503@monom.org>
Date: Mon, 19 Nov 2012 14:47:06 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] netcls_cgroup: implement proper hierarchy support
References: <1353123062-23193-1-git-send-email-tj@kernel.org> <1353123062-23193-4-git-send-email-tj@kernel.org>
In-Reply-To: <1353123062-23193-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 17.11.2012 04:31, Tejun Heo wrote:
> @@ -112,15 +161,6 @@ struct cgroup_subsys net_cls_subsys = {
>   	.subsys_id	= net_cls_subsys_id,
>   	.base_cftypes	= ss_files,
>   	.module		= THIS_MODULE,
> -
> -	/*
> -	 * While net_cls cgroup has the rudimentary hierarchy support of
> -	 * inheriting the parent's classid on cgroup creation, it doesn't
> -	 * properly propagates config changes in ancestors to their
> -	 * descendents.  A child should follow the parent's configuration
> -	 * but be allowed to override it.  Fix it and remove the following.
> -	 */
> -	.broken_hierarchy = true,
>   };

Are you sure you want to set the default to false at this point?

cheers,
daniel
