Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0IWLeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:34:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:53756 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab0IWLef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:34:35 -0400
Date: Thu, 23 Sep 2010 13:34:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] kernel/pm_qos_params.c: Remove unnecessary casts
 of private_data
In-Reply-To: <abede69b0f7651219da90ecb0e621466c545f15c.1283650107.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1009231334280.26813@pobox.suse.cz>
References: <cover.1283650107.git.joe@perches.com> <abede69b0f7651219da90ecb0e621466c545f15c.1283650107.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  kernel/pm_qos_params.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index b7e4c36..8414e51 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -396,7 +396,7 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  	} else
>  		return -EINVAL;
>  
> -	pm_qos_req = (struct pm_qos_request_list *)filp->private_data;
> +	pm_qos_req = filp->private_data;
>  	pm_qos_update_request(pm_qos_req, value);
>  
>  	return count;

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
