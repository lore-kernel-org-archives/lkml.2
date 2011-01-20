Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1ATUac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:30:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab1ATUab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:30:31 -0500
Date: Thu, 20 Jan 2011 21:30:30 +0100
From: Jan Kara <jack@suse.cz>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] quota: return -ENOMEM when memory allocation fails
Message-ID: <20110120203030.GC19797@quack.suse.cz>
References: <1295548325.2089.12.camel@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295548325.2089.12.camel@offworld>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-01-11 15:32:05, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
  Thanks. Applied.

								Honza

> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  fs/quota/quota_v2.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
> index 65444d2..f1ab360 100644
> --- a/fs/quota/quota_v2.c
> +++ b/fs/quota/quota_v2.c
> @@ -112,7 +112,7 @@ static int v2_read_file_info(struct super_block *sb, int type)
>  	if (!info->dqi_priv) {
>  		printk(KERN_WARNING
>  		       "Not enough memory for quota information structure.\n");
> -		return -1;
> +		return -ENOMEM;
>  	}
>  	qinfo = info->dqi_priv;
>  	if (version == 0) {
> -- 
> 1.7.1
> 
> 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
